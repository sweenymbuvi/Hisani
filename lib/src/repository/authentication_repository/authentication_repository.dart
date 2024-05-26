import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hisani/src/features/authentication/screens/dashboard/dashboard.dart';
import 'package:hisani/src/features/authentication/screens/login/login_screen.dart';
import 'package:hisani/src/features/authentication/screens/mail_verification/mail_verification.dart';
import 'package:hisani/src/features/authentication/screens/welcome/welcome.dart';
import 'package:hisani/src/repository/authentication_repository/exceptions/login_failure.dart';
import 'package:hisani/src/repository/authentication_repository/exceptions/signup_email_password_failure.dart';
import 'package:hisani/src/repository/authentication_repository/exceptions/texceptions.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  late final Rx<User?> _firebaseUser;
  final _auth = FirebaseAuth.instance;

  User? get firebaseUser => _firebaseUser.value;

  @override
  void onReady() {
    super.onReady();
    _firebaseUser = Rx<User?>(_auth.currentUser);
    _firebaseUser.bindStream(_auth.userChanges());
    ever(_firebaseUser, _setInitialScreen);
    _setInitialScreen(_firebaseUser.value);
  }

  void _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => const WelcomeScreen());
    } else {
      if (user.emailVerified) {
        Get.offAll(
            () => const Dashboard()); // Replace with your dashboard screen
      } else {
        Get.offAll(() => const MailVerification());
      }
    }
  }

  Future<String?> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // Successful login, no error
    } on FirebaseAuthException catch (e) {
      final ex = LogInWithEmailAndPasswordFailure.fromCode(e.code);
      return ex.message;
    } catch (_) {
      const ex = LogInWithEmailAndPasswordFailure();
      return ex.message;
    }
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      final ex = SignupEmailPasswordFailure.code(e.code);
      throw ex;
    } catch (_) {
      const ex = SignupEmailPasswordFailure();
      throw ex;
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      final ex = TExceptions.fromCode(e.code);
      throw ex;
    } catch (_) {
      const ex = TExceptions();
      throw ex;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      await _auth.signInWithCredential(credential);

      // Redirect the user based on authentication status
      _setInitialScreen(_auth.currentUser);
    } on FirebaseAuthException catch (e) {
      final ex = TExceptions.fromCode(e.code);
      throw ex;
    } catch (_) {
      const ex = TExceptions();
      throw ex;
    }
  }

  Future<void> logout() async => await _auth.signOut();
}
