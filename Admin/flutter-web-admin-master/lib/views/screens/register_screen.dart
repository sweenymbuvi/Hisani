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
import 'package:web_admin/utils/app_focus_helper.dart';
import 'package:web_admin/views/widgets/public_master_layout/public_master_layout.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _passwordTextEditingController = TextEditingController();
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
    textControllerEmail.text = '';
    textControllerPassword.text = '';
    textFocusNodeEmail = FocusNode();
    textFocusNodePassword = FocusNode();
    super.initState();
  }

  Future<void> _doRegisterAsync({
    required UserDataProvider userDataProvider,
    required void Function(String message) onSuccess,
    required void Function(String message) onError,
  }) async {
    AppFocusHelper.instance.requestUnfocus();

    if (_formKey.currentState?.validate() ?? false) {
      // Validation passed.
      _formKey.currentState!.save();

      setState(() => _isFormLoading = true);

      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _formData.email,
          password: _formData.password,
        );

        if (userCredential.user != null) {
          await FirebaseFirestore.instance.collection('admins').doc(userCredential.user!.uid).set({
            'username': _formData.username,
            'email': _formData.email,
             'password': _formData.password,
            'phoneNumber': _formData.phoneNumber,
            
           // 'userProfileImageUrl': 'https://picsum.photos/id/1005/300/300',
          });

          onSuccess.call('Your account has been successfully created.');
        }
      } catch (e) {
        print('Error registering: $e');
        onError.call('Error registering. Please try again.');
      }

      setState(() => _isFormLoading = false);
    }
  }

  void _onRegisterSuccess(BuildContext context, String message) {
    final dialog = AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      desc: message,
      width: kDialogWidth,
      btnOkText: Lang.of(context).loginNow,
      btnOkOnPress: () => GoRouter.of(context).go(RouteUri.home),
    );

    dialog.show();
  }

  void _onRegisterError(BuildContext context, String message) {
    final dialog = AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      desc: message,
      width: kDialogWidth,
      btnOkText: 'OK',
      btnOkOnPress: () {},
    );

    dialog.show();
  }

  @override
  void dispose() {
    _passwordTextEditingController.dispose();
    textControllerEmail.dispose();
    textControllerPassword.dispose();
    textFocusNodeEmail.dispose();
    textFocusNodePassword.dispose();
    super.dispose();
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
                        lang.registerANewAccount,
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
                              name: 'username',
                              decoration: InputDecoration(
                                labelText: lang.username,
                                hintText: lang.username,
                                border: const OutlineInputBorder(),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                              ),
                              enableSuggestions: false,
                              validator: FormBuilderValidators.required(),
                              onSaved: (value) => (_formData.username = value ?? ''),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: kDefaultPadding * 1.5),
                            child: FormBuilderTextField(
                              name: 'email',
                              decoration: InputDecoration(
                                labelText: lang.email,
                                hintText: lang.email,
                                border: const OutlineInputBorder(),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(errorText: lang.requiredErrorText),
                                FormBuilderValidators.email(errorText: lang.emailErrorText),
                              ]),
                              onSaved: (value) => (_formData.email = value ?? ''),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: kDefaultPadding * 1.5),
                            child: FormBuilderTextField(
                              name: 'password',
                              decoration: InputDecoration(
                                labelText: lang.password,
                                hintText: lang.password,
                                helperText: lang.passwordHelperText,
                                border: const OutlineInputBorder(),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                              ),
                              enableSuggestions: false,
                              obscureText: true,
                              controller: _passwordTextEditingController,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(errorText: lang.requiredErrorText),
                                FormBuilderValidators.minLength(8, errorText: 'Value must have a length greater than or equal to 8'),
                                FormBuilderValidators.match(
                                  r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).+$',
                                  errorText: 'Password must include a combination of uppercase letters, lowercase letters, numbers, and symbols.',
                                ),
                              ]),
                              onSaved: (value) => (_formData.password = value ?? ''),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: kDefaultPadding * 1.5),
                            child: FormBuilderTextField(
                              name: 'confirmPassword',
                              decoration: InputDecoration(
                                labelText: lang.confirmPassword,
                                hintText: lang.confirmPassword,
                                border: const OutlineInputBorder(),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                              ),
                              enableSuggestions: false,
                              obscureText: true,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(errorText: lang.requiredErrorText),
                                (value) {
                                  if (_formKey.currentState?.fields['password']?.value != value) {
                                    return lang.passwordNotMatch;
                                  }
                                  return null;
                                },
                              ]),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: kDefaultPadding * 1.5),
                            child: FormBuilderTextField(
                              name: 'phoneNumber',
                              decoration: InputDecoration(
                                labelText: lang.phoneNumber,
                                hintText: lang.phoneNumber,
                                border: const OutlineInputBorder(),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                              ),
                              keyboardType: TextInputType.phone,
                              validator: FormBuilderValidators.numeric(),
                              onSaved: (value) => (_formData.phoneNumber = value ?? ''),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: kDefaultPadding),
                            child: SizedBox(
                              height: 40.0,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isFormLoading
                                    ? null
                                    : () {
                                        _doRegisterAsync(
                                          userDataProvider: context.read<UserDataProvider>(),
                                          onSuccess: (message) => _onRegisterSuccess(context, message),
                                          onError: (message) => _onRegisterError(context, message),
                                        );
                                      },
                               
                                child: _isFormLoading
                                    ? SizedBox(
                                        height: 20.0,
                                        width: 20.0,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            themeData.colorScheme.onPrimary,
                                          ),
                                        ),
                                      )
                                    : Text(lang.register),
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
  String username = '';
  String email = '';
  String password = '';
  String phoneNumber = '';
}
