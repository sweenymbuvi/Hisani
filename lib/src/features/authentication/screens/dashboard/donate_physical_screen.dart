import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hisani/src/features/authentication/models/organization_model.dart';
import 'package:hisani/src/features/authentication/models/user_model.dart';
import 'package:hisani/src/repository/authentication_repository/authentication_repository.dart';
import 'package:hisani/src/repository/user_repository/user_repository.dart';

class DonateItemScreen extends StatefulWidget {
  final String organizationId;

  DonateItemScreen({required this.organizationId});

  @override
  _DonateItemScreenState createState() => _DonateItemScreenState();
}

class _DonateItemScreenState extends State<DonateItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _itemNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _quantityController = TextEditingController();
  final _contactInfoController = TextEditingController();
  String? _selectedCondition;
  late Future<OrganizationModel?> _organizationFuture;
  late Future<UserModel?> _userFuture;
  String? _organizationName;
  String? _userFullName;
  final _authRepo = Get.put(AuthenticationRepository());
  final _userRepo = Get.put(UserRepository());

  @override
  void initState() {
    super.initState();
    _organizationFuture = fetchOrganization(widget.organizationId);
    _userFuture = getUserData();
  }

  Future<OrganizationModel?> fetchOrganization(String id) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('organizations')
          .doc(id)
          .get();

      if (!snapshot.exists) {
        return null;
      }

      final organization = OrganizationModel.fromSnapshot(snapshot);
      _organizationName = organization.name; // Store the organization's name
      return organization;
    } catch (e) {
      print('Error fetching organization: $e');
      return null;
    }
  }

  Future<UserModel?> getUserData() async {
    final firebaseUser = _authRepo.firebaseUser;
    final email = firebaseUser?.email;

    if (email != null) {
      final user = await _userRepo.getUserDetails(email);
      if (user != null) {
        setUserData(user); // Set user data including profile image URL
      }
      return user;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: Login to continue")),
      );
      return null;
    }
  }

  void setUserData(UserModel user) {
    setState(() {
      _userFullName = user.fullName; // Store the user's full name
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Create a new document in the "physical_donations" collection
        await FirebaseFirestore.instance.collection('PhysicalDonations').add({
          'organizationId': widget.organizationId,
          'organizationName':
              _organizationName, // Include the organization's name
          'userFullName': _userFullName, // Include the user's full name
          'itemName': _itemNameController.text,
          'description': _descriptionController.text,
          'quantity': int.parse(_quantityController.text),
          'condition': _selectedCondition,
          'contactInfo': _contactInfoController.text,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Show a confirmation dialog
        _showConfirmationDialog();
      } catch (e) {
        print('Error submitting donation: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error submitting donation. Please try again.')),
        );
      }
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Donation Submitted'),
          content: Text(
              'Thanks for the donation! We look forward to receiving your donation.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Close the donation screen
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donate an Item'),
      ),
      body: FutureBuilder<OrganizationModel?>(
        future: _organizationFuture,
        builder: (context, orgSnapshot) {
          if (orgSnapshot.connectionState == ConnectionState.waiting ||
              _userFuture == null) {
            return Center(child: CircularProgressIndicator());
          }

          if (orgSnapshot.hasError || _userFuture == null) {
            return Center(child: Text('Error: ${orgSnapshot.error}'));
          }

          final organization = orgSnapshot.data;

          if (organization == null) {
            return Center(
                child: Text(
                    'No data found for organization ID: ${widget.organizationId}'));
          }

          return FutureBuilder<UserModel?>(
              future: _userFuture,
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (userSnapshot.hasError || userSnapshot.data == null) {
                  return Center(child: Text('Error fetching user data'));
                }

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        // Organization Details
                        Row(
                          children: [
                            // Organization image
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                image: organization.imageUrl != null
                                    ? DecorationImage(
                                        image: NetworkImage(
                                            organization.imageUrl!),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            SizedBox(width: 16),
                            // Organization name
                            Text(
                              organization.name,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Divider(height: 32),

                        // Donation Item Details
                        Text(
                          'Donation Item Details',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _itemNameController,
                          decoration: InputDecoration(
                            labelText: 'Item Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the item name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a description';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _quantityController,
                          decoration: InputDecoration(
                            labelText: 'Quantity',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the quantity';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Condition',
                            border: OutlineInputBorder(),
                          ),
                          value: _selectedCondition,
                          items:
                              ['New', 'Gently Used', 'Used'].map((condition) {
                            return DropdownMenuItem(
                              value: condition,
                              child: Text(condition),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCondition = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select the condition';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _contactInfoController,
                          decoration: InputDecoration(
                            labelText: 'Contact Information',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your contact information';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),

                        // Submit Button
                        ElevatedButton(
                          onPressed: _submitForm,
                          child: Text('Submit Donation'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}