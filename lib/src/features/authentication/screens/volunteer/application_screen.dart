import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart'; // Import Get for snackbar and dependency injection
import 'package:hisani/src/constants/colors.dart';
import 'package:hisani/src/features/authentication/models/volunteering_model.dart';
import 'package:hisani/src/repository/user_repository/user_repository.dart';

class ApplicationScreen extends StatefulWidget {
  final String opportunityId;

  ApplicationScreen({required this.opportunityId});

  @override
  _ApplicationScreenState createState() => _ApplicationScreenState();
}

class _ApplicationScreenState extends State<ApplicationScreen> {
  String? _cvFileName; // To hold the CV file name
  List<int>? _cvFileBytes; // To hold the CV file bytes

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isSubmitting = false;

  final UserRepository _userRepo =
      Get.find(); // Initialize UserRepository with GetX

  Future<void> getUserData() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final email = firebaseUser?.email;

    if (email != null) {
      final user = await _userRepo.getUserDetails(email);
      if (user != null) {
        setState(() {
          _nameController.text = user.fullName ?? '';
          _emailController.text = user.email ?? '';
          _phoneController.text = user.phoneNo ?? '';
        });
      } else {
        Get.snackbar("Error", "Failed to fetch user details");
      }
    } else {
      Get.snackbar("Error", "Login to continue");
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData(); // Fetch user data when the screen initializes
  }

  Future<VolunteeringModel?> fetchOpportunity() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('Volunteering')
          .doc(widget.opportunityId)
          .get();

      if (!snapshot.exists) {
        return null; // Handle case where opportunity with given ID is not found
      }

      return VolunteeringModel.fromSnapshot(snapshot);
    } catch (e) {
      print('Error fetching opportunity: $e');
      return null; // Return null on error
    }
  }

  Future<void> _pickCV() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null && result.files.isNotEmpty) {
      final platformFile = result.files.single;
      final bytes = await File(platformFile.path!).readAsBytes();

      setState(() {
        _cvFileName = platformFile.name;
        _cvFileBytes = bytes;
      });
    } else {
      // User canceled the picker or no file selected
      print('File picker canceled or no file selected');
    }
  }

  Future<void> _submitApplication(VolunteeringModel opportunity) async {
    if (_cvFileBytes == null || _cvFileBytes!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please upload your CV')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Convert _cvFileBytes to Uint8List
      final cvFileBytes = Uint8List.fromList(_cvFileBytes!);

      // Upload the CV file to Firebase Storage
      final storageRef =
          FirebaseStorage.instance.ref().child('applications/$_cvFileName');
      final uploadTask = storageRef.putData(cvFileBytes);

      // Wait for the upload to complete
      await uploadTask.whenComplete(() {});

      // Get the download URL for the uploaded file
      final cvUrl = await storageRef.getDownloadURL();

      // Save application details to Firestore
      await FirebaseFirestore.instance.collection('Applications').add({
        'opportunityId': widget.opportunityId,
        'opportunityName': opportunity.name,
        'applicantName': _nameController.text,
        'applicantEmail': _emailController.text,
        'applicantPhone': _phoneController.text,
        'cvUrl': cvUrl,
        'submittedAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Application submitted successfully!')),
      );

      // Clear form
      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      setState(() {
        _cvFileName = null;
        _cvFileBytes = null;
      });
    } catch (e) {
      print('Error submitting application: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit application. Please try again.'),
        ),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Apply for Opportunity'),
        centerTitle: true,
      ),
      body: FutureBuilder<VolunteeringModel?>(
        future: fetchOpportunity(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final opportunity = snapshot.data;

          if (opportunity == null) {
            return Center(
              child: Text(
                'No data found for opportunity ID: ${widget.opportunityId}',
              ),
            );
          }

          return Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(opportunity),
                SizedBox(height: 16.h),
                _buildApplicationForm(opportunity),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(VolunteeringModel opportunity) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: AppColor.kPrimaryColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section
          Container(
            width: 80.w, // Square shape
            height: 80.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: AppColor.kPlaceholder1,
            ),
            child:
                opportunity.imageUrl != null && opportunity.imageUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Image.network(
                          opportunity.imageUrl!,
                          fit: BoxFit.cover,
                          width: 80.w,
                          height: 80.h,
                        ),
                      )
                    : Container(),
          ),
          SizedBox(width: 16.w),
          // Name section
          Expanded(
            child: Text(
              opportunity.name,
              style: TextStyle(
                fontSize: 20.h,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationForm(VolunteeringModel opportunity) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Your Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Your Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              enabled: false, // Disable email field as it's pre-filled
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Your Phone Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16.h),
            // CV Upload Section
            ElevatedButton(
              onPressed: _pickCV,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.kAccentColor,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.upload_file),
                  SizedBox(width: 8.w),
                  Text(
                    _cvFileName ?? 'Upload CV',
                    style: TextStyle(
                      fontSize: 16.h,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            if (_cvFileName != null)
              Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: Text(
                  'Selected file: $_cvFileName',
                  style: TextStyle(
                    fontSize: 14.h,
                    color: Colors.grey,
                  ),
                ),
              ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: _isSubmitting
                  ? null
                  : () {
                      _submitApplication(opportunity);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.kAccentColor,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Center(
                child: _isSubmitting
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Submit Application',
                        style: TextStyle(
                          fontSize: 16.h,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}