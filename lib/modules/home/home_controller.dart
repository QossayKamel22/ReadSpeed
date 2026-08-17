import 'dart:async';

import 'package:get/get.dart';

import '../../data/models/book.dart';
import '../../data/models/reading_session.dart';
import '../../data/models/user_profile.dart';
import '../../data/repositories/book_repository.dart';
import '../../data/repositories/session_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/services/auth_service.dart';
import '../reader/reader_controller.dart';
import '../shell/shell_controller.dart';

class HomeController extends GetxController {
  final _auth = Get.find<AuthService>();
  final _bookRepo = BookRepository();
  final _sessionRepo = SessionRepository();
  final _userRepo = UserRepository();

  final isLoading = true.obs;
  final profile = Rxn<UserProfile>();
  final books = <Book>[].obs;
  final _sessions = <ReadingSession>[].obs;

  StreamSubscription? _profileSub;
  StreamSubscription? _booksSub;
  StreamSubscription? _sessionsSub;

  int get dailyGoalMinutes => profile.value?.dailyGoalMinutes ?? 60;

  int get dailyProgressMinutes {
    final startOfToday = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final seconds = _sessions
        .where((s) => s.createdAt != null && s.createdAt!.isAfter(startOfToday))
        .fold<int>(0, (sum, s) => sum + s.durationSeconds);
    return seconds ~/ 60;
  }

  double get dailyProgress =>
      dailyGoalMinutes == 0 ? 0 : (dailyProgressMinutes / dailyGoalMinutes).clamp(0, 1);

  int get avgWpm {
    if (_sessions.isEmpty) return profile.value?.defaultWpm ?? 320;
    return (_sessions.fold<int>(0, (sum, s) => sum + s.wpm) / _sessions.length).round();
  }

  int get avgAccuracy {
    if (_sessions.isEmpty) return 0;
    return (_sessions.fold<int>(0, (sum, s) => sum + s.accuracy) / _sessions.length).round();
  }

  int get streakDays {
    if (_sessions.isEmpty) return 0;
    final days = _sessions
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

  Book? get continueReading {
    final inProgress = books.where((b) => b.progress > 0 && b.progress < 1).toList();
    if (inProgress.isNotEmpty) return inProgress.first;
    return books.isNotEmpty ? books.first : null;
  }

  List<Book> get recentBooks => books.take(10).toList();

  @override
  void onInit() {
    super.onInit();
    final uid = _auth.uid;
    if (uid == null) {
      isLoading.value = false;
      return;
    }
    _profileSub = _userRepo.watch(uid).listen((p) => profile.value = p);
    _booksSub = _bookRepo.watchBooks(uid).listen((list) {
      books.assignAll(list);
      isLoading.value = false;
    });
    _sessionsSub = _sessionRepo.watchSessions(uid).listen((list) {
      _sessions.assignAll(list);
    });
  }

  void startSession() {
    final book = continueReading;
    if (book != null) {
      Get.find<ReaderController>().loadBook(book);
    }
    Get.find<ShellController>().goTo(2);
  }

  void openBook(Book book) {
    Get.find<ReaderController>().loadBook(book);
  }

  @override
  void onClose() {
    _profileSub?.cancel();
    _booksSub?.cancel();
    _sessionsSub?.cancel();
    super.onClose();
  }
}
