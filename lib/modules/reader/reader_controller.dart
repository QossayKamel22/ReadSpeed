import 'dart:async';
import 'package:get/get.dart';

import '../../data/mock/mock_data.dart';
import '../../data/models/book.dart';
import '../../data/repositories/book_repository.dart';
import '../../data/repositories/session_repository.dart';
import '../../data/services/auth_service.dart';

class ReaderController extends GetxController {
  final _bookRepo = BookRepository();
  final _sessionRepo = SessionRepository();

  late List<String> words;
  final currentIndex = 0.obs;
  final wpm = 320.obs;
  final isPlaying = false.obs;
  final elapsedSeconds = 0.obs;
  Timer? _timer;
  Timer? _clock;

  final Rxn<Book> book = Rxn<Book>();

  String fontChoice = 'Inter';
  String themeChoice = 'Dark';
  String displayMode = 'Focus'; // Focus | Scroll

  @override
  void onInit() {
    super.onInit();
    words = MockData.sampleParagraph.split(RegExp(r'\s+'));
  }

  /// Loads a book into the reader, resuming from its last saved position.
  void loadBook(Book newBook) {
    reset();
    book.value = newBook;
    currentIndex.value = newBook.lastPositionIndex.clamp(0, words.length - 1);
  }

  double get progress => words.isEmpty ? 0 : currentIndex.value / (words.length - 1);

  String get currentWord =>
      words.isEmpty ? '' : words[currentIndex.value.clamp(0, words.length - 1)];

  String get contextSentence => MockData.sampleParagraph;

  void togglePlay() {
    isPlaying.value = !isPlaying.value;
    if (isPlaying.value) {
      _startTimers();
    } else {
      _stopTimers();
      _persistProgress();
    }
  }

  void _startTimers() {
    _scheduleNextWord();
    _clock?.cancel();
    _clock = Timer.periodic(const Duration(seconds: 1), (_) {
      elapsedSeconds.value++;
    });
  }

  void _scheduleNextWord() {
    _timer?.cancel();
    final msPerWord = (60000 / wpm.value).round();
    _timer = Timer(Duration(milliseconds: msPerWord), () {
      if (currentIndex.value < words.length - 1) {
        currentIndex.value++;
        if (isPlaying.value) _scheduleNextWord();
      } else {
        isPlaying.value = false;
        _stopTimers();
        _finishSession();
        onFinished?.call();
      }
    });
  }

  void _stopTimers() {
    _timer?.cancel();
    _clock?.cancel();
  }

  void Function()? onFinished;

  void setWpm(int value) {
    wpm.value = value.clamp(100, 900);
    if (isPlaying.value) _scheduleNextWord();
  }

  void incWpm() => setWpm(wpm.value + 10);
  void decWpm() => setWpm(wpm.value - 10);

  void skip(int seconds) {
    final wordsToSkip = ((seconds * wpm.value) / 60).round();
    currentIndex.value =
        (currentIndex.value + wordsToSkip).clamp(0, words.length - 1);
  }

  void seekToProgress(double p) {
    currentIndex.value = (p * (words.length - 1)).round().clamp(0, words.length - 1);
  }

  void reset() {
    _stopTimers();
    isPlaying.value = false;
    currentIndex.value = 0;
    elapsedSeconds.value = 0;
  }

  Future<void> _persistProgress() async {
    final uid = Get.find<AuthService>().uid;
    final b = book.value;
    if (uid == null || b == null) return;
    await _bookRepo.updateProgress(
      uid: uid,
      bookId: b.id,
      progress: progress,
      lastPositionIndex: currentIndex.value,
    );
  }

  Future<void> _finishSession() async {
    final uid = Get.find<AuthService>().uid;
    final b = book.value;
    if (uid == null || b == null) return;
    await _persistProgress();
    await _sessionRepo.addSession(
      uid: uid,
      bookId: b.id,
      wpm: wpm.value,
      accuracy: 92,
      durationSeconds: elapsedSeconds.value,
      wordsRead: words.length,
    );
  }

  @override
  void onClose() {
    _stopTimers();
    super.onClose();
  }
}
