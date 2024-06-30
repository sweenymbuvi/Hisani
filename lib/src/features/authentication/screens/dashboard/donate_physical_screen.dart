import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hisani/src/features/authentication/models/organization_model.dart';

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

  @override
  void initState() {
    super.initState();
    _organizationFuture = fetchOrganization(widget.organizationId);
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

      return OrganizationModel.fromSnapshot(snapshot);
    } catch (e) {
      print('Error fetching organization: $e');
      return null;
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Create a new document in the "physical_donations" collection
        await FirebaseFirestore.instance.collection('PhysicalDonations').add({
          'organizationId': widget.organizationId,
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
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final organization = snapshot.data;

          if (organization == null) {
            return Center(
                child: Text(
                    'No data found for organization ID: ${widget.organizationId}'));
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
                                  image: NetworkImage(organization.imageUrl!),
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                    items: ['New', 'Gently Used', 'Used'].map((condition) {
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
        },
      ),
    );
  }
}
