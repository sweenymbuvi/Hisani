import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:web_admin/app_router.dart';
import 'package:web_admin/constants/dimens.dart';
import 'package:web_admin/generated/l10n.dart';
import 'package:web_admin/theme/theme_extensions/app_button_theme.dart';
import 'package:web_admin/utils/app_focus_helper.dart';
import 'package:web_admin/views/widgets/card_elements.dart';
import 'package:web_admin/views/widgets/portal_master_layout/portal_master_layout.dart';

class CrudDetailScreen extends StatefulWidget {
  final String id;

  const CrudDetailScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<CrudDetailScreen> createState() => _CrudDetailScreenState();
}

class _CrudDetailScreenState extends State<CrudDetailScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _formData = {};
  dynamic _image;
  String? _fileName;

  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        _image = result.files.first.bytes;
        _fileName = result.files.first.name;
      });
    }
  }

  Future<String> _uploadImage() async {
    if (_image != null && _fileName != null) {
      try {
        Reference ref = _storage.ref().child('images').child(_fileName!);
        UploadTask uploadTask = ref.putData(_image!);
        TaskSnapshot snapshot = await uploadTask;
        return await snapshot.ref.getDownloadURL();
      } catch (e) {
        print('Error uploading image: $e');
        return '';
      }
    }
    return '';
  }

  Future<bool> _getDataAsync() async {
    if (widget.id.isNotEmpty) {
      DocumentSnapshot docSnapshot =
          await FirebaseFirestore.instance.collection('organizations').doc(widget.id).get();

      if (docSnapshot.exists) {
        _formData = docSnapshot.data() as Map<String, dynamic>;
      }
    }

    return true;
  }

  void _doSubmit(BuildContext context) async {
    AppFocusHelper.instance.requestUnfocus();

    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();

      final lang = Lang.of(context);

       if (_image != null) {
      _formData['imageUrl'] = await _uploadImage();
    }


      final docRef =
          FirebaseFirestore.instance.collection('organizations').doc(widget.id);

      docRef.update(_formData).then((_) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          title: lang.recordSubmittedSuccessfully,
          width: kDialogWidth,
          btnOkText: 'OK',
          btnOkOnPress: () => GoRouter.of(context).go(RouteUri.crud),
        ).show();
      }).catchError((error) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          title: lang.recordSubmitFailed,
          desc: error.toString(),
          width: kDialogWidth,
          btnOkText: 'OK',
          btnOkOnPress: () {},
        ).show();
      });
    }
  }

  void _doDelete(BuildContext context) {
    AppFocusHelper.instance.requestUnfocus();

    final lang = Lang.of(context);

    final dialog = AwesomeDialog(
      context: context,
      dialogType: DialogType.infoReverse,
      title: lang.confirmDeleteRecord,
      width: kDialogWidth,
      btnOkText: lang.yes,
      btnOkOnPress: () {
        FirebaseFirestore.instance
            .collection('organizations')
            .doc(widget.id)
            .delete()
            .then((_) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            title: lang.recordDeletedSuccessfully,
            width: kDialogWidth,
            btnOkText: 'OK',
            btnOkOnPress: () {
              // Clear form fields after successful deletion
              setState(() {
                _formData = {};
                _image = null;
                _fileName = null;
              });
              GoRouter.of(context).go(RouteUri.crud); // Navigate back to CRUD screen
            },
          ).show();
        }).catchError((error) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            title: lang.confirmDeleteRecord,
            desc: error.toString(),
            width: kDialogWidth,
            btnOkText: 'OK',
            btnOkOnPress: () {},
          ).show();
        });
      },
      btnCancelText: lang.cancel,
      btnCancelOnPress: () {},
    );

    dialog.show();
  }

  @override
  Widget build(BuildContext context) {
    final lang = Lang.of(context);
    final themeData = Theme.of(context);

   // final pageTitle =
     //   'CRUD - ${widget.id.isEmpty ? lang.crudNew : lang.crudDetail}';
final pageTitle = 'Manage Organisations';
    return PortalMasterLayout(
      selectedMenuUri: RouteUri.crud,
      body: ListView(
        padding: const EdgeInsets.all(kDefaultPadding),
        children: [
          Text(
            pageTitle,
            style: themeData.textTheme.headlineMedium,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
            child: const Divider(height: 1),
          ),
          FutureBuilder<bool>(
            future: _getDataAsync(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
        child: CircularProgressIndicator(), 
      );
              }

              if (snapshot.hasError) {
                return const Text('Error loading data.');
              }

              if (!snapshot.hasData || !(snapshot.data ?? false)) {
                return const Text('Data not available.');
              }

              return FormBuilder(
                key: _formKey,
                initialValue: _formData,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: kDefaultPadding * 2.0),
                      child: FormBuilderTextField(
                        name: 'name',
                        decoration: InputDecoration(
                          labelText: 'Name',
                          hintText: 'Enter name',
                          border: OutlineInputBorder(),
                          floatingLabelBehavior:
                              FloatingLabelBehavior.always,
                        ),
                        validator: FormBuilderValidators.required(),
                        onChanged: (value) {
                          _formData['name'] = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: kDefaultPadding * 2.0),
                      child: FormBuilderTextField(
                        name: 'location',
                        decoration: InputDecoration(
                          labelText: 'Location',
                          hintText: 'Enter location',
                          border: OutlineInputBorder(),
                          floatingLabelBehavior:
                              FloatingLabelBehavior.always,
                        ),
                        validator: FormBuilderValidators.required(),
                        onChanged: (value) {
                          _formData['location'] = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: kDefaultPadding * 2.0),
                      child: FormBuilderTextField(
                        name: 'phoneNumber',
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          hintText: 'Enter phone number',
                          border: OutlineInputBorder(),
                          floatingLabelBehavior:
                              FloatingLabelBehavior.always,
                        ),
                        validator: FormBuilderValidators.required(),
                        onChanged: (value) {
                          _formData['phoneNumber'] = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: kDefaultPadding * 2.0),
                      child: FormBuilderTextField(
                        name: 'objective',
                        decoration: InputDecoration(
                          labelText: 'Objective',
                          hintText: 'Enter objective',
                          border: OutlineInputBorder(),
                          floatingLabelBehavior:
                              FloatingLabelBehavior.always,
                        ),
                        maxLines: 5,
                        validator: FormBuilderValidators.required(),
                        onChanged: (value) {
                          _formData['objective'] = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: kDefaultPadding * 2.0),
                      child: FormBuilderTextField(
                        name: 'imageUrl',
                        decoration: InputDecoration(
                          labelText: 'Image URL',
                          hintText: 'Enter image URL',
                          border: OutlineInputBorder(),
                          floatingLabelBehavior:
                              FloatingLabelBehavior.always,
                        ),
                        onChanged: (value) {
                          _formData['imageUrl'] = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: kDefaultPadding * 2.0),
                      child: Column(
                        
                        children: [
                          ElevatedButton(
                            onPressed: _pickImage,
                             style: themeData.extension<AppButtonTheme>()?.primaryElevated,
                            child: Text('Change Image'),
                          ),
                          if (_image != null)
                            Container(
                              margin: const EdgeInsets.only(top: 16.0),
                              width: 100.0,
                              height: 100.0,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Image.memory(
                                _image,
                                fit: BoxFit.cover,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: kDefaultPadding),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                                         ElevatedButton(
                         onPressed: () => Navigator.pop(context),
                          style: themeData.extension<AppButtonTheme>()?.primaryElevated,
                          child: Text(lang.crudBack),
                        ),
                        // ElevatedButton(
                        //   onPressed: widget.id.isEmpty
                        //       ? null
                        //       : () => _doDelete(context),
                        //   // style: ElevatedButton.styleFrom(
                        //   //   backgroundColor: Colors.red,
                        //   // ),
                        //    style: themeData.extension<AppButtonTheme>()?.primaryElevated,
                        //   child: Text(lang.crudDelete),
                        // ),
       
                        ElevatedButton(
                          onPressed: () => _doSubmit(context),
                          style: themeData.extension<AppButtonTheme>()?.primaryElevated,
                          child: Text(widget.id.isEmpty ? lang.save : lang.update),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
