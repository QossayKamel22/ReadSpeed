import 'package:flutter/material.dart';
import '../models/book.dart';

class MockData {
  MockData._();

  static final List<Book> books = [
    const Book(
      id: 'b1',
      title: 'Atomic Habits',
      author: 'James Clear',
      progress: 0.68,
      type: BookType.book,
      coverColor: Color(0xFF1F3B2C),
      coverIcon: Icons.bolt_rounded,
      rating: 4.8,
      pages: 320,
      category: 'Productivity',
      description:
          'An easy and proven way to build good habits and break bad ones. Tiny changes, remarkable results.',
    ),
    const Book(
      id: 'b2',
      title: 'Deep Work',
      author: 'Cal Newport',
      progress: 0.42,
      type: BookType.book,
      coverColor: Color(0xFF102A2A),
      coverIcon: Icons.center_focus_strong_rounded,
      rating: 4.6,
      pages: 296,
      category: 'Focus',
      description:
          'Rules for focused success in a distracted world. Learn to master the skill of deep, undistracted work.',
    ),
    const Book(
      id: 'b3',
      title: 'The 5 AM Club',
      author: 'Robin Sharma',
      progress: 0.15,
      type: BookType.book,
      coverColor: Color(0xFF2A1F10),
      coverIcon: Icons.wb_twilight_rounded,
      rating: 4.3,
      pages: 336,
      category: 'Mindset',
      description:
          'Own your morning, elevate your life. A story-driven guide to early rising and personal mastery.',
    ),
    const Book(
      id: 'b4',
      title: 'Thinking, Fast and Slow',
      author: 'Daniel Kahneman',
      progress: 0.91,
      type: BookType.book,
      coverColor: Color(0xFF1A1A2E),
      coverIcon: Icons.psychology_alt_rounded,
      rating: 4.7,
      pages: 512,
      category: 'Psychology',
      description:
          'A groundbreaking exploration of the two systems that drive the way we think and make decisions.',
    ),
    const Book(
      id: 'b5',
      title: 'The Power of Habit',
      author: 'Charles Duhigg',
      progress: 0.0,
      type: BookType.pdf,
      coverColor: Color(0xFF2A1010),
      coverIcon: Icons.autorenew_rounded,
      rating: 4.5,
      pages: 371,
      category: 'Psychology',
      description:
          'Why we do what we do in life and business, and how understanding habits can transform everything.',
    ),
    const Book(
      id: 'b6',
      title: 'Make Your Bed',
      author: 'William H. McRaven',
      progress: 1.0,
      type: BookType.book,
      coverColor: Color(0xFF0F2A1F),
      coverIcon: Icons.military_tech_rounded,
      rating: 4.4,
      pages: 144,
      category: 'Discipline',
      description:
          'Small things that can change your life... and maybe the world. Lessons from a Navy SEAL.',
    ),
    const Book(
      id: 'b7',
      title: 'Rich Dad Poor Dad',
      author: 'Robert Kiyosaki',
      progress: 0.33,
      type: BookType.article,
      coverColor: Color(0xFF2A2410),
      coverIcon: Icons.account_balance_wallet_rounded,
      rating: 4.2,
      pages: 195,
      category: 'Finance',
      description:
          'What the rich teach their kids about money that the poor and middle class do not.',
    ),
    const Book(
      id: 'b8',
      title: 'Sapiens',
      author: 'Yuval Noah Harari',
      progress: 0.55,
      type: BookType.book,
      coverColor: Color(0xFF241A2A),
      coverIcon: Icons.public_rounded,
      rating: 4.9,
      pages: 443,
      category: 'History',
      description:
          'A brief history of humankind — how Homo sapiens came to dominate the world.',
    ),
  ];

  static Book get continueReading => books.firstWhere((b) => b.id == 'b1');

  static const sampleParagraph =
      'Every action you take is a vote for the person you wish to become. '
      'Success is the product of daily habits, not once-in-a-lifetime transformations. '
      'You do not rise to the level of your goals, you fall to the level of your systems. '
      'The most practical way to change who you are is to change what you do. '
      'Small habits do not add up, they compound. '
      'Time magnifies the margin between success and failure. '
      'It will multiply whatever you feed it. '
      'Good habits make time your ally, bad habits make time your enemy.';

  // WPM progress over the last 7 points
  static const List<double> wpmTrend = [220, 245, 260, 250, 280, 305, 320];
  static const List<double> readingTimeTrend = [20, 35, 25, 45, 30, 55, 40];

  static const Map<String, double> categoryBreakdown = {
    'Productivity': 32,
    'Psychology': 24,
    'Mindset': 18,
    'Finance': 14,
    'History': 12,
  };
}
