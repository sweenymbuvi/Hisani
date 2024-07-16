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

class VacancyDetail extends StatefulWidget {
   final String id;

  const VacancyDetail({  Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<VacancyDetail> createState() => _VacancyDetailState();
}

class _VacancyDetailState extends State<VacancyDetail> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _formData = {};

  

  final FirebaseStorage _storage = FirebaseStorage.instance;

 


  Future<bool> _getDataAsync() async {
    if (widget.id.isNotEmpty) {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('Volunteering')
          .doc(widget.id)
          .get();

      if (docSnapshot.exists) {
        _formData = docSnapshot.data() as Map<String, dynamic>;
         if (_formData.containsKey('vacancies')) {
        _formData['vacancies'] = _formData['vacancies'].toString();
      }
      }
    }

    return true;
  }

  void _doSubmit(BuildContext context) async {
    AppFocusHelper.instance.requestUnfocus();

    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();

      final lang = Lang.of(context);

      final docRef =
          FirebaseFirestore.instance.collection('Volunteering').doc(widget.id);
            if (_formData.containsKey('vacancies')) {
      _formData['vacancies'] = int.tryParse(_formData['vacancies']) ?? 0;
    }
docRef.update(_formData).then((_) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          title: lang.recordSubmittedSuccessfully,
          width: kDialogWidth,
          btnOkText: 'OK',
          btnOkOnPress: () => GoRouter.of(context).go(RouteUri.vacancy),
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
            .collection('Volunteering')
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

    final pageTitle = 'Manage Volunteer Vacancies';

    return PortalMasterLayout(
      selectedMenuUri: RouteUri.vacancy,
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
                        name: 'name',
                        decoration: const InputDecoration(
                          labelText: 'Volunteer Opportunity',
                          hintText: 'Enter volunteer Opportunity',
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        validator: FormBuilderValidators.required(),
                        onChanged: (value) {
                          _formData['name'] = value;
                        },
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(bottom: kDefaultPadding * 2.0),
                      child: FormBuilderTextField(
                        name: 'location',
                        decoration: const InputDecoration(
                          labelText: 'Location',
                          hintText: 'Enter location',
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        validator: FormBuilderValidators.required(),
                        onChanged: (value) {
                          _formData['location'] = value;
                        },
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(bottom: kDefaultPadding * 2.0),
                      child: FormBuilderTextField(
                        name: 'phoneNumber',
                        decoration: const InputDecoration(
                          labelText: 'Phone',
                          hintText: 'Enter phone number',
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        validator: FormBuilderValidators.required(),
                        onChanged: (value) {
                          _formData['phoneNumber'] = value;
                        },
                      ),
                    ),
                      Padding(
                      padding:
                          const EdgeInsets.only(bottom: kDefaultPadding * 2.0),
                      child: FormBuilderTextField(
                        name: 'vacancies',
                        decoration: const InputDecoration(
                          labelText: 'Vacancies',
                          hintText: 'Enter vacancies ',
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        validator: FormBuilderValidators.required(),
                        onChanged: (value) {
                          _formData['vacancies'] = value;
                        },
                      ),
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