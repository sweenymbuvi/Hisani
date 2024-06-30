import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String fullName;
  final String email;
  final String phoneNo;
  final String password;
  final String? profilePicUrl;
  final String? secondaryEmail; // Secondary email (nullable)
  final String? secondaryPhoneNo; // Secondary phone number (nullable)

  const UserModel({
    this.id,
    required this.email,
    required this.password,
    required this.fullName,
    required this.phoneNo,
    this.profilePicUrl,
    this.secondaryEmail, // Optional secondary email
    this.secondaryPhoneNo, // Optional secondary phone number
  });

  // Convert UserModel to JSON format for Firestore
  Map<String, dynamic> toJson() {
    return {
      "FullName": fullName,
      "Email": email,
      "Phone": phoneNo,
      "Password": password,
      "ProfilePicUrl": profilePicUrl,
      "SecondaryEmail": secondaryEmail, // Include secondary email if available
      "SecondaryPhone":
          secondaryPhoneNo, // Include secondary phone if available
    };
  }

  // Create UserModel from Firestore document snapshot
  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
      id: document.id,
      email: data["Email"],
      password: data["Password"],
      fullName: data["FullName"],
      phoneNo: data["Phone"],
      profilePicUrl: data["ProfilePicUrl"],
      secondaryEmail:
          data["SecondaryEmail"], // Retrieve secondary email if available
      secondaryPhoneNo:
          data["SecondaryPhone"], // Retrieve secondary phone if available
    );
  }
}
