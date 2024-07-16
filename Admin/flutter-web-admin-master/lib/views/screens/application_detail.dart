import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:web_admin/app_router.dart';
import 'package:web_admin/constants/dimens.dart';
import 'package:web_admin/generated/l10n.dart';
import 'package:web_admin/theme/theme_extensions/app_button_theme.dart';
import 'package:web_admin/utils/app_focus_helper.dart';
import 'package:web_admin/views/widgets/portal_master_layout/portal_master_layout.dart';

class ApplicationDetail extends StatefulWidget {
  final String id;

  const ApplicationDetail({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<ApplicationDetail> createState() => _ApplicationDetailState();
}

class _ApplicationDetailState extends State<ApplicationDetail> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _formData = {};
  dynamic _image;
  String? _fileName;
  dynamic _file;

  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
      allowMultiple: false,
    );
    if (_formData.containsKey('submittedAt')) {
      _formData['submittedAt'] = Timestamp.fromDate(
        DateFormat('yyyy-MM-dd').parse(_formData['submittedAt']),
      );
    }
    if (result != null) {
      setState(() {
        _file = result.files.first.bytes;
        _fileName = result.files.first.name;
      });
    }
  }

  Future<String> _uploadFile() async {
    if (_file != null && _fileName != null) {
      try {
        Reference ref = _storage.ref().child('cv_files').child(_fileName!);
        UploadTask uploadTask = ref.putData(_file!);
        TaskSnapshot snapshot = await uploadTask;
        return await snapshot.ref.getDownloadURL();
      } catch (e) {
        print('Error uploading file: $e');
        return '';
      }
    }
    return '';
  }

  Future<bool> _getDataAsync() async {
    if (widget.id.isNotEmpty) {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('Applications')
          .doc(widget.id)
          .get();

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

      if (_file != null) {
        _formData['cvUrl'] = await _uploadFile();
      }

      final docRef =
          FirebaseFirestore.instance.collection('Applications').doc(widget.id);

          docRef.update(_formData).then((_) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          title: lang.recordSubmittedSuccessfully,
          width: kDialogWidth,
          btnOkText: 'OK',
          btnOkOnPress: () => GoRouter.of(context).go(RouteUri.applications),
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
            .collection('Applications')
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
              GoRouter.of(context).go(
                  RouteUri.applications); // Navigate back to previous screen
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

    final pageTitle = 'Manage Applications';

    return PortalMasterLayout(
      selectedMenuUri: RouteUri.applications,
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
                return const Center(
                    child: CircularProgressIndicator(color: Colors.cyan));
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
                      padding:
                          const EdgeInsets.only(bottom: kDefaultPadding * 2.0),
                      child: FormBuilderTextField(
                        name: 'applicantName',
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          hintText: 'Enter full name',
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        validator: FormBuilderValidators.required(),
                        onChanged: (value) {
                          _formData['applicantName'] = value;
                        },
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(bottom: kDefaultPadding * 2.0),
                      child: FormBuilderTextField(
                        name: 'applicantEmail',
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter email',
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        validator: FormBuilderValidators.required(),
                        onChanged: (value) {
                          _formData['applicantEmail'] = value;
                        },
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(bottom: kDefaultPadding * 2.0),
                      child: FormBuilderTextField(
                        name: 'applicantPhone',
                        decoration: const InputDecoration(
                          labelText: 'Phone',
                          hintText: 'Enter phone number',
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        validator: FormBuilderValidators.required(),
                        onChanged: (value) {
                          _formData['applicantPhone'] = value;
                        },
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(bottom: kDefaultPadding * 2.0),
                      child: FormBuilderTextField(
                        name: 'opportunityName',
                        decoration: const InputDecoration(
                          labelText: 'Opportunity Name',
                          hintText: 'Enter opportunity name',
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        validator: FormBuilderValidators.required(),
                        onChanged: (value) {
                          _formData['opportunityName'] = value;
                        },
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(bottom: kDefaultPadding * 2.0),
                      child: FormBuilderDropdown<String>(
                        name: 'status',
                        decoration: const InputDecoration(
                          labelText: 'Status',
                          hintText: 'Select application status',
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        items: [
                          DropdownMenuItem(
                            value: 'Pending',
                            child: Text('Pending'),
                          ),
                          DropdownMenuItem(
                            value: 'Approved',
                            child: Text('Approved'),
                          ),
                          DropdownMenuItem(
                            value: 'Rejected',
                            child: Text('Rejected'),
                          ),
                        ],
                        onChanged: (value) {
                          _formData['status'] = value;
                        },
                        validator: FormBuilderValidators.required(),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    OutlinedButton(
                      onPressed: _pickFile,
                      child: const Text('Upload CV'),
                    ),
                    const SizedBox(height: kDefaultPadding),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: themeData
                              .extension<AppButtonTheme>()
                              ?.primaryElevated,
                          child: Text(lang.crudBack),
                        ),
                        ElevatedButton(
                          onPressed: () => _doSubmit(context),
                          style: themeData
                              .extension<AppButtonTheme>()
                              ?.primaryElevated,
                          child:
                              Text(widget.id.isEmpty ? lang.save : lang.update),
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