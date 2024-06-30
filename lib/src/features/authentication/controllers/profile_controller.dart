import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:hisani/src/features/authentication/models/user_model.dart';
import 'package:hisani/src/repository/authentication_repository/authentication_repository.dart';
import 'package:hisani/src/repository/user_repository/user_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  final _authRepo = Get.put(AuthenticationRepository());
  final _userRepo = Get.put(UserRepository());
  final _storage = FirebaseStorage.instance;

  Uint8List? _profileImage;
  String? _profileImageUrl; // To store the URL locally

  Uint8List? get profileImage => _profileImage;
  String? get profileImageUrl =>
      _profileImageUrl; // Getter for the profile image URL

  // Set user data and profile image URL
  void setUserData(UserModel user) {
    _profileImageUrl =
        user.profilePicUrl; // Set the profile image URL from user data
    update(); // Trigger GetX update
  }

  // Method to pick image and upload it to Firebase Storage
  Future<void> pickAndUploadProfileImage() async {
    Uint8List? pickedImageBytes;

    try {
      // Check platform
      if (GetPlatform.isWeb) {
        // Use FilePicker for web
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.image,
          allowMultiple: false,
        );

        if (result != null && result.files.isNotEmpty) {
          pickedImageBytes = result.files.first.bytes;
        }
      } else {
        // Use ImagePicker for mobile
        final picker = ImagePicker();
        final XFile? imageFile =
            await picker.pickImage(source: ImageSource.gallery);

        if (imageFile != null) {
          pickedImageBytes = await imageFile.readAsBytes();
        }
      }

      if (pickedImageBytes != null) {
        // Upload the image to Firebase Storage
        final imagePath =
            "profile_images/${DateTime.now().millisecondsSinceEpoch}.jpg";
        final uploadTask =
            await _storage.ref().child(imagePath).putData(pickedImageBytes);

        // Get the download URL of the uploaded image
        final downloadUrl = await uploadTask.ref.getDownloadURL();

        // Update the local profile image
        _profileImage = pickedImageBytes;
        _profileImageUrl = downloadUrl; // Store the URL locally

        // Update the user's profile with the new image URL
        final firebaseUser = _authRepo.firebaseUser;
        if (firebaseUser != null) {
          final email = firebaseUser.email;
          if (email != null) {
            await _userRepo.updateUserProfilePic(email, downloadUrl);
          }
        }

        update(); // Trigger GetX update
      }
    } catch (e) {
      print('Error uploading profile image: $e');
      Get.snackbar(
        'Error',
        'Failed to upload profile image. Please try again.',
      );
    }
  }

  // Fetch user data
  Future<UserModel?> getUserData() async {
    final firebaseUser = _authRepo.firebaseUser;
    final email = firebaseUser?.email;

    if (email != null) {
      final user = await _userRepo.getUserDetails(email);
      if (user != null) {
        setUserData(user); // Set user data including profile image URL
      }
      return user;
    } else {
      Get.snackbar("Error", "Login to continue");
      return null;
    }
  }

  // Fetch list of all users
  Future<List<UserModel>> getAllUsers() async => await _userRepo.allUsers();

  // Update user record
  Future<void> updateRecord(UserModel user) async {
    await _userRepo.updateUserRecord(user);
  }
}
