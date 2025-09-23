import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:propmeet/model/user_model/property_detail_model.dart';
class UserModel {
  final String? createdAt;
  final String? name;
  final String email;
  final String location;
  final int progress;
  final PropertyDetails propertyDetails;
  final List<String> selections;

  UserModel({
    this.createdAt,
    this.name,
    required this.email,
    required this.location,
    required this.progress,
    required this.propertyDetails,
    required this.selections,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> rootData,
      Map<String, dynamic> setupData) {
    String? formattedDate;
    if (rootData['createdAt'] != null && rootData['createdAt'] is Timestamp) {
      DateTime dateTime = (rootData['createdAt'] as Timestamp).toDate();
      formattedDate = DateFormat('MM/dd/yyyy').format(dateTime);
    }
    return UserModel(
      createdAt: formattedDate,
      name: rootData['name'] ?? '',
      email: rootData['email'] ?? '',
      location: setupData['location'] ?? '',
      progress: (setupData['progress'] is int)
          ? setupData['progress']
          : (setupData['progress'] as num?)?.toInt() ?? 0,
      propertyDetails: setupData['propertyDetails'] != null
          ? PropertyDetails.fromMap(
          Map<String, dynamic>.from(setupData['propertyDetails']))
          : PropertyDetails(value: '',
          bathrooms: '',
          bedrooms: '',
          carSpaces: '',
          landSize: ''),
      selections: setupData['selections'] != null
          ? List<String>.from(setupData['selections'])
          : [],
    );
  }

  UserModel copyWith({
    String? createdAt,
    String? name,
    String? email,
    String? location,
    int? progress,
    PropertyDetails? propertyDetails,
    List<String>? selections,
  }) {
    return UserModel(
      createdAt: createdAt ?? this.createdAt,
      name: name ?? this.name,
      email: email ?? this.email,
      location: location ?? this.location,
      progress: progress ?? this.progress,
      propertyDetails: propertyDetails ?? this.propertyDetails,
      selections: selections ?? this.selections,
    );
  }

  // Convert back to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "email": email,
      "createdAt": createdAt,
      "setupData": {
        "location": location,
        "progress": progress,
        "propertyDetails": propertyDetails.toMap(),
        "selections": selections,
      }
    };
  }
}


extension UserModelCompletion on UserModel {
  double get completionPercentage {
    int filled = 0;
    int total = 0;

    // Name
    total++;
    if (name != null && name!.isNotEmpty) filled++;

    // Email
    total++;
    if (email.isNotEmpty) filled++;

    // Location
    total++;
    if (location.isNotEmpty) filled++;

    // Selections (1, 2, 5)
    total += 3;
    if (selections.isNotEmpty && selections[0].isNotEmpty) filled++;
    if (selections.length > 1 && selections[1].isNotEmpty) filled++;
    if (selections.length > 4 && selections[4].isNotEmpty) filled++;

    // Property Details
    total += 5;
    if (propertyDetails.value.isNotEmpty) filled++;
    if (propertyDetails.bathrooms.isNotEmpty) filled++;
    if (propertyDetails.bedrooms.isNotEmpty) filled++;
    if (propertyDetails.carSpaces.isNotEmpty) filled++;
    if (propertyDetails.landSize.isNotEmpty) filled++;

    return filled / total;
  }
}
