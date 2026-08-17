import 'dart:async';
import 'package:get/get.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/book.dart';

class ReaderController extends GetxController {
  late List<String> words;
  final currentIndex = 0.obs;
  final wpm = 320.obs;
  final isPlaying = false.obs;
  final elapsedSeconds = 0.obs;
  Timer? _timer;
  Timer? _clock;

  Book? book;

  String fontChoice = 'Inter';
  String themeChoice = 'Dark';
  String displayMode = 'Focus'; // Focus | Scroll

  @override
  void onInit() {
    super.onInit();
    words = MockData.sampleParagraph.split(RegExp(r'\s+'));
    book = MockData.continueReading;
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

  @override
  void onClose() {
    _stopTimers();
    super.onClose();
  }
}
