
// import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:form_builder_validators/form_builder_validators.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';
// import 'package:web_admin/app_router.dart';
// import 'package:web_admin/constants/dimens.dart';
// import 'package:web_admin/generated/l10n.dart';
// import 'package:web_admin/providers/user_data_provider.dart';
// import 'package:web_admin/theme/theme_extensions/app_button_theme.dart';
// import 'package:web_admin/utils/app_focus_helper.dart';
// import 'package:web_admin/views/widgets/public_master_layout/public_master_layout.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormBuilderState>();
//   final _formData = FormData();
//   var _isFormLoading = false;

//   Future<void> _doLoginAsync({
//     required UserDataProvider userDataProvider,
//     required void Function(String message) onSuccess,
//     required void Function(String message) onError,
//   }) async {
//     AppFocusHelper.instance.requestUnfocus();

//     if (_formKey.currentState?.validate() ?? false) {
//       // Validation passed.
//       _formKey.currentState!.save();

//       setState(() => _isFormLoading = true);

//       try {
//         UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
//           email: _formData.email,
//           password: _formData.password,
//         );

//         if (userCredential.user != null) {
//           // Navigate to the dashboard
//           onSuccess.call('You have successfully logged in.');
//            GoRouter.of(context).push(RouteUri.home); 
//         }
//       } catch (e) {
//         print('Error logging in: $e');
//         onError.call('Error logging in. Please try again.');
//       }

//       setState(() => _isFormLoading = false);
//     }
//   }

// void _onLoginSuccess(BuildContext context, String message) {
//   final dialog = AwesomeDialog(
//     context: context,
//     dialogType: DialogType.success,
//     desc: message,
//     width: kDialogWidth,
//     btnOkText: Lang.of(context).continueToDashboard,
//     btnOkOnPress: () => GoRouter.of(context).go(RouteUri.dashboard),
//   );
  

//   dialog.show();
// }


//   void _onLoginError(BuildContext context, String message) {
//     final dialog = AwesomeDialog(
//       context: context,
//       dialogType: DialogType.error,
//       desc: message,
//       width: kDialogWidth,
//       btnOkText: 'OK',
//       btnOkOnPress: () {},
//     );

//     dialog.show();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final lang = Lang.of(context);
//     final themeData = Theme.of(context);

//     return PublicMasterLayout(
//       body: SingleChildScrollView(
//         child: Align(
//           alignment: Alignment.topCenter,
//           child: Container(
//             padding: const EdgeInsets.only(top: kDefaultPadding * 5.0),
//             constraints: const BoxConstraints(maxWidth: 400.0),
//             child: Card(
//               clipBehavior: Clip.antiAlias,
//               child: Padding(
//                 padding: const EdgeInsets.all(kDefaultPadding),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(bottom: kDefaultPadding),
//                       child: Image.asset(
//                         'assets/images/app_logo.png',
//                         height: 80.0,
//                       ),
//                     ),
//                     Text(
//                       lang.appTitle,
//                       style: themeData.textTheme.headlineMedium!.copyWith(
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(bottom: kDefaultPadding * 2.0),
//                       child: Text(
//                         lang.loginToYourAccount,
//                         style: themeData.textTheme.titleMedium,
//                       ),
//                     ),
//                     FormBuilder(
//                       key: _formKey,
//                       autovalidateMode: AutovalidateMode.disabled,
//                       child: Column(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(bottom: kDefaultPadding * 1.5),
//                             child: FormBuilderTextField(
//                               name: 'email',
//                               decoration: InputDecoration(
//                                 labelText: lang.email,
//                                 hintText: lang.email,
//                                 border: const OutlineInputBorder(),
//                                 floatingLabelBehavior: FloatingLabelBehavior.always,
//                               ),
//                               keyboardType: TextInputType.emailAddress,
//                               validator: FormBuilderValidators.compose([
//                                 FormBuilderValidators.required(errorText: lang.requiredErrorText),
//                                 FormBuilderValidators.email(errorText: lang.emailErrorText),
//                               ]),
//                               onSaved: (value) => (_formData.email = value ?? ''),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(bottom: kDefaultPadding * 1.5),
//                             child: FormBuilderTextField(
//                               name: 'password',
//                               decoration: InputDecoration(
//                                 labelText: lang.password,
//                                 hintText: lang.password,
//                                 helperText: lang.passwordHelperText,
//                                 border: const OutlineInputBorder(),
//                                 floatingLabelBehavior: FloatingLabelBehavior.always,
//                               ),
//                               obscureText: true,
//                               validator: FormBuilderValidators.required(errorText: lang.requiredErrorText),
//                               onSaved: (value) => (_formData.password = value ?? ''),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(bottom: kDefaultPadding),
//                             child: SizedBox(
//                               height: 40.0,
//                               width: double.infinity,
//                               child: ElevatedButton(
//                                 onPressed: _isFormLoading
//                                     ? null
//                                     : () {
//                                         _doLoginAsync(
//                                           userDataProvider: context.read<UserDataProvider>(),
//                                           onSuccess: (message) => _onLoginSuccess(context, message),
//                                           onError: (message) => _onLoginError(context, message),
//                                         );
//                                       },
//                                 child: _isFormLoading
//                                     ? SizedBox(
//                                         height: 20.0,
//                                         width: 20.0,
//                                         child: CircularProgressIndicator(
//                                           strokeWidth: 2.0,
//                                           valueColor: AlwaysStoppedAnimation<Color>(
//                                             themeData.colorScheme.onPrimary,
//                                           ),
//                                         ),
//                                       )
//                                     : Text(lang.login),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class FormData {
//   String email = '';
//   String password = '';
// }

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:web_admin/app_router.dart';
import 'package:web_admin/auth.dart';
import 'package:web_admin/constants/dimens.dart';
import 'package:web_admin/generated/l10n.dart';
import 'package:web_admin/providers/user_data_provider.dart';
import 'package:web_admin/theme/theme_extensions/app_button_theme.dart';
import 'package:web_admin/theme/theme_extensions/app_color_scheme.dart';
import 'package:web_admin/utils/app_focus_helper.dart';
import 'package:web_admin/views/screens/dashboard_screen.dart';
import 'package:web_admin/views/widgets/public_master_layout/public_master_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _formData = FormData();

  var _isFormLoading = false;
  late TextEditingController textControllerEmail;
  late FocusNode textFocusNodeEmail;

  late TextEditingController textControllerPassword;
  late FocusNode textFocusNodePassword;
  bool _isEditingPassword = false;
  bool _isEditingEmail = false;
  bool _isRegistering = false;
  bool _isLoggingIn = false;

  String? loginStatus;

  @override
  void initState() {
    textControllerEmail = TextEditingController();
    textControllerPassword = TextEditingController();
    textFocusNodeEmail = FocusNode();
    textFocusNodePassword = FocusNode();
    
    super.initState();
  }

Future<void> _doLoginAsync({
  required UserDataProvider userDataProvider,
 required void Function(String message) onSuccess,
  required void Function(String message) onError,
})async{
  AppFocusHelper.instance.requestUnfocus();

  if (_formKey.currentState?.validate() ?? false) {
    _formKey.currentState!.save();

    setState(() => _isFormLoading = true);

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _formData.email,
        password: _formData.password,
      );

      if (userCredential.user != null) {
        // Fetch user data from Firestore using the authenticated user's UID as document ID
        var userData = await FirebaseFirestore.instance.collection('admins').doc(userCredential.user!.uid).get();

        if (userData.exists) {
          var email = userData['email'];
          // Fetch any other required data fields similarly
          
          await userDataProvider.setUserDataAsync(
            email: email, 
           
          );

           await getUser();
           
        onSuccess.call('You have successfully logged in.');
        } else {
          onError.call('User data not found.');
        }
      } else {
        onError.call('Invalid username or password.');
      }
    } catch (e) {
      print('Error logging in: $e');
      onError.call('Error logging in. Please try again.');
    }

    setState(() => _isFormLoading = false);
  }
}
void _onLoginSuccess(BuildContext context, String message) {
  final dialog = AwesomeDialog(
    context: context,
    dialogType: DialogType.success,
    desc: message,
    width: kDialogWidth,
    btnOkText: Lang.of(context).dashboard,
    btnOkOnPress: () => GoRouter.of(context).go(RouteUri.dashboard),
  );
  

  dialog.show();
}

   void _onLoginError(BuildContext context, String message) {
    final dialog = AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      desc: message,
      width: 400,
      btnOkText: 'OK',
      btnOkOnPress: () {},
    );

    dialog.show();
  }

  @override
  Widget build(BuildContext context) {
    final lang = Lang.of(context);
    final themeData = Theme.of(context);

    return PublicMasterLayout(
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            padding: const EdgeInsets.only(top: kDefaultPadding * 5.0),
            constraints: const BoxConstraints(maxWidth: 400.0),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: kDefaultPadding),
                      child: Image.asset(
                        'assets/images/app_logo.png',
                        height: 80.0,
                      ),
                    ),
                    Text(
                      lang.appTitle,
                      style: themeData.textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: kDefaultPadding * 2.0),
                      child: Text(
                        lang.adminPortalLogin,
                        style: themeData.textTheme.titleMedium,
                      ),
                    ),
                    FormBuilder(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.disabled,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: kDefaultPadding * 1.5),
                            child: FormBuilderTextField(
                              focusNode: textFocusNodeEmail,
                              controller: textControllerEmail,
                              name: 'email',
                              decoration: InputDecoration(
                                labelText: lang.email,
                                hintText: lang.email,
                                border: const OutlineInputBorder(),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                              ),
                              enableSuggestions: false,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(errorText: lang.requiredErrorText),
                                FormBuilderValidators.email(errorText: lang.emailErrorText),
                              ]),
                              autofocus: false,
                              onChanged: (value) {
                                setState(() {
                                  _isEditingEmail = true;
                                });
                                _formData.email = value ?? '';
                              },
                              onSubmitted: (value) {
                                textFocusNodeEmail.unfocus();
                                FocusScope.of(context).requestFocus(textFocusNodePassword);
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: kDefaultPadding * 2.0),
                            child: FormBuilderTextField(
                              name: 'password',
                              decoration: InputDecoration(
                                labelText: lang.password,
                                hintText: lang.password,
                                helperText: lang.passwordHelperText,
                                border: const OutlineInputBorder(),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                              ),
                              focusNode: textFocusNodePassword,
                              controller: textControllerPassword,
                              enableSuggestions: false,
                              obscureText: true,
                              autofocus: false,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(errorText: lang.requiredErrorText),
                                FormBuilderValidators.minLength(8, errorText: 'Value must have a length greater than or equal to 8'),
                                FormBuilderValidators.match(
                                  r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).+$',
                                  errorText: 'Password must include a combination of uppercase letters, lowercase letters, numbers, and symbols.',
                                ),
                              ]),
                              onChanged: (value) {
                                setState(() {
                                  _isEditingPassword = true;
                                });
                                _formData.password = value ?? '';
                              },
                              onSubmitted: (value) {
                                textFocusNodePassword.unfocus();
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: kDefaultPadding),
                            child: SizedBox(
                              height: 40.0,
                              width: double.infinity,
                              child: ElevatedButton(
                                style: themeData.extension<AppButtonTheme>()!.primaryElevated,
                                onPressed: () async {
                                  setState(() {
                                    _isLoggingIn = true;
                                    textFocusNodeEmail.unfocus();
                                    textFocusNodePassword.unfocus();
                                  });

                                  await _doLoginAsync(
                                    userDataProvider: context.read<UserDataProvider>(),
                                    onSuccess: (message) => _onLoginSuccess(context, message),
                                    onError: (message) => _onLoginError(context, message),
                                  );

    
                                },
                                child: Text(lang.login),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40.0,
                            width: double.infinity,
                            child: TextButton(
                              style: themeData.extension<AppButtonTheme>()!.secondaryText,
                              onPressed: () => GoRouter.of(context).go(RouteUri.register),
                              child: RichText(
                                text: TextSpan(
                                  text: '${lang.dontHaveAnAccount} ',
                                  style: TextStyle(
                                    color: themeData.colorScheme.onSurface,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: lang.registerNow,
                                      style: TextStyle(
                                        color: themeData.extension<AppColorScheme>()!.hyperlink,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FormData {
  String email = '';
  String password = '';
}
