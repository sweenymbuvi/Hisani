import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:web_admin/app_router.dart';
import 'package:web_admin/constants/dimens.dart';
import 'package:web_admin/generated/l10n.dart';
import 'package:web_admin/theme/theme_extensions/app_button_theme.dart';
import 'package:web_admin/utils/app_focus_helper.dart';
import 'package:web_admin/views/widgets/portal_master_layout/portal_master_layout.dart';

class PhysicalDonationsDetail extends StatefulWidget {
  final String id;

  const PhysicalDonationsDetail({
    Key? key,
    required this.id,
  }) : super(key: key);


  @override
  State<PhysicalDonationsDetail> createState() => _PhysicalDonationsDetailState();
}

class _PhysicalDonationsDetailState extends State<PhysicalDonationsDetail> {
   final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _formData = {};
  
    final FirebaseStorage _storage = FirebaseStorage.instance;

      Future<bool> _getDataAsync() async {
    if (widget.id.isNotEmpty) {
      DocumentSnapshot docSnapshot =
          await FirebaseFirestore.instance.collection('PhysicalDonations').doc(widget.id).get();

      if (docSnapshot.exists) {
        _formData = docSnapshot.data() as Map<String, dynamic>;
         if (_formData.containsKey('quantity')) {
        _formData['quantity'] = _formData['quantity'].toString();
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
FirebaseFirestore.instance.collection('PhysicalDonations').doc(widget.id);
if (_formData.containsKey('quantity')) {
      _formData['quantity'] = int.tryParse(_formData['quantity']) ?? 0;
    }

      docRef.update(_formData).then((_) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          title: lang.recordSubmittedSuccessfully,
          width: kDialogWidth,
          btnOkText: 'OK',
          btnOkOnPress: () => GoRouter.of(context).go(RouteUri.dashboard),
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
            .collection('PhysicalDonations')
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
              GoRouter.of(context).go(RouteUri.dashboard); // Navigate back to previous
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

     final pageTitle = 'Manage Donations';
 


    return PortalMasterLayout(
      selectedMenuUri: RouteUri.dashboard,
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
                return const Center(child: CircularProgressIndicator(color: Colors.cyan));
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
                      padding: const EdgeInsets.only(bottom: kDefaultPadding * 2.0),
                      child: FormBuilderTextField(
                        name: 'itemName',
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          hintText: 'Enter name',
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        validator: FormBuilderValidators.required(),
                        onChanged: (value) {
                          _formData['itemName'] = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: kDefaultPadding * 2.0),
                      child: FormBuilderTextField(
                        name: 'description',
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          hintText: 'Enter description',
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        validator: FormBuilderValidators.required(),
                        onChanged: (value) {
                          _formData['description'] = value;
                        },
                      ),
                    ),
                      Padding(
                      padding: const EdgeInsets.only(bottom: kDefaultPadding * 2.0),
                      child: FormBuilderTextField(
                        name: 'organizationName',
                        decoration: const InputDecoration(
                          labelText: 'Organization',
                          hintText: 'Enter organization',
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        validator: FormBuilderValidators.required(),
                        onChanged: (value) {
                          _formData['organizationName'] = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: kDefaultPadding * 2.0),
                      child: FormBuilderTextField(
                        name: 'quantity',
                        decoration: const InputDecoration(
                          labelText: 'Quantity',
                          hintText: 'Enter quantity',
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        validator: FormBuilderValidators.required(),
                       onChanged: (value) {
      // Convert value to int if not null or empty
      if (value != null && value.isNotEmpty) {
        _formData['quantity'] = int.parse(value);
      } else {
        _formData['quantity'] = null; // Handle null case if necessary
      }
    },
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
                        //   style: themeData.extension<AppButtonTheme>()?.primaryElevated,
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
