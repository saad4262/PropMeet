import 'package:cloud_firestore/cloud_firestore.dart';

class MatchModel {
  final String matchId;     // unique ID for this match doc
  final String userId;      // the user who liked/swiped right
  final String agentId;     // the agent who liked/swiped right
  final Timestamp createdAt; // when the match happened
  final bool isActive;      // to track if chat is active / deleted later

  MatchModel({
    required this.matchId,
    required this.userId,
    required this.agentId,
    required this.createdAt,
    this.isActive = true,
  });

  // From Firestore
  factory MatchModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MatchModel(
      matchId: doc.id,
      userId: data['userId'] ?? '',
      agentId: data['agentId'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      isActive: data['isActive'] ?? true,
    );
  }

  // To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      "userId": userId,
      "agentId": agentId,
      "createdAt": createdAt,
      "isActive": isActive,
    };
  }

  // CopyWith helper
  MatchModel copyWith({
    String? matchId,
    String? userId,
    String? agentId,
    Timestamp? createdAt,
    bool? isActive,
  }) {
    return MatchModel(
      matchId: matchId ?? this.matchId,
      userId: userId ?? this.userId,
      agentId: agentId ?? this.agentId,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
