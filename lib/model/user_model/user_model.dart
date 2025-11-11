// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
// import 'package:propmeet/model/user_model/property_detail_model.dart';
//
// class UserModel {
//   final String? userId;
//   final String? createdAt;
//   final String? avatarUrl;
//   final String? displayName;
//   final String email;
//   final Map<String, dynamic>? location;
//   // final String location;
//   final int progress;
//   final PropertyDetails propertyDetails;
//   final List<String> selections;
//
//   // New swipe-related fields
//   final int swipeCount;
//   final List<String> liked;
//   final List<String> disliked;
//
//   UserModel( {
//     this.userId,
//     this.createdAt,
//     this.avatarUrl, this.displayName,
//     required this.email,
//     required this.location,
//     required this.progress,
//     required this.propertyDetails,
//     required this.selections,
//     this.swipeCount = 0,
//     this.liked = const [],
//     this.disliked = const [],
//   });
//
//   //Use this when fetching from Firestore
//   // factory UserModel.fromFirestore(DocumentSnapshot doc, Map<String, dynamic> setupData) {
//   //   final data = doc.data() as Map<String, dynamic>;
//   //   return UserModel.fromMap(data, setupData, userId: doc.id);
//   // }
//
//   // ✅ Fixed Firestore factory
//   factory UserModel.fromFirestore(DocumentSnapshot doc, Map<String, dynamic> setupData) {
//     final data = doc.data() as Map<String, dynamic>;
//     print("📄 Root data for ${doc.id}: $data");
//     print("⚙️ Setup data for ${doc.id}: $setupData");
//     return UserModel.fromMap(data, setupData, userId: doc.id);
//   }
//
//   factory UserModel.fromMap(
//       Map<String, dynamic> rootData,
//       Map<String, dynamic> setupData, {
//         String? userId,
//       }) {
//
//     print("⚠️ Problem user rootData for $userId: $rootData");
//     String? formattedDate;
//     if (rootData['createdAt'] != null && rootData['createdAt'] is Timestamp) {
//       DateTime dateTime = (rootData['createdAt'] as Timestamp).toDate();
//       formattedDate = DateFormat('MM/dd/yyyy').format(dateTime);
//     }
//
//     // Safely handle nested maps
//     dynamic nameData = rootData['name'];
//     dynamic emailData = rootData['email'];
//     dynamic swipesData = rootData['swipes'];
//
//     // Convert name
//     String safeName = '';
//     if (nameData is String) {
//       safeName = nameData;
//     } else if (nameData is Map) {
//       safeName = [
//         nameData['first'],
//         nameData['last'],
//         nameData['fullName'],
//         nameData['displayName']
//       ].whereType<String>().join(' ').trim();
//     }
//
//     // Convert email
//     String safeEmail = '';
//     if (emailData is String) {
//       safeEmail = emailData;
//     } else if (emailData is Map) {
//       safeEmail = emailData['address'] ??
//           emailData['email'] ??
//           emailData['info']?['address'] ??
//           '';
//     }
//
//     // Handle swipes
//     int safeSwipeCount = (swipesData is Map && swipesData['count'] != null)
//         ? (swipesData['count'] as num).toInt()
//         : 0;
//
//     List<String> safeLiked = (swipesData is Map && swipesData['liked'] is List)
//         ? List<String>.from(swipesData['liked'])
//         : [];
//
//     List<String> safeDisliked =
//     (swipesData is Map && swipesData['disliked'] is List)
//         ? List<String>.from(swipesData['disliked'])
//         : [];
//
//     return UserModel(
//       userId: userId ?? '',
//       createdAt: formattedDate,
//       displayName: safeName,
//       avatarUrl: '',
//       email: safeEmail,
//       location: setupData['location'] ?? '',
//       progress: (setupData['progress'] is int)
//           ? setupData['progress']
//           : (setupData['progress'] as num?)?.toInt() ?? 0,
//       propertyDetails: setupData['propertyDetails'] != null
//           ? PropertyDetails.fromMap(
//         Map<String, dynamic>.from(setupData['propertyDetails']),
//       )
//           : PropertyDetails(
//         value: '',
//         bathrooms: '',
//         bedrooms: '',
//         carSpaces: '',
//         landSize: '',
//       ),
//       selections: setupData['selections'] != null
//           ? List<String>.from(setupData['selections'])
//           : [],
//       swipeCount: safeSwipeCount,
//       liked: safeLiked,
//       disliked: safeDisliked,
//     );
//   }
//
//   // factory UserModel.fromMap(
//   //     Map<String, dynamic> rootData,
//   //     Map<String, dynamic> setupData, {
//   //       String? userId,
//   //     }) {
//   //   String? formattedDate;
//   //   if (rootData['createdAt'] != null && rootData['createdAt'] is Timestamp) {
//   //     DateTime dateTime = (rootData['createdAt'] as Timestamp).toDate();
//   //     formattedDate = DateFormat('MM/dd/yyyy').format(dateTime);
//   //   }
//   //
//   //   // 🔥 Safely extract potential nested maps
//   //   final nameData = rootData['name'];
//   //   final emailData = rootData['email'];
//   //   final swipesData = rootData['swipes'];
//   //
//   //   // ✅ Safe fallback parsing
//   //   final String safeName = nameData is Map
//   //       ? "${nameData['first'] ?? ''} ${nameData['last'] ?? ''}".trim()
//   //       : (nameData ?? '');
//   //
//   //   final String safeEmail = emailData is Map
//   //       ? (emailData['address'] ?? emailData['email'] ?? '')
//   //       : (emailData ?? '');
//   //
//   //   final int safeSwipeCount = (swipesData is Map && swipesData['count'] != null)
//   //       ? (swipesData['count'] as num).toInt()
//   //       : 0;
//   //
//   //   final List<String> safeLiked = (swipesData is Map &&
//   //       swipesData['liked'] is List)
//   //       ? List<String>.from(swipesData['liked'])
//   //       : [];
//   //
//   //   final List<String> safeDisliked = (swipesData is Map &&
//   //       swipesData['disliked'] is List)
//   //       ? List<String>.from(swipesData['disliked'])
//   //       : [];
//   //
//   //   return UserModel(
//   //     userId: userId ?? '',
//   //     createdAt: formattedDate,
//   //     displayName: safeName,
//   //     avatarUrl: '',
//   //     email: safeEmail,
//   //     location: setupData['location'] ?? '',
//   //     progress: (setupData['progress'] is int)
//   //         ? setupData['progress']
//   //         : (setupData['progress'] as num?)?.toInt() ?? 0,
//   //     propertyDetails: setupData['propertyDetails'] != null
//   //         ? PropertyDetails.fromMap(
//   //       Map<String, dynamic>.from(setupData['propertyDetails']),
//   //     )
//   //         : PropertyDetails(
//   //       value: '',
//   //       bathrooms: '',
//   //       bedrooms: '',
//   //       carSpaces: '',
//   //       landSize: '',
//   //     ),
//   //     selections: setupData['selections'] != null
//   //         ? List<String>.from(setupData['selections'])
//   //         : [],
//   //     swipeCount: safeSwipeCount,
//   //     liked: safeLiked,
//   //     disliked: safeDisliked,
//   //   );
//   // }
//
//
//
//   UserModel copyWith({
//     String? userId,
//     String? createdAt,
//     String? name,
//     String? email,
//     String? location,
//     int? progress,
//     PropertyDetails? propertyDetails,
//     List<String>? selections,
//     int? swipeCount,
//     List<String>? liked,
//     List<String>? disliked,
//   }) {
//     return UserModel(
//       userId: userId ?? this.userId,
//       createdAt: createdAt ?? this.createdAt,
//       displayName: displayName ?? this.displayName,
//       avatarUrl: avatarUrl ?? '',
//       email: email ?? this.email,
//       // location: location ?? this.location,
//       location: map['location'] is Map<String, dynamic> ? map['location'] : null,
//       progress: progress ?? this.progress,
//       propertyDetails: propertyDetails ?? this.propertyDetails,
//       selections: selections ?? this.selections,
//       swipeCount: swipeCount ?? this.swipeCount,
//       liked: liked ?? this.liked,
//       disliked: disliked ?? this.disliked,
//     );
//   }
// }
//
// extension UserModelCompletion on UserModel {
//   double get completionPercentage {
//     int filled = 0;
//     int total = 0;
//
//     total++;
//     if (displayName != null && displayName!.isNotEmpty) filled++;
//
//     total++;
//     if (email.isNotEmpty) filled++;
//
//     total++;
//     if (location.isNotEmpty) filled++;
//
//     total += 3;
//     if (selections.isNotEmpty && selections[0].isNotEmpty) filled++;
//     if (selections.length > 1 && selections[1].isNotEmpty) filled++;
//     if (selections.length > 4 && selections[4].isNotEmpty) filled++;
//
//     total += 5;
//     if (propertyDetails.value.isNotEmpty) filled++;
//     if (propertyDetails.bathrooms.isNotEmpty) filled++;
//     if (propertyDetails.bedrooms.isNotEmpty) filled++;
//     if (propertyDetails.carSpaces.isNotEmpty) filled++;
//     if (propertyDetails.landSize.isNotEmpty) filled++;
//
//     return filled / total;
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:propmeet/model/user_model/property_detail_model.dart';

class UserModel {
  final String? userId;
  final String? createdAt;
  final String? avatarUrl;
  final String? displayName;
  final String email;
  // ✅ Keep location as String
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
    this.avatarUrl,
    this.displayName,
    required this.email,
    required this.location,
    required this.progress,
    required this.propertyDetails,
    required this.selections,
    this.swipeCount = 0,
    this.liked = const [],
    this.disliked = const [],
  });

  // ✅ Firestore factory
  factory UserModel.fromFirestore(DocumentSnapshot doc, Map<String, dynamic> setupData) {
    final data = doc.data() as Map<String, dynamic>;
    print("📄 Root data for ${doc.id}: $data");
    print("⚙️ Setup data for ${doc.id}: $setupData");
    return UserModel.fromMap(data, setupData, userId: doc.id);
  }

  factory UserModel.fromMap(
      Map<String, dynamic> rootData,
      Map<String, dynamic> setupData, {
        String? userId,
      }) {
    print("⚠️ Problem user rootData for $userId: $rootData");

    String? formattedDate;
    if (rootData['createdAt'] != null && rootData['createdAt'] is Timestamp) {
      DateTime dateTime = (rootData['createdAt'] as Timestamp).toDate();
      formattedDate = DateFormat('MM/dd/yyyy').format(dateTime);
    }

    // Safely handle nested maps
    dynamic nameData = rootData['name'];
    dynamic emailData = rootData['email'];
    dynamic swipesData = rootData['swipes'];

    // Convert name
    String safeName = '';
    if (nameData is String) {
      safeName = nameData;
    } else if (nameData is Map) {
      safeName = [
        nameData['first'],
        nameData['last'],
        nameData['fullName'],
        nameData['displayName']
      ].whereType<String>().join(' ').trim();
    }

    // Convert email
    String safeEmail = '';
    if (emailData is String) {
      safeEmail = emailData;
    } else if (emailData is Map) {
      safeEmail = emailData['address'] ??
          emailData['email'] ??
          emailData['info']?['address'] ??
          '';
    }

    // Handle swipes
    int safeSwipeCount = (swipesData is Map && swipesData['count'] != null)
        ? (swipesData['count'] as num).toInt()
        : 0;

    List<String> safeLiked = (swipesData is Map && swipesData['liked'] is List)
        ? List<String>.from(swipesData['liked'])
        : [];

    List<String> safeDisliked =
    (swipesData is Map && swipesData['disliked'] is List)
        ? List<String>.from(swipesData['disliked'])
        : [];

    // ✅ Location fix (Option 2)
    String safeLocation = '';
    final locData = setupData['location'];
    if (locData is String) {
      safeLocation = locData;
    } else if (locData is Map) {
      safeLocation = locData['address'] ??
          locData['locationName'] ??
          locData['city'] ??
          locData['country'] ??
          '';
    }

    return UserModel(
      userId: userId ?? '',
      createdAt: formattedDate,
      displayName: safeName,
      avatarUrl: '',
      email: safeEmail,
      location: safeLocation,
      progress: (setupData['progress'] is int)
          ? setupData['progress']
          : (setupData['progress'] as num?)?.toInt() ?? 0,
      propertyDetails: setupData['propertyDetails'] != null
          ? PropertyDetails.fromMap(
        Map<String, dynamic>.from(setupData['propertyDetails']),
      )
          : PropertyDetails(
        value: '',
        bathrooms: '',
        bedrooms: '',
        carSpaces: '',
        landSize: '',
      ),
      selections: setupData['selections'] != null
          ? List<String>.from(setupData['selections'])
          : [],
      swipeCount: safeSwipeCount,
      liked: safeLiked,
      disliked: safeDisliked,
    );
  }

  UserModel copyWith({
    String? userId,
    String? createdAt,
    String? displayName,
    String? avatarUrl,
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
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
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
    if (displayName != null && displayName!.isNotEmpty) filled++;

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
