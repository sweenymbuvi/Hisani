import 'package:cloud_firestore/cloud_firestore.dart';

class VolunteeringModel {
  final String id; // Non-nullable ID for Firestore document ID
  final String name;
  final String location;
  final String description;
  final String phoneNumber;
  final int vacancies;
  final String imageUrl;

  VolunteeringModel({
    required this.id,
    required this.name,
    required this.location,
    required this.description,
    required this.phoneNumber,
    required this.vacancies,
    required this.imageUrl,
  });

  // Factory constructor to create an instance from a Firestore document snapshot
  factory VolunteeringModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;

    return VolunteeringModel(
      id: snapshot.id,
      name: data['name'] ?? 'No Name',
      location: data['location'] ?? 'No Location',
      description: data['description'] ?? 'No Description',
      phoneNumber: data['phoneNumber'] ?? 'No Phone Number',
      vacancies: data['vacancies'] ?? 0,
      imageUrl: data['imageUrl'] ?? '',
    );
  }

  // Method to convert an instance to a map (for Firestore storage)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'description': description,
      'phoneNumber': phoneNumber,
      'vacancies': vacancies,
      'imageUrl': imageUrl,
    };
  }
}
