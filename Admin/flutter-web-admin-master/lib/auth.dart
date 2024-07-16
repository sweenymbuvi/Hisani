

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';




final GoogleSignIn googleSignIn = GoogleSignIn();


String? userEmail;
String? imageUrl;

Future<User?> signInWithGoogle() async {

  await Firebase.initializeApp();

  User? user;

  if(kIsWeb){

    GoogleAuthProvider authProvider = GoogleAuthProvider();

    try {
      final UserCredential userCredential = 
      await _auth.signInWithPopup(authProvider);


      user = userCredential.user;
    } catch(e){
      print(e);
    }
  
  }else {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

if(googleSignInAccount != null){

  final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  try{
    final UserCredential userCredential = 
    await _auth.signInWithCredential(credential);

    user = userCredential.user;
  }on FirebaseAuthException catch (e){
    if(e.code == 'account-exists-with-different-credentials'){
      print('The account already exists with different credential.');
    }else if(e.code == 'invalid-credential'){
      print('Error occurred while accessing credentials. Try again');
    }
  }catch(e){
    print(e);
  }
}

  }

  if (user != null){
    uid = user.uid;

    username = user.displayName;
    userEmail = user.email;
    imageUrl = user.photoURL;



    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool('auth', true);
  }

  return user;

}
void signOutGoogle() async{
  await googleSignIn.signOut();
  await _auth.signOut();

SharedPreferences prefs = await SharedPreferences.getInstance();
prefs.setBool('auth', false);

uid = null;
username = null;
userEmail = null;
imageUrl = null;

print("User signed out of Google account");

}

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

String? uid;
String? username;
String? phoneNumber;
String? password;

Future<User?> registerWithEmailPassword(String email, String password) async {
  await Firebase.initializeApp();
 User? user ;
  try {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  user = userCredential.user;
   

    if (user != null) {
     uid = user.uid;
     userEmail = user.email;
      return user;
    }
  } catch (e) {
    print('Error registering user: $e');
  }

  return null;
}

Future<User?> signInWithEmailPassword(String email, String password) async {
  await Firebase.initializeApp();
User? user;
  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

  user = userCredential.user;

    if (user != null) {
      uid = user.uid;
      userEmail = user.email;
    
SharedPreferences prefs = await SharedPreferences.getInstance();
await prefs.setBool('auth', true);
    }
  } on FirebaseAuthException catch (e){
    if(e.code == 'user-not-found'){
      print ('No user found for that email.');
    }else if (e.code == 'wrong-password'){
      print('Wrong password provided');
    }
  }
  return user;
}
  
Future<String> signOut() async {

  await _auth.signOut();

SharedPreferences prefs = await SharedPreferences.getInstance();
prefs.setBool('auth', false);

uid = null;

userEmail = null;

return 'User signed out';

}
Future<void> addAdminData(String name, String email) async {
  try {
    await FirebaseFirestore.instance.collection('admins').add({
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
      'password': password,
      // Add more fields as needed
    });
    print('Data added successfully');
  } catch (e) {
    print('Error adding data: $e');
  }
}



Future<void> getUser() async{

  await Firebase.initializeApp();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool authSignedIn = prefs.getBool('auth') ?? false;


final User? user = _auth.currentUser;

if(authSignedIn /*== true*/){
  if(user != null){
    uid = user.uid;
    username = user.displayName;
    userEmail = user.email;
    imageUrl = user.photoURL;
  }
}
}
