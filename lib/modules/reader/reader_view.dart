import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/progress_bar.dart';
import '../shell/shell_controller.dart';
import 'reader_controller.dart';
import 'widgets/reader_settings_modal.dart';
import 'widgets/reading_complete_modal.dart';

class ReaderView extends StatelessWidget {
  const ReaderView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ReaderController(), permanent: true);
    c.onFinished = () {
      final ctx = Get.context;
      if (ctx != null) {
        ReadingCompleteModal.show(
          ctx,
          avgWpm: c.wpm.value,
          accuracy: 92,
          time: _fmtTime(c.elapsedSeconds.value),
          words: c.words.length,
        );
      }
    };

    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return SafeArea(
      child: Container(
        color: AppColors.background,
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: EdgeInsets.fromLTRB(isDesktop ? 32 : 16, 16, isDesktop ? 32 : 16, 0),
              child: Row(
                children: [
                  IconCircleButton(
                    icon: Icons.arrow_back_rounded,
                    size: 40,
                    onTap: () => Get.find<ShellController>().goTo(0),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Obx(() => Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(c.book.value?.title ?? 'Pick a book to start',
                                style: AppTextStyles.h3, textAlign: TextAlign.center),
                            Text(c.book.value?.author ?? '',
                                style: AppTextStyles.caption, textAlign: TextAlign.center),
                          ],
                        )),
                  ),
                  IconCircleButton(
                    icon: Icons.center_focus_strong_rounded,
                    size: 40,
                    onTap: () {},
                  ),
                  const SizedBox(width: 10),
                  IconCircleButton(
                    icon: Icons.tune_rounded,
                    size: 40,
                    onTap: () => ReaderSettingsModal.show(context),
                  ),
                ],
              ),
            ),

            // Reading area
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(() => AnimatedSwitcher(
                              duration: const Duration(milliseconds: 120),
                              transitionBuilder: (child, anim) =>
                                  FadeTransition(opacity: anim, child: child),
                              child: Text(
                                c.currentWord,
                                key: ValueKey(c.currentIndex.value),
                                textAlign: TextAlign.center,
                                style: AppTextStyles.display.copyWith(
                                  fontSize: 46,
                                  color: AppColors.greenBright,
                                ),
                              ),
                            )),
                        const SizedBox(height: 28),
                        Text(
                          c.contextSentence,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodySecondary.copyWith(height: 1.6),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Bottom controls
            Container(
              padding: EdgeInsets.fromLTRB(
                  isDesktop ? 32 : 18, 18, isDesktop ? 32 : 18, 18),
              decoration: const BoxDecoration(
                color: AppColors.backgroundSecondary,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Column(
                  children: [
                    // WPM control
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconCircleButton(
                          icon: Icons.remove_rounded,
                          size: 36,
                          onTap: c.decWpm,
                        ),
                        const SizedBox(width: 16),
                        Obx(() => Column(
                              children: [
                                Text('${c.wpm.value}',
                                    style: AppTextStyles.numberGreen.copyWith(fontSize: 30)),
                                Text('WPM', style: AppTextStyles.caption),
                              ],
                            )),
                        const SizedBox(width: 16),
                        IconCircleButton(
                          icon: Icons.add_rounded,
                          size: 36,
                          onTap: c.incWpm,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Obx(() => SliderTheme(
                          data: SliderTheme.of(context).copyWith(trackHeight: 3),
                          child: Slider(
                            min: 100,
                            max: 900,
                            value: c.wpm.value.toDouble(),
                            onChanged: (v) => c.setWpm(v.round()),
                          ),
                        )),
                    const SizedBox(height: 8),

                    // Playback
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconCircleButton(
                          icon: Icons.replay_10_rounded,
                          size: 46,
                          onTap: () => c.skip(-10),
                        ),
                        const SizedBox(width: 22),
                        Obx(() => Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: c.togglePlay,
                                borderRadius: BorderRadius.circular(40),
                                child: Container(
                                  width: 72,
                                  height: 72,
                                  decoration: const BoxDecoration(
                                    color: AppColors.green,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0x4022E06F),
                                        blurRadius: 24,
                                        spreadRadius: -4,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    c.isPlaying.value
                                        ? Icons.pause_rounded
                                        : Icons.play_arrow_rounded,
                                    color: Colors.black,
                                    size: 36,
                                  ),
                                ),
                              ),
                            )),
                        const SizedBox(width: 22),
                        IconCircleButton(
                          icon: Icons.forward_10_rounded,
                          size: 46,
                          onTap: () => c.skip(10),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Progress
                    Obx(() => Column(
                          children: [
                            AppProgressBar(value: c.progress, height: 6),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${(c.progress * 100).round()}%',
                                    style: AppTextStyles.caption),
                                Text(
                                    '${c.currentIndex.value + 1} / ${c.words.length} words',
                                    style: AppTextStyles.caption),
                              ],
                            ),
                          ],
                        )),
                    const SizedBox(height: 16),

                    // Session stats
                    Obx(() => Row(
                          children: [
                            _sessionStat('Time', _fmtTime(c.elapsedSeconds.value)),
                            _sessionStat('Words', '${c.currentIndex.value + 1}'),
                            _sessionStat('Accuracy', '92%'),
                          ],
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sessionStat(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: AppTextStyles.h3),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }

  String _fmtTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
