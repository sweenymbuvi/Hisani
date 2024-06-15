
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hisani/src/features/authentication/models/user_model.dart';
import 'package:hisani/src/repository/authentication_repository/authentication_repository.dart';
import 'package:hisani/src/repository/user_repository/user_repository.dart';

class ProfileController extends GetxController{
static ProfileController get instance => Get.find();



//Repositories
final _authRepo = Get.put(AuthenticationRepository());
final _userRepo = Get.put(UserRepository());

  getUserData() {
    final firebaseUser = _authRepo.firebaseUser;
    final email = firebaseUser?.email;
    if (email != null) {
      return _userRepo.getUserDetails(email);
    } else {
      Get.snackbar("Error", "Login to continue");
    }
  }

//Fetch list of user records.

Future<List<UserModel>> getAllUsers() async => await _userRepo.allUsers();

updateRecord(UserModel user) async {
  await _userRepo.updateUserRecord(user);
}
}



