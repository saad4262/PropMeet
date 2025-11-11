import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AgentFieldData {
  final String apartmentAndUnit;
  final String? createdAt;
  final String averageRating;
  final String bio;
  final String clientReviews;
  final Map<String, dynamic>? location;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String professionalTitle;
  final String yearsOfExperience;
  final String medianDaysOnMarket;
  final String ruralAcreage;
  final String townhouse;
  final String house;
  final String land;
  final String luxuryHomes;
  final String offThePlan;
  final String managedProperties;
  final String soldProperties;
  final String profileImage;
  final String feeStructure;
  final String feesNegotiable;
  final String serviceProvided;
  final bool toggleLeaseRenewal;
  final bool toggleNegotiable;

  //  Swipe-related fields (NEW)
  final int swipeCount;
  final List<String> liked;
  final List<String> disliked;

  AgentFieldData({
    this.location,
    required this.apartmentAndUnit,
    this.createdAt,
    required this.averageRating,
    required this.bio,
    required this.clientReviews,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.professionalTitle,
    required this.yearsOfExperience,
    required this.medianDaysOnMarket,
    required this.ruralAcreage,
    required this.townhouse,
    required this.house,
    required this.land,
    required this.luxuryHomes,
    required this.offThePlan,
    required this.managedProperties,
    required this.soldProperties,
    required this.profileImage,
    required this.feeStructure,
    required this.feesNegotiable,
    required this.serviceProvided,
    required this.toggleLeaseRenewal,
    required this.toggleNegotiable,
    this.swipeCount = 0,
    this.liked = const [],
    this.disliked = const [],
  });

  factory AgentFieldData.fromFirestore(
      Map<String, dynamic> rootData,
      Map<String, dynamic> map,
      ) {
    final setupData = map['fieldData'] ?? {};
    final selections1 = map['selectionsOption1'] ?? {};
    final selections2 = map['selectionsOption2'] ?? {};
    final setSelection = map['setSelection'] ?? {};

    String? formattedDate;
    if (rootData['createdAt'] != null && rootData['createdAt'] is Timestamp) {
      DateTime dateTime = (rootData['createdAt'] as Timestamp).toDate();
      formattedDate = DateFormat('MM/dd/yyyy').format(dateTime);
    }

    // ✅ Fix Firebase image URLs
    String _fixFirebaseImageUrl(String? url) {
      if (url == null || url.isEmpty) return '';
      if (url.contains('.firebasestorage.app')) {
        return url.replaceAll('.firebasestorage.app', '.appspot.com');
      }
      return url;
    }

    // ✅ Handle location properly BEFORE constructor
    dynamic loc = setupData['Location'] ?? map['location'] ?? rootData['location'];

    Map<String, dynamic>? locationMap;
    if (loc is String) {
      locationMap = {"address": loc};
    } else if (loc is Map) {
      locationMap = Map<String, dynamic>.from(loc);
    }

    return AgentFieldData(
      createdAt: formattedDate,
      apartmentAndUnit: setupData['Apartment & Unit']?.toString() ?? '',
      averageRating: setupData['Average Rating']?.toString() ?? '',
      bio: setupData['Bio']?.toString() ?? '',
      clientReviews: setupData['Client Reviews']?.toString() ?? '',
      firstName: setupData['First Name']?.toString() ?? '',
      lastName: setupData['Last Name']?.toString() ?? '',
      phoneNumber: setupData['Phone Number']?.toString() ?? '',
      professionalTitle: setupData['Professional Title']?.toString() ?? '',
      yearsOfExperience: setupData['Years of Experience']?.toString() ?? '',
      medianDaysOnMarket:
      setupData['What was your median days on market (time advertised before sale)?']
          ?.toString() ??
          '',
      ruralAcreage: setupData['Rural / Acreage']?.toString() ?? '',
      townhouse: setupData['Townhouse']?.toString() ?? '',
      house: setupData['House']?.toString() ?? '',
      land: setupData['Land']?.toString() ?? '',
      luxuryHomes: setupData['Luxury Homes']?.toString() ?? '',
      offThePlan: setupData['Off-the-Plan']?.toString() ?? '',
      managedProperties:
      setupData['How many properties do you currently manage under rental agreements?']
          ?.toString() ??
          '',
      soldProperties:
      setupData['How many properties have you sold in the last 12 months?']
          ?.toString() ??
          '',
      profileImage: _fixFirebaseImageUrl(map['profile']?['profileImage'] ?? ''),
      location: locationMap, // ✅ use parsed map here
      feeStructure: selections1['Fee Structure']?.toString() ?? '',
      feesNegotiable: selections2['Are your fees negotiable?']?.toString() ?? '',
      serviceProvided:
      setSelection['What service do you provide to property owners?']
          ?.toString() ??
          '',
      toggleLeaseRenewal: map['toggleLeaseRenewal'] ?? false,
      toggleNegotiable: map['toggleNegotiable'] ?? false,
      swipeCount: map['swipes']?['count'] ?? 0,
      liked: map['swipes']?['liked'] != null
          ? List<String>.from(map['swipes']['liked'])
          : [],
      disliked: map['swipes']?['disliked'] != null
          ? List<String>.from(map['swipes']['disliked'])
          : [],
    );
  }


  Map<String, dynamic> toFirestore() {
    return {
      "fieldData": {
        "Apartment & Unit": apartmentAndUnit,
        "Average Rating": averageRating,
        "Bio": bio,
        "Client Reviews": clientReviews,
        "First Name": firstName,
        "Last Name": lastName,
        "Phone Number": phoneNumber,
        "Professional Title": professionalTitle,
        "Years of Experience": yearsOfExperience,
        "What was your median days on market (time advertised before sale)?":
        medianDaysOnMarket,
        "Rural / Acreage": ruralAcreage,
        "Townhouse": townhouse,
        "House": house,
        "Land": land,
        "Luxury Homes": luxuryHomes,
        "Off-the-Plan": offThePlan,
        "How many properties do you currently manage under rental agreements?":
        managedProperties,
        "How many properties have you sold in the last 12 months?":
        soldProperties,
        "profileImage": profileImage,
        "Location": location ?? {}, // ✅ store map now
      },
      "selectionsOption1": {"Fee Structure": feeStructure},
      "selectionsOption2": {"Are your fees negotiable?": feesNegotiable},
      "setSelection": {
        "What service do you provide to property owners?": serviceProvided,
      },
      "toggleLeaseRenewal": toggleLeaseRenewal,
      "toggleNegotiable": toggleNegotiable,
      "swipes": {
        "count": swipeCount,
        "liked": liked,
        "disliked": disliked,
      },
    };
  }

  AgentFieldData copyWith({
    String? firstName,
    String? lastName,
    String? title,
    String? bio,
    String? experience,
    String? rating,
    String? reviewCount,
    String? medianDays,
    String? managing,
    String? serviceProvided,
    String? feeStructure,
    Map<String, dynamic>? location,
  }) {
    return AgentFieldData(
      apartmentAndUnit: apartmentAndUnit,
      createdAt: createdAt,
      averageRating: rating ?? averageRating,
      bio: bio ?? this.bio,
      clientReviews: reviewCount ?? clientReviews,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber,
      professionalTitle: title ?? professionalTitle,
      yearsOfExperience: experience ?? yearsOfExperience,
      medianDaysOnMarket: medianDays ?? medianDaysOnMarket,
      ruralAcreage: ruralAcreage,
      townhouse: townhouse,
      house: house,
      land: land,
      luxuryHomes: luxuryHomes,
      offThePlan: offThePlan,
      managedProperties: managing ?? managedProperties,
      soldProperties: soldProperties,
      profileImage: profileImage,
      feeStructure: feeStructure ?? this.feeStructure,
      feesNegotiable: feesNegotiable,
      serviceProvided: serviceProvided ?? this.serviceProvided,
      toggleLeaseRenewal: toggleLeaseRenewal,
      toggleNegotiable: toggleNegotiable,
      swipeCount: swipeCount,
      liked: liked,
      disliked: disliked,
      location: location ?? this.location, // ✅ handled in copy
    );
  }
}
