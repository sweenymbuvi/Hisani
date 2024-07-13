import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hisani/src/constants/colors.dart';
import 'package:hisani/src/constants/image_strings.dart';
import 'package:hisani/src/constants/sizes.dart';
import 'package:hisani/src/constants/text_strings.dart';
import 'package:hisani/src/features/authentication/controllers/profile_controller.dart';
import 'package:hisani/src/features/authentication/models/user_model.dart';
import 'package:hisani/src/features/authentication/screens/dashboard/history_screen.dart';
import 'package:hisani/src/features/authentication/screens/profile/update_profile_screen.dart';
import 'package:hisani/src/features/authentication/screens/profile/widgets/profile_menu.dart';
import 'package:hisani/src/repository/authentication_repository/authentication_repository.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(LineAwesomeIcons.angle_left_solid),
        ),
        title: Text(
          tProfile,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(LineAwesomeIcons.sun),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(tDefaultSize),
          child: FutureBuilder(
            future: controller.getUserData(),
            builder: (context, AsyncSnapshot<UserModel?> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  UserModel user = snapshot.data!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GetBuilder<ProfileController>(
                        builder: (_) {
                          return Stack(
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundImage: controller.profileImage != null
                                    ? MemoryImage(controller.profileImage!)
                                    : (controller.profileImageUrl != null &&
                                            controller
                                                .profileImageUrl!.isNotEmpty)
                                        ? NetworkImage(
                                            controller.profileImageUrl!)
                                        : const AssetImage(tProfileImage),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () =>
                                      Get.to(() => const UpdateProfileScreen()),
                                  child: Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: tPrimaryColor,
                                    ),
                                    child: const Icon(
                                      LineAwesomeIcons.pencil_alt_solid,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      Text(
                        user.fullName,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Text(
                        user.email,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () =>
                              Get.to(() => const UpdateProfileScreen()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: tPrimaryColor,
                            side: BorderSide.none,
                            shape: const StadiumBorder(),
                          ),
                          child: const Text(
                            tEditProfile,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Divider(),
                      const SizedBox(height: 10),
                      ProfileMenuWidget(
                        title: "Settings",
                        icon: LineAwesomeIcons.cog_solid,
                        onPress: () {},
                      ),
                      ProfileMenuWidget(
                        title: "History",
                        icon: LineAwesomeIcons.history_solid,
                        onPress: () async {
                          final user = await controller.getUserData();
                          if (user != null) {
                            Get.to(
                                () => HistoryScreen(fullName: user.fullName));
                          } else {
                            Get.snackbar("Error", "User data not found.");
                          }
                        },
                      ),
                      ProfileMenuWidget(
                        title: "Billing Details",
                        icon: LineAwesomeIcons.wallet_solid,
                        onPress: () {},
                      ),
                      ProfileMenuWidget(
                        title: "User Management",
                        icon: LineAwesomeIcons.user_check_solid,
                        onPress: () {},
                      ),
                      const Divider(),
                      const SizedBox(height: 10),
                      ProfileMenuWidget(
                        title: "Information",
                        icon: LineAwesomeIcons.info_solid,
                        onPress: () {},
                      ),
                      ProfileMenuWidget(
                        title: "Logout",
                        icon: LineAwesomeIcons.sign_out_alt_solid,
                        textColor: Colors.red,
                        endIcon: false,
                        onPress: () {
                          Get.defaultDialog(
                            title: "LOGOUT",
                            titleStyle: const TextStyle(fontSize: 20),
                            content: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 15.0),
                              child: Text("Are you sure, you want to Logout?"),
                            ),
                            confirm: Expanded(
                              child: ElevatedButton(
                                onPressed: () =>
                                    AuthenticationRepository.instance.logout(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  side: BorderSide.none,
                                ),
                                child: const Text("Yes"),
                              ),
                            ),
                            cancel: OutlinedButton(
                              onPressed: () => Get.back(),
                              child: const Text("No"),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  return const Center(child: Text('Something went wrong'));
                }
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}