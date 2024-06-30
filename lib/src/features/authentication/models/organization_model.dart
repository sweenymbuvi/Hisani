import 'package:cloud_firestore/cloud_firestore.dart';

class OrganizationModel {
  final String id; // Ensure id is non-nullable because it's always expected
  final String name;
  final String phoneNumber;
  final String objective;
  final String category;
  final List<DonationNeed> donationNeeds;
  final String location;
  final String imageUrl;

  OrganizationModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.objective,
    required this.category,
    required this.donationNeeds,
    required this.location,
    required this.imageUrl,
  });

  factory OrganizationModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    List<DonationNeed> needs = (data['donationNeeds'] as List<dynamic>)
        .map((item) => DonationNeed.fromMap(item as Map<String, dynamic>))
        .toList();

    return OrganizationModel(
      id: snapshot.id,
      name: data['name'] ?? 'No Name',
      phoneNumber: data['phoneNumber'] ?? 'No Phone Number',
      objective: data['objective'] ?? 'No Objective',
      donationNeeds: needs,
      location: data['location'] ?? 'No Location',
      imageUrl: data['imageUrl'] ?? '',
      category: 'No category',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'objective': objective,
      'donationNeeds': donationNeeds.map((need) => need.toJson()).toList(),
      'location': location,
      'imageUrl': imageUrl,
    };
  }
}

class DonationNeed {
  final String item;
  final int quantity;
  final String urgency;
  final String description;

  DonationNeed({
    required this.item,
    required this.quantity,
    required this.urgency,
    required this.description,
  });

  factory DonationNeed.fromMap(Map<String, dynamic> map) {
    return DonationNeed(
      item: map['item'] ?? 'No Item',
      quantity: map['quantity'] ?? 0,
      urgency: map['urgency'] ?? 'No Urgency',
      description: map['description'] ?? 'No Description',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item': item,
      'quantity': quantity,
      'urgency': urgency,
      'description': description,
    };
  }
}
