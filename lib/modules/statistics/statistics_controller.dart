import 'dart:async';

import 'package:get/get.dart';

import '../../data/models/book.dart';
import '../../data/models/reading_session.dart';
import '../../data/repositories/book_repository.dart';
import '../../data/repositories/session_repository.dart';
import '../../data/services/auth_service.dart';

class StatisticsController extends GetxController {
  final _auth = Get.find<AuthService>();
  final _sessionRepo = SessionRepository();
  final _bookRepo = BookRepository();

  final period = '7 Days'.obs;
  static const periods = ['7 Days', '30 Days', '90 Days', 'All Time'];

  final isLoading = true.obs;
  final sessions = <ReadingSession>[].obs;
  final books = <Book>[].obs;

  StreamSubscription? _sessionsSub;
  StreamSubscription? _booksSub;

  @override
  void onInit() {
    super.onInit();
    final uid = _auth.uid;
    if (uid == null) {
      isLoading.value = false;
      return;
    }
    _sessionsSub = _sessionRepo.watchSessions(uid).listen((list) {
      sessions.assignAll(list);
      isLoading.value = false;
    });
    _booksSub = _bookRepo.watchBooks(uid).listen((list) => books.assignAll(list));
  }

  List<ReadingSession> get _inRange {
    final now = DateTime.now();
    final cutoff = switch (period.value) {
      '7 Days' => now.subtract(const Duration(days: 7)),
      '30 Days' => now.subtract(const Duration(days: 30)),
      '90 Days' => now.subtract(const Duration(days: 90)),
      _ => DateTime(2000),
    };
    return sessions.where((s) => s.createdAt != null && s.createdAt!.isAfter(cutoff)).toList();
  }

  int get avgWpm {
    final list = _inRange;
    if (list.isEmpty) return 0;
    return (list.fold<int>(0, (sum, s) => sum + s.wpm) / list.length).round();
  }

  int get totalMinutes {
    final list = _inRange;
    return list.fold<int>(0, (sum, s) => sum + s.durationSeconds) ~/ 60;
  }

  int get totalWordsRead => _inRange.fold<int>(0, (sum, s) => sum + s.wordsRead);

  int get sessionCount => _inRange.length;

  /// Up to the last 7 sessions' WPM, oldest first — drives the WPM trend line.
  List<double> get wpmTrend {
    final list = _inRange.reversed.toList();
    final tail = list.length > 7 ? list.sublist(list.length - 7) : list;
    if (tail.isEmpty) return const [0, 0];
    return tail.map((s) => s.wpm.toDouble()).toList();
  }

  /// Reading minutes per day for the last 7 days in range, oldest first.
  List<double> get readingTimeTrend {
    final now = DateTime.now();
    final days = List.generate(7, (i) => DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: 6 - i)));
    return days.map((day) {
      final seconds = sessions
          .where((s) =>
              s.createdAt != null &&
              s.createdAt!.year == day.year &&
              s.createdAt!.month == day.month &&
              s.createdAt!.day == day.day)
          .fold<int>(0, (sum, s) => sum + s.durationSeconds);
      return seconds / 60.0;
    }).toList();
  }

  Map<String, double> get categoryBreakdown {
    final byBook = {for (final b in books) b.id: b.category};
    final counts = <String, double>{};
    for (final s in _inRange) {
      final category = byBook[s.bookId] ?? 'Other';
      counts[category] = (counts[category] ?? 0) + 1;
    }
    return counts;
  }

  int get currentStreakDays {
    if (sessions.isEmpty) return 0;
    final days = sessions
        .where((s) => s.createdAt != null)
        .map((s) => DateTime(s.createdAt!.year, s.createdAt!.month, s.createdAt!.day))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));
    var streak = 0;
    var cursor = DateTime.now();
    cursor = DateTime(cursor.year, cursor.month, cursor.day);
    for (final day in days) {
      if (day == cursor || day == cursor.subtract(const Duration(days: 1))) {
        streak++;
        cursor = day;
      } else {
        break;
      }
    }
    return streak;
  }

  int get bestStreakDays {
    if (sessions.isEmpty) return 0;
    final days = sessions
        .where((s) => s.createdAt != null)
        .map((s) => DateTime(s.createdAt!.year, s.createdAt!.month, s.createdAt!.day))
        .toSet()
        .toList()
      ..sort();
    var best = 0;
    var current = 0;
    DateTime? prev;
    for (final day in days) {
      if (prev != null && day.difference(prev).inDays == 1) {
        current++;
      } else {
        current = 1;
      }
      best = current > best ? current : best;
      prev = day;
    }
    return best;
  }

  @override
  void onClose() {
    _sessionsSub?.cancel();
    _booksSub?.cancel();
    super.onClose();
  }
}
