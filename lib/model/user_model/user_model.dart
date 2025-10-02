import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:propmeet/model/user_model/property_detail_model.dart';

class UserModel {
  final String? userId;
  final String? createdAt;
  final String? name;
  final String email;
  final String location;
  final int progress;
  final PropertyDetails propertyDetails;
  final List<String> selections;

  // New swipe-related fields
  final int swipeCount;
  final List<String> liked;
  final List<String> disliked;

  UserModel({
    this.userId,
    this.createdAt,
    this.name,
    required this.email,
    required this.location,
    required this.progress,
    required this.propertyDetails,
    required this.selections,
    this.swipeCount = 0,
    this.liked = const [],
    this.disliked = const [],
  });

  //Use this when fetching from Firestore
  factory UserModel.fromFirestore(DocumentSnapshot doc, Map<String, dynamic> setupData) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel.fromMap(data, setupData, userId: doc.id);
  }

  // Use this when you already have a Map
  factory UserModel.fromMap(Map<String, dynamic> rootData, Map<String, dynamic> setupData, {String? userId}) {
    String? formattedDate;
    if (rootData['createdAt'] != null && rootData['createdAt'] is Timestamp) {
      DateTime dateTime = (rootData['createdAt'] as Timestamp).toDate();
      formattedDate = DateFormat('MM/dd/yyyy').format(dateTime);
    }

    return UserModel(
      userId: userId ?? '',
      createdAt: formattedDate,
      name: rootData['name'] ?? '',
      email: rootData['email'] ?? '',
      location: setupData['location'] ?? '',
      progress: (setupData['progress'] is int)
          ? setupData['progress']
          : (setupData['progress'] as num?)?.toInt() ?? 0,
      propertyDetails: setupData['propertyDetails'] != null
          ? PropertyDetails.fromMap(Map<String, dynamic>.from(setupData['propertyDetails']))
          : PropertyDetails(value: '', bathrooms: '', bedrooms: '', carSpaces: '', landSize: ''),
      selections: setupData['selections'] != null
          ? List<String>.from(setupData['selections'])
          : [],

      // Swipes data (safe fallback if missing)
      swipeCount: rootData['swipes']?['count'] ?? 0,
      liked: rootData['swipes']?['liked'] != null ? List<String>.from(rootData['swipes']['liked']) : [],
      disliked: rootData['swipes']?['disliked'] != null ? List<String>.from(rootData['swipes']['disliked']) : [],
    );
  }

  UserModel copyWith({
    String? userId,
    String? createdAt,
    String? name,
    String? email,
    String? location,
    int? progress,
    PropertyDetails? propertyDetails,
    List<String>? selections,
    int? swipeCount,
    List<String>? liked,
    List<String>? disliked,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      name: name ?? this.name,
      email: email ?? this.email,
      location: location ?? this.location,
      progress: progress ?? this.progress,
      propertyDetails: propertyDetails ?? this.propertyDetails,
      selections: selections ?? this.selections,
      swipeCount: swipeCount ?? this.swipeCount,
      liked: liked ?? this.liked,
      disliked: disliked ?? this.disliked,
    );
  }
}

extension UserModelCompletion on UserModel {
  double get completionPercentage {
    int filled = 0;
    int total = 0;

    total++;
    if (name != null && name!.isNotEmpty) filled++;

    total++;
    if (email.isNotEmpty) filled++;

    total++;
    if (location.isNotEmpty) filled++;

    total += 3;
    if (selections.isNotEmpty && selections[0].isNotEmpty) filled++;
    if (selections.length > 1 && selections[1].isNotEmpty) filled++;
    if (selections.length > 4 && selections[4].isNotEmpty) filled++;

    total += 5;
    if (propertyDetails.value.isNotEmpty) filled++;
    if (propertyDetails.bathrooms.isNotEmpty) filled++;
    if (propertyDetails.bedrooms.isNotEmpty) filled++;
    if (propertyDetails.carSpaces.isNotEmpty) filled++;
    if (propertyDetails.landSize.isNotEmpty) filled++;

    return filled / total;
  }
}
