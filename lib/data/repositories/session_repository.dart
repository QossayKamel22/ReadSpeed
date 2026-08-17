import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/reading_session.dart';

class SessionRepository {
  final _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _sessions(String uid) =>
      _db.collection('users').doc(uid).collection('sessions');

  Future<void> addSession({
    required String uid,
    required String bookId,
    required int wpm,
    required int accuracy,
    required int durationSeconds,
    required int wordsRead,
  }) {
    final session = ReadingSession(
      id: '',
      bookId: bookId,
      wpm: wpm,
      accuracy: accuracy,
      durationSeconds: durationSeconds,
      wordsRead: wordsRead,
    );
    return _sessions(uid).add(session.toMap());
  }

  /// All sessions, most recent first. Statistics are aggregated client-side
  /// from this stream, which is fine at personal-app scale.
  Stream<List<ReadingSession>> watchSessions(String uid, {int limit = 500}) {
    return _sessions(uid)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snap) => snap.docs.map(ReadingSession.fromDoc).toList());
  }
}
