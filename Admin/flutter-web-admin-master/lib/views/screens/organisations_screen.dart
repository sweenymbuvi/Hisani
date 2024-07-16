import 'dart:convert';

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
import 'package:web_admin/theme/theme_extensions/app_color_scheme.dart';
import 'package:web_admin/utils/app_focus_helper.dart';
import 'package:web_admin/views/widgets/organisations_widget.dart';
import 'package:web_admin/views/widgets/portal_master_layout/portal_master_layout.dart';

class MyOrganizationsScreen extends StatefulWidget {
  const MyOrganizationsScreen({Key? key}) : super(key: key);

  @override
  State<MyOrganizationsScreen> createState() => _MyOrganizationsScreenState();
}

class _MyOrganizationsScreenState extends State<MyOrganizationsScreen> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormBuilderState>();
  dynamic _image;
  String? fileName;

  String? name;
  String? phoneNumber;
  String? location;
  String? objective;

  // List to hold the donation needs fields and their values
  List<Map<String, dynamic>> donationNeeds = [];
  List<Widget> donationNeedWidgets = [];

  List<String> categoryOptions = [
    "Children's Home",
    'Schools',
    'Health',
    'Other',
  ];

  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    // Start with one donation need
    _addDonationNeed();
  }

  void uploadOrganisation() async {
    if (_formKey.currentState!.validate()) {
      try {
        String imageUrl = await _uploadOrganisationToStorage(_image);
        // Uploading the organization data with donation needs
        DocumentReference docRef =
            await _firestore.collection('organizations').add({
          'category': selectedCategory,
          'name': name,
          'imageUrl': imageUrl,
          'phoneNumber': phoneNumber,
          'location': location,
          'objective': objective,
          'donationNeeds': donationNeeds,
        });
        _showSuccessDialog();
        _clearFields();
      } catch (e) {
        _showErrorDialog('Error uploading organization: $e');
      }
    } else {
      _showErrorDialog('Form validation failed.');
    }
  }

  Future<String> _uploadOrganisationToStorage(dynamic image) async {
    try {
      Reference ref = _storage.ref().child('organizations').child(fileName!);
      UploadTask uploadTask = ref.putData(image);
      TaskSnapshot snapshot = await uploadTask;
      // Get download URL after successful upload
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

  void _showSuccessDialog() {
    final lang = Lang.of(context);

    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      title: lang.recordSavedSuccessfully,
      width: kDialogWidth,
      btnOkText: 'OK',
      btnOkOnPress: () {},
    ).show();
  }

  void _showErrorDialog(String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      title: 'Error',
      desc: message,
      width: kDialogWidth,
      btnOkText: 'OK',
      btnOkOnPress: () {},
    ).show();
  }

  void _clearFields() {
    _formKey.currentState!.reset();
    setState(() {
      _image = null;
      fileName = null;
      name = null;
      phoneNumber = null;
      location = null;
      objective = null;
      donationNeeds = [];
      donationNeedWidgets = [];
      selectedCategory = null;
      _addDonationNeed(); // Reset with one donation need field set
    });
  }

  void _addDonationNeed() {
    setState(() {
      int index = donationNeeds.length;
      donationNeeds.add({});
      donationNeedWidgets.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text(
              'Donation Need ${index + 1}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            FormBuilderTextField(
              name: 'item_$index',
              decoration: InputDecoration(
                labelText: 'Item',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                donationNeeds[index]['item'] = value;
              },
              validator: FormBuilderValidators.required(),
            ),
            SizedBox(height: 8),
            FormBuilderTextField(
              name: 'quantity_$index',
              decoration: InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // Parse quantity to int if not null or empty
                if (value!.isNotEmpty) {
                  donationNeeds[index]['quantity'] = int.parse(value);
                } else {
                  donationNeeds[index]['quantity'] = null;
                }
              },
              validator: FormBuilderValidators.required(),
            ),
            SizedBox(height: 8),
            FormBuilderDropdown(
              name: 'urgency_$index',
              decoration: InputDecoration(
                labelText: 'Urgency',
                border: OutlineInputBorder(),
              ),
              items: ['Low', 'Medium', 'High']
                  .map((urgency) => DropdownMenuItem(
                        value: urgency,
                        child: Text(urgency),
                      ))
                  .toList(),
              onChanged: (value) {
                donationNeeds[index]['urgency'] = value;
              },
              validator: FormBuilderValidators.required(),
            ),
            SizedBox(height: 8),
            FormBuilderTextField(
              name: 'description_$index',
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                donationNeeds[index]['description'] = value;
              },
              validator: FormBuilderValidators.required(),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = Lang.of(context);
    final themeData = Theme.of(context);
    final appColorScheme = themeData.extension<AppColorScheme>()!;

    return PortalMasterLayout(
      body: ListView(
        padding: const EdgeInsets.all(kDefaultPadding),
        children: [
          Text(
            lang.myOrganizations,
            style: themeData.textTheme.headlineMedium,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: FormBuilder(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: kDefaultPadding * 2.0),
                        child: FormBuilderDropdown(
                          name: 'category',
                          decoration: const InputDecoration(
                            labelText: 'Category',
                            hintText: 'Select Category',
                            border: OutlineInputBorder(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          items: categoryOptions
                              .map((category) => DropdownMenuItem(
                                    value: category,
                                    child: Text(category),
                                  ))
                              .toList(),
                          validator: FormBuilderValidators.required(),
                          onChanged: (value) {
                            setState(() {
                              selectedCategory = value as String?;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: kDefaultPadding * 2.0),
                        child: FormBuilderTextField(
                          name: 'name',
                          decoration: const InputDecoration(
                            labelText: 'Organization Name',
                            hintText: 'Enter organization name',
                            border: OutlineInputBorder(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          validator: FormBuilderValidators.required(),
                          onChanged: (value) {
                            name = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: kDefaultPadding * 2.0),
                        child: FormBuilderTextField(
                          name: 'phone_number',
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                            hintText: 'Enter phone number',
                            border: OutlineInputBorder(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          keyboardType: TextInputType.phone,
                          validator: FormBuilderValidators.required(),
                          onChanged: (value) {
                            phoneNumber = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: kDefaultPadding * 2.0),
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
                            location = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: kDefaultPadding * 2.0),
                        child: FormBuilderTextField(
                          name: 'objective',
                          decoration: const InputDecoration(
                            labelText: 'Objective',
                            hintText: 'Enter objective',
                            border: OutlineInputBorder(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          maxLines: 5,
                          validator: FormBuilderValidators.required(),
                          onChanged: (value) {
                            objective = value;
                          },
                        ),
                      ),
                      // Display all donation needs widgets
                      ...donationNeedWidgets,
                      SizedBox(height: kDefaultPadding),
                      // Button to add new donation needs fields
                      ElevatedButton(
                        onPressed: _addDonationNeed,
                        child: const Text('Add Donation Need'),
                      ),
                      SizedBox(height: kDefaultPadding), // Added space here
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: kDefaultPadding * 2.0),
                        child: Column(
                          children: [
                            ElevatedButton(
                              onPressed: pickImage,
                              child: const Text('Upload Image'),
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
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: uploadOrganisation,
                          child: Text(lang.save),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      _image = result.files.single.bytes;
      fileName = result.files.single.name;
      setState(() {});
    } else {
      // User canceled the picker
    }
  }
}
