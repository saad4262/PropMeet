import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:propmeet/model/agent_model/agent_model.dart';

class AgentProfileRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Fetch agent profile
  Future<AgentFieldData?> fetchAgentProfile() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;

    // Root user doc
    final userDoc = await _db.collection('users').doc(uid).get();

    // Agent profile subdoc
    final setupDoc = await _db
        .collection('users')
        .doc(uid)
        .collection('agentProfile')
        .doc('profile')
        .get();

    if (userDoc.exists && setupDoc.exists) {
      return AgentFieldData.fromFirestore(
        userDoc.data() ?? {},
        setupDoc.data() ?? {},
      );
    }
    return null;
  }
  //
  // /// Update (or create) agent profile
  // Future<void> updateAgentProfile(AgentFieldData agent) async {
  //   final uid = _auth.currentUser?.uid;
  //   if (uid == null) return;
  //
  //   final firestoreData = agent.toFirestore();
  //
  //   final userRef = _db.collection("users").doc(uid);
  //
  //   // Ensure root document exists with createdAt if missing
  //   final userDoc = await userRef.get();
  //   if (!userDoc.exists || !(userDoc.data()?.containsKey("createdAt") ?? false)) {
  //     await userRef.set({
  //       "createdAt": FieldValue.serverTimestamp(),
  //     }, SetOptions(merge: true));
  //   }
  //
  //   // Save fieldData + toggles at root
  //   await userRef.set(
  //     {
  //       "fieldData": firestoreData["fieldData"],
  //       "toggleLeaseRenewal": firestoreData["toggleLeaseRenewal"],
  //       "toggleNegotiable": firestoreData["toggleNegotiable"],
  //     },
  //     SetOptions(merge: true),
  //   );
  //
  //   // Save profile subdocument
  //   await userRef.collection("agentProfile").doc("profile").set(
  //     {
  //       "selectionsOption1": firestoreData["selectionsOption1"],
  //       "selectionsOption2": firestoreData["selectionsOption2"],
  //       "setSelection": firestoreData["setSelection"],
  //     },
  //     SetOptions(merge: true),
  //   );
  // }
  /// Update (or create) agent profile
  Future<void> updateAgentProfile(AgentFieldData agent) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final firestoreData = agent.toFirestore();
    final userRef = _db.collection("users").doc(uid);

    // Ensure root document exists with createdAt if missing
    final userDoc = await userRef.get();
    if (!userDoc.exists || !(userDoc.data()?.containsKey("createdAt") ?? false)) {
      await userRef.set({
        "createdAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    // Save toggles & fieldData at root
    await userRef.set(
      {
        "fieldData": firestoreData["fieldData"],
        "toggleLeaseRenewal": firestoreData["toggleLeaseRenewal"],
        "toggleNegotiable": firestoreData["toggleNegotiable"],
      },
      SetOptions(merge: true),
    );

    // Save nested selections (profile subdocument)
    await userRef.collection("agentProfile").doc("profile").set(
      {
        "selectionsOption1": firestoreData["selectionsOption1"],
        "selectionsOption2": firestoreData["selectionsOption2"],
        "setSelection": firestoreData["setSelection"],
      },
      SetOptions(merge: true),
    );
  }

  Future<List<AgentFieldData>> fetchAllAgents() async {
    final snapshot = await _db
        .collection("users")
        .where("tag", isEqualTo: "agent")
        .get();

    print("Found ${snapshot.docs.length} agent docs");

    List<AgentFieldData> agents = [];
    for (var doc in snapshot.docs) {
      try {
        final setupDoc = await _db
            .collection("users")
            .doc(doc.id)
            .collection("agentProfile")
            .doc("profile")
            .get();

        print("User ${doc.id} root: ${doc.data()}");
        print("User ${doc.id} setup: ${setupDoc.data()}");

        agents.add(AgentFieldData.fromFirestore(
          doc.data(),
          setupDoc.data() ?? {},
        ));
      } catch (e) {
        print("Error parsing agent ${doc.id}: $e");
      }
    }
    return agents;
  }

  Future<void> recordSwipe({
    required String agentUserId,
    required String currentUserId,
    required bool liked,
  }) async {
    final docRef = _db.collection('users').doc(agentUserId);
    final field = 'swipes';
    await _db.runTransaction((txn) async {
      final snapshot = await txn.get(docRef);
      final data = snapshot.data() ?? {};
      final Map swipes = Map.from(data[field] ?? {});
      int count = (swipes['count'] ?? 0) as int;
      List likedList = List.from(swipes['liked'] ?? []);
      List dislikedList = List.from(swipes['disliked'] ?? []);
      count += 1;
      if (liked) {
        if (!likedList.contains(currentUserId)) likedList.add(currentUserId);
        dislikedList.remove(currentUserId);
      } else {
        if (!dislikedList.contains(currentUserId)) dislikedList.add(currentUserId);
        likedList.remove(currentUserId);
      }
      txn.set(docRef, {
        field: {
          'count': count,
          'liked': likedList,
          'disliked': dislikedList,
        }
      }, SetOptions(merge: true));
    });
  }

  String _fixFirebaseImageUrl(String url) {
    if (url.isEmpty) return url;

    // Fix common mistake: replace `.firebasestorage.app` with `.appspot.com`
    if (url.contains('.firebasestorage.app')) {
      return url.replaceAll('.firebasestorage.app', '.appspot.com');
    }

    return url;
  }





}
