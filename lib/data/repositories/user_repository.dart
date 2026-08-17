import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_profile.dart';

class UserRepository {
  final _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _users =>
      _db.collection('users');

  /// Creates the users/{uid} document if it doesn't already exist.
  /// Safe to call on every sign-in.
  Future<UserProfile> ensureProfile(User user, {String? displayName}) async {
    final ref = _users.doc(user.uid);
    final snap = await ref.get();
    if (snap.exists) {
      return UserProfile.fromDoc(snap);
    }
    final profile = UserProfile(
      uid: user.uid,
      displayName: displayName ?? user.displayName ?? (user.email?.split('@').first ?? 'Reader'),
      email: user.email ?? '',
    );
    await ref.set(profile.toMap());
    final created = await ref.get();
    return UserProfile.fromDoc(created);
  }

  Stream<UserProfile?> watch(String uid) {
    return _users.doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserProfile.fromDoc(doc);
    });
  }

  Future<void> updateFields(String uid, Map<String, dynamic> fields) {
    return _users.doc(uid).set(
      {...fields, 'updatedAt': FieldValue.serverTimestamp()},
      SetOptions(merge: true),
    );
  }
}
