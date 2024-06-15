import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Correct import
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hisani/src/features/authentication/models/user_model.dart';
import 'package:image_picker/image_picker.dart'; // Make sure to import this for XFile

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;
// store user in Firestore

  void createUser(UserModel user) async {
    await _db.collection("Users").add(user.toJson()).then(
      (value) {
        Get.snackbar(
          "Success",
          "Your account has been created",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
        );
      },
    ).catchError((error) {
      Get.snackbar(
        "Error",
        "Something went wrong. Try again",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
      );
      print(error.toString());
    });
  }
  // Fetch all users/ user details
Future<UserModel> getUserDetails(String email) async{
  final snapshot = await _db.collection("Users").where("Email", isEqualTo: email).get();
  final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).first;
return userData;
}
Future<List<UserModel>> allUsers() async {
  final snapshot = await _db.collection("Users").get();
  final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
  return userData;
 }
//Update
Future<void> updateUserRecord(UserModel user) async {
  await _db.collection("Users").doc(user.id).update(user.toJson());
}

}
