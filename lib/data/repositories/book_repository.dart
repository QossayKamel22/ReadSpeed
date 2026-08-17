import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/book.dart';

class BookRepository {
  final _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _books(String uid) =>
      _db.collection('users').doc(uid).collection('books');

  Stream<List<Book>> watchBooks(String uid) {
    return _books(uid).orderBy('updatedAt', descending: true).snapshots().map(
          (snap) => snap.docs.map(Book.fromDoc).toList(),
        );
  }

  Future<String> addBook({
    required String uid,
    required String title,
    required String author,
    required BookType type,
    int coverIndex = 0,
  }) async {
    final book = Book(
      id: '',
      title: title,
      author: author,
      progress: 0,
      type: type,
      coverStyleKey: BookCoverStyle.forIndex(coverIndex).key,
      createdAt: DateTime.now(),
    );
    final ref = await _books(uid).add(book.toMap());
    return ref.id;
  }

  Future<void> updateBook(String uid, String bookId, Map<String, dynamic> fields) {
    return _books(uid).doc(bookId).set(
      {...fields, 'updatedAt': FieldValue.serverTimestamp()},
      SetOptions(merge: true),
    );
  }

  Future<void> deleteBook(String uid, String bookId) {
    return _books(uid).doc(bookId).delete();
  }

  Future<void> updateProgress({
    required String uid,
    required String bookId,
    required double progress,
    required int lastPositionIndex,
  }) {
    return updateBook(uid, bookId, {
      'progress': progress,
      'lastPositionIndex': lastPositionIndex,
    });
  }
}
