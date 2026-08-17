import 'package:flutter/material.dart';

enum BookType { book, pdf, article }

class Book {
  final String id;
  final String title;
  final String author;
  final double progress; // 0..1
  final BookType type;
  final Color coverColor;
  final IconData coverIcon;
  final double rating;
  final int pages;
  final String category;
  final String description;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.progress,
    required this.type,
    required this.coverColor,
    required this.coverIcon,
    this.rating = 4.5,
    this.pages = 240,
    this.category = 'Self Development',
    this.description =
        'A compelling read that will change the way you think about your habits, focus, and productivity.',
  });

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
}
