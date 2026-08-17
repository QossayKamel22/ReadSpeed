import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_modal.dart';
import '../reader_controller.dart';

class ReaderSettingsModal extends StatelessWidget {
  const ReaderSettingsModal({super.key});

  static Future<void> show(BuildContext context) {
    return AppModal.show(context, const ReaderSettingsModal());
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ReaderController>();
    return AppModal(
      title: 'Reader Settings',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Speed (WPM)', style: AppTextStyles.caption),
          const SizedBox(height: 8),
          Obx(() => Row(
                children: [
                  Text('${c.wpm.value}', style: AppTextStyles.h3.copyWith(color: AppColors.green)),
                  Expanded(
                    child: Slider(
                      min: 100,
                      max: 900,
                      divisions: 80,
                      value: c.wpm.value.toDouble(),
                      onChanged: (v) => c.setWpm(v.round()),
                    ),
                  ),
                ],
              )),
          const SizedBox(height: 14),
          _sectionChips('Font', ['Inter', 'Serif', 'Mono'], c.fontChoice, (v) {
            c.fontChoice = v;
            c.update();
          }),
          const SizedBox(height: 18),
          _sectionChips('Theme', ['Dark', 'Darker', 'Black'], c.themeChoice, (v) {
            c.themeChoice = v;
            c.update();
          }),
          const SizedBox(height: 18),
          _sectionChips('Display Mode', ['Focus', 'Scroll'], c.displayMode, (v) {
            c.displayMode = v;
            c.update();
          }),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _sectionChips(
      String label, List<String> options, String selected, ValueChanged<String> onSelect) {
    return GetBuilder<ReaderController>(
      builder: (c) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.caption),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options.map((o) {
              final isSel = o == selected;
              return GestureDetector(
                onTap: () => onSelect(o),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSel ? AppColors.green : AppColors.card,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isSel ? AppColors.green : AppColors.border),
                  ),
                  child: Text(o,
                      style: AppTextStyles.bodySecondary.copyWith(
                          color: isSel ? Colors.black : AppColors.textSecondary,
                          fontWeight: FontWeight.w600)),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
