import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum BookType { book, pdf, article }

/// Fixed palette of cover colors/icons assigned round-robin to new books.
/// Kept as a lookup (not free-form) so Firestore only stores a small key
/// and Flutter's icon tree-shaking still works.
class BookCoverStyle {
  final Color color;
  final IconData icon;
  final String key;
  const BookCoverStyle(this.key, this.color, this.icon);

  static const List<BookCoverStyle> palette = [
    BookCoverStyle('bolt', Color(0xFF1F3B2C), Icons.bolt_rounded),
    BookCoverStyle('focus', Color(0xFF102A2A), Icons.center_focus_strong_rounded),
    BookCoverStyle('dawn', Color(0xFF2A1F10), Icons.wb_twilight_rounded),
    BookCoverStyle('mind', Color(0xFF1A1A2E), Icons.psychology_alt_rounded),
    BookCoverStyle('renew', Color(0xFF2A1010), Icons.autorenew_rounded),
    BookCoverStyle('badge', Color(0xFF0F2A1F), Icons.military_tech_rounded),
    BookCoverStyle('wallet', Color(0xFF2A2410), Icons.account_balance_wallet_rounded),
    BookCoverStyle('globe', Color(0xFF241A2A), Icons.public_rounded),
  ];

  static BookCoverStyle forKey(String key) =>
      palette.firstWhere((s) => s.key == key, orElse: () => palette.first);

  static BookCoverStyle forIndex(int i) => palette[i % palette.length];
}

class Book {
  final String id;
  final String title;
  final String author;
  final double progress; // 0..1
  final BookType type;
  final String coverStyleKey;
  final double rating;
  final int pages;
  final String category;
  final String description;
  final int lastPositionIndex; // last word index reached in the reader
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.progress,
    required this.type,
    required this.coverStyleKey,
    this.rating = 4.5,
    this.pages = 240,
    this.category = 'Self Development',
    this.description =
        'A compelling read that will change the way you think about your habits, focus, and productivity.',
    this.lastPositionIndex = 0,
    this.createdAt,
    this.updatedAt,
  });

  Color get coverColor => BookCoverStyle.forKey(coverStyleKey).color;
  IconData get coverIcon => BookCoverStyle.forKey(coverStyleKey).icon;

  String get typeLabel {
    switch (type) {
      case BookType.book:
        return 'Book';
      case BookType.pdf:
        return 'PDF';
      case BookType.article:
        return 'Article';
    }
  }

  String get statusLabel {
    if (progress <= 0) return 'Not started';
    if (progress >= 1) return 'Completed';
    return 'In progress';
  }

  Book copyWith({
    String? id,
    String? title,
    String? author,
    double? progress,
    BookType? type,
    String? coverStyleKey,
    double? rating,
    int? pages,
    String? category,
    String? description,
    int? lastPositionIndex,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      progress: progress ?? this.progress,
      type: type ?? this.type,
      coverStyleKey: coverStyleKey ?? this.coverStyleKey,
      rating: rating ?? this.rating,
      pages: pages ?? this.pages,
      category: category ?? this.category,
      description: description ?? this.description,
      lastPositionIndex: lastPositionIndex ?? this.lastPositionIndex,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'progress': progress,
      'type': type.name,
      'coverStyleKey': coverStyleKey,
      'rating': rating,
      'pages': pages,
      'category': category,
      'description': description,
      'lastPositionIndex': lastPositionIndex,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  factory Book.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return Book(
      id: doc.id,
      title: (data['title'] as String?) ?? 'Untitled',
      author: (data['author'] as String?) ?? 'Unknown author',
      progress: ((data['progress'] as num?) ?? 0).toDouble(),
      type: BookType.values.firstWhere(
        (t) => t.name == data['type'],
        orElse: () => BookType.book,
      ),
      coverStyleKey: (data['coverStyleKey'] as String?) ?? 'bolt',
      rating: ((data['rating'] as num?) ?? 4.5).toDouble(),
      pages: (data['pages'] as num?)?.toInt() ?? 240,
      category: (data['category'] as String?) ?? 'Self Development',
      description: (data['description'] as String?) ?? '',
      lastPositionIndex: (data['lastPositionIndex'] as num?)?.toInt() ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }
}
