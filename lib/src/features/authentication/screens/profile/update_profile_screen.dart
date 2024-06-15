
  
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hisani/src/constants/colors.dart';
import 'package:hisani/src/constants/image_strings.dart';
import 'package:hisani/src/constants/sizes.dart';
import 'package:hisani/src/constants/text_strings.dart';
import 'package:hisani/src/features/authentication/controllers/profile_controller.dart';
import 'package:hisani/src/features/authentication/models/user_model.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    return Scaffold(
      appBar: AppBar(
leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(LineAwesomeIcons.angle_left_solid)),
        title: Text(tEditProfile,
            style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(tDefaultSize),

        //-- Future Builder to load cload data
          child: FutureBuilder(
            future: controller.getUserData(),
            builder: (context, snapshot){
     if(snapshot.connectionState == ConnectionState.done){
                if(snapshot.hasData){
                
                  UserModel user = snapshot.data as UserModel;
 final id = TextEditingController(text: user.id);
                  //Controllers
                  final email = TextEditingController(text: user.email);
                  final password = TextEditingController(text: user.password);
                  final fullName = TextEditingController(text: user.fullName);
                  final phoneNo = TextEditingController(text: user.phoneNo);

                  return  Column(
              children: [
                // -- IMAGE with ICON
                Stack(
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: const Image(image: AssetImage(tProfileImage))),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: tPrimaryColor),
                        child: const Icon(LineAwesomeIcons.camera_solid,
                            color: Colors.black, size: 20),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
            
                // -- Form Fields
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: fullName,
                        
                        decoration: const InputDecoration(
                            label: Text(tFullName),
                            prefixIcon: Icon(LineAwesomeIcons.user)),
                      ),
                      const SizedBox(height: tFormHeight - 20),
                      TextFormField(
                        controller: email,
                       
                        decoration: const InputDecoration(
                            label: Text(tEmail),
                            prefixIcon: Icon(LineAwesomeIcons.envelope)),
                      ),
                      const SizedBox(height: tFormHeight - 20),
                      TextFormField(
                        controller: phoneNo,
                        
                        decoration: const InputDecoration(
                            label: Text(tPhoneNo),
                            prefixIcon: Icon(LineAwesomeIcons.phone_alt_solid)),
                      ),
                      const SizedBox(height: tFormHeight - 20),
                      TextFormField(
                        controller: password,
                        
                        obscureText: true,
                        decoration: InputDecoration(
                          label: const Text(tPassword),
                          prefixIcon: const Icon(Icons.fingerprint),
                          suffixIcon: IconButton(
                              icon: const Icon(LineAwesomeIcons.eye_slash),
                              onPressed: () {}),
                        ),
                      ),
                      const SizedBox(height: tFormHeight),
            
                      // -- Form Submit Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            final userData = UserModel(
                              id: id.text.trim(),
                              email: email.text.trim(),
                             password:password.text.trim(),
                              fullName:fullName.text.trim(),
                               phoneNo:phoneNo.text.trim(),
                            );


                         await controller.updateRecord(userData);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: tPrimaryColor,
                              side: BorderSide.none,
                              shape: const StadiumBorder()),
                          child: const Text(tEditProfile,
                              style: TextStyle(color: Colors.black)),
                        ),
                      ),
                      const SizedBox(height: tFormHeight),
            
                      // -- Created Date and Delete Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text.rich(
                            TextSpan(
                              text: tJoined,
                              style: TextStyle(fontSize: 12),
                              children: [
                                TextSpan(
                                    text: tJoinedAt,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12))
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.redAccent.withOpacity(0.1),
                                elevation: 0,
                                foregroundColor: Colors.red,
                                shape: const StadiumBorder(),
                                side: BorderSide.none),
                            child: const Text(tDelete),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            );
                }else if (snapshot.hasError){
    return Center(child: Text(snapshot.error.toString()));
                }else{
return const Center(child: Text('Something went wrong'));
                }
              }else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          
          ),
        ),
      ),
    );
  }
}