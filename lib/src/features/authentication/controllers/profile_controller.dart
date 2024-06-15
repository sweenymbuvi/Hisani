import 'dart:typed_data';
import 'dart:io'; // Required for File operations on mobile
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
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

  Uint8List? get profileImage => _profileImage;

  // Pick image from gallery and upload to Firebase Storage
  Future<void> pickAndUploadProfileImage() async {
    // Check if running on web
    if (GetPlatform.isWeb) {
      // Use file_picker for web
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) return;

      Uint8List? fileBytes = result.files.first.bytes;
      String fileName =
          "profile_images/${DateTime.now().millisecondsSinceEpoch}.jpg";

      try {
        // Upload image to Firebase Storage
        final uploadTask =
            await _storage.ref().child(fileName).putData(fileBytes!);
        final url = await uploadTask.ref.getDownloadURL();

        // Update user profile with image URL
        await _userRepo.uploadImage(_authRepo.firebaseUser!.uid, url as XFile);

        // Update local profile image
        _profileImage = fileBytes;
        update(); // Update GetX reactive variables
      } catch (e) {
        print('Error uploading profile image: $e');
        // Handle error as needed
      }
    } else {
      // Use image_picker for mobile
      final picker = ImagePicker();
      final XFile? imageFile =
          await picker.pickImage(source: ImageSource.gallery);
      if (imageFile == null) return;

      final imagePath =
          "profile_images/${DateTime.now().millisecondsSinceEpoch}.jpg";

      try {
        // On mobile platforms, convert XFile to File
        final File file = File(imageFile.path);

        // Upload image to Firebase Storage
        final TaskSnapshot uploadTask =
            await _storage.ref().child(imagePath).putFile(file);

        // Get download URL from Firebase Storage
        final url = await uploadTask.ref.getDownloadURL();

        // Update user profile with image URL
        await _userRepo.uploadImage(_authRepo.firebaseUser!.uid, url as XFile);

        // Update local profile image
        _profileImage = await imageFile.readAsBytes();
        update(); // Update GetX reactive variables
      } catch (e) {
        print('Error uploading profile image: $e');
        // Handle error as needed
      }
    }
  }

  // Get user data asynchronously
  Future<UserModel?> getUserData() async {
    final firebaseUser = _authRepo.firebaseUser;
    final email = firebaseUser?.email;
    if (email != null) {
      return await _userRepo.getUserDetails(email);
    } else {
      Get.snackbar("Error", "Login to continue");
      return null;
    }
  }

  // Fetch list of user records
  Future<List<UserModel>> getAllUsers() async => await _userRepo.allUsers();

  // Update user record
  Future<void> updateRecord(UserModel user) async {
    await _userRepo.updateUserRecord(user);
  }
}
