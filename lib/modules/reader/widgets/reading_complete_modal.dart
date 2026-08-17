import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_modal.dart';
import '../../../core/widgets/buttons.dart';

class ReadingCompleteModal extends StatelessWidget {
  final int avgWpm;
  final int accuracy;
  final String time;
  final int words;

  const ReadingCompleteModal({
    super.key,
    required this.avgWpm,
    required this.accuracy,
    required this.time,
    required this.words,
  });

  static Future<void> show(
    BuildContext context, {
    required int avgWpm,
    required int accuracy,
    required String time,
    required int words,
  }) {
    return AppModal.show(
      context,
      ReadingCompleteModal(
          avgWpm: avgWpm, accuracy: accuracy, time: time, words: words),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppModal(
      title: '',
      actions: [
        Row(
          children: [
            Expanded(
              child: SecondaryButton(label: 'View Summary', onTap: () => Get.back()),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: PrimaryButton(label: 'Done', onTap: () => Get.back()),
            ),
          ],
        ),
      ],
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: AppColors.green.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_rounded, color: AppColors.green, size: 40),
          ),
          const SizedBox(height: 18),
          Text('Great job!', style: AppTextStyles.h1),
          const SizedBox(height: 4),
          Text('You completed your reading session.',
              style: AppTextStyles.bodySecondary),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _stat('Avg WPM', '$avgWpm')),
              const SizedBox(width: 12),
              Expanded(child: _stat('Accuracy', '$accuracy%')),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _stat('Time', time)),
              const SizedBox(width: 12),
              Expanded(child: _stat('Words', '$words')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stat(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(value, style: AppTextStyles.h2),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}
