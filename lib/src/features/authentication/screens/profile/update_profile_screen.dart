import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hisani/src/constants/colors.dart';
import 'package:hisani/src/constants/image_strings.dart';
import 'package:hisani/src/constants/sizes.dart';
import 'package:hisani/src/constants/text_strings.dart';
import 'package:hisani/src/features/authentication/controllers/profile_controller.dart';
import 'package:hisani/src/features/authentication/models/user_model.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  bool showSecondaryEmail = false;
  bool showSecondaryPhoneNo = false;

  final _formKey = GlobalKey<FormState>();

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    }
    final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegExp.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number cannot be empty';
    }
    if (value.length != 10 || !RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'Enter a valid 10-digit phone number';
    }
    return null;
  }

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
          tEditProfile,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
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
                  final id = TextEditingController(text: user.id);
                  final email = TextEditingController(text: user.email);
                  final fullName = TextEditingController(text: user.fullName);
                  final phoneNo = TextEditingController(text: user.phoneNo);
                  final secondaryEmail =
                      TextEditingController(text: user.secondaryEmail ?? '');
                  final secondaryPhoneNo =
                      TextEditingController(text: user.secondaryPhoneNo ?? '');

                  // Fetch the current password from the database
                  final currentPassword = user.password ?? '';

                  return Column(
                    children: [
                      GetBuilder<ProfileController>(
                        builder: (_) {
                          return Stack(
                            alignment: Alignment.bottomRight,
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
                              GestureDetector(
                                onTap: () async {
                                  await controller.pickAndUploadProfileImage();
                                  controller.getUserData();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: tPrimaryColor,
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: const Icon(
                                    LineAwesomeIcons.camera_solid,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 50),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: fullName,
                              decoration: const InputDecoration(
                                labelText: tFullName,
                                prefixIcon: Icon(LineAwesomeIcons.user),
                              ),
                            ),
                            const SizedBox(height: tFormHeight - 20),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: email,
                                    decoration: const InputDecoration(
                                      labelText: tEmail,
                                      prefixIcon:
                                          Icon(LineAwesomeIcons.envelope),
                                    ),
                                    validator: _validateEmail,
                                  ),
                                ),
                                IconButton(
                                  icon:
                                      Icon(LineAwesomeIcons.plus_circle_solid),
                                  onPressed: () {
                                    setState(() {
                                      showSecondaryEmail = true;
                                    });
                                  },
                                ),
                              ],
                            ),
                            if (showSecondaryEmail)
                              Column(
                                children: [
                                  const SizedBox(height: tFormHeight - 20),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: secondaryEmail,
                                          decoration: const InputDecoration(
                                            labelText: 'Secondary Email',
                                            prefixIcon:
                                                Icon(Icons.email_outlined),
                                          ),
                                          validator: _validateEmail,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(LineAwesomeIcons
                                            .minus_circle_solid),
                                        onPressed: () {
                                          setState(() {
                                            showSecondaryEmail = false;
                                            secondaryEmail.clear();
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            const SizedBox(height: tFormHeight - 20),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: phoneNo,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    decoration: const InputDecoration(
                                      labelText: tPhoneNo,
                                      prefixIcon: Icon(
                                          LineAwesomeIcons.phone_alt_solid),
                                    ),
                                    validator: _validatePhoneNumber,
                                  ),
                                ),
                                IconButton(
                                  icon:
                                      Icon(LineAwesomeIcons.plus_circle_solid),
                                  onPressed: () {
                                    setState(() {
                                      showSecondaryPhoneNo = true;
                                    });
                                  },
                                ),
                              ],
                            ),
                            if (showSecondaryPhoneNo)
                              Column(
                                children: [
                                  const SizedBox(height: tFormHeight - 20),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: secondaryPhoneNo,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          decoration: const InputDecoration(
                                            labelText: 'Secondary Phone Number',
                                            prefixIcon: Icon(LineAwesomeIcons
                                                .phone_alt_solid),
                                          ),
                                          validator: _validatePhoneNumber,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(LineAwesomeIcons
                                            .minus_circle_solid),
                                        onPressed: () {
                                          setState(() {
                                            showSecondaryPhoneNo = false;
                                            secondaryPhoneNo.clear();
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            const SizedBox(height: tFormHeight - 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    final userData = UserModel(
                                      id: id.text.trim(),
                                      email: email.text.trim(),
                                      fullName: fullName.text.trim(),
                                      phoneNo: phoneNo.text.trim(),
                                      profilePicUrl: controller.profileImageUrl,
                                      secondaryEmail:
                                          secondaryEmail.text.trim().isNotEmpty
                                              ? secondaryEmail.text.trim()
                                              : null,
                                      secondaryPhoneNo: secondaryPhoneNo.text
                                              .trim()
                                              .isNotEmpty
                                          ? secondaryPhoneNo.text.trim()
                                          : null,
                                      password:
                                          currentPassword, // Keep current password
                                    );

                                    await controller.updateRecord(userData);

                                    // Show success message and refresh data
                                    Get.snackbar(
                                      'Success',
                                      'Profile updated successfully!',
                                      backgroundColor: Colors.green,
                                      colorText: Colors.white,
                                      snackPosition: SnackPosition.BOTTOM,
                                    );

                                    setState(() {
                                      controller.getUserData();
                                    });
                                  }
                                },
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
                            const SizedBox(height: tFormHeight),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.end, // Align to end
                              children: [
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.redAccent.withOpacity(0.1),
                                    elevation: 0,
                                    foregroundColor: Colors.red,
                                    shape: const StadiumBorder(),
                                    side: BorderSide.none,
                                  ),
                                  child: const Text(tDelete),
                                ),
                              ],
                            ),
                          ],
                        ),
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
