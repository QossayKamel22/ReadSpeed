import 'package:cloud_firestore/cloud_firestore.dart';

class ReadingSession {
  final String id;
  final String bookId;
  final int wpm;
  final int accuracy;
  final int durationSeconds;
  final int wordsRead;
  final DateTime? createdAt;

  const ReadingSession({
    required this.id,
    required this.bookId,
    required this.wpm,
    required this.accuracy,
    required this.durationSeconds,
    required this.wordsRead,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'bookId': bookId,
      'wpm': wpm,
      'accuracy': accuracy,
      'durationSeconds': durationSeconds,
      'wordsRead': wordsRead,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  factory ReadingSession.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return ReadingSession(
      id: doc.id,
      bookId: (data['bookId'] as String?) ?? '',
      wpm: (data['wpm'] as num?)?.toInt() ?? 0,
      accuracy: (data['accuracy'] as num?)?.toInt() ?? 0,
      durationSeconds: (data['durationSeconds'] as num?)?.toInt() ?? 0,
      wordsRead: (data['wordsRead'] as num?)?.toInt() ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
