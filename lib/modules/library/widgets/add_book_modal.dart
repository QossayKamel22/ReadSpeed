import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_modal.dart';
import '../../../core/widgets/buttons.dart';

class AddBookModal extends StatefulWidget {
  const AddBookModal({super.key});

  static Future<void> show(BuildContext context) {
    return AppModal.show(context, const AddBookModal());
  }

  @override
  State<AddBookModal> createState() => _AddBookModalState();
}

class _AddBookModalState extends State<AddBookModal> {
  int tab = 0;
  final titleCtrl = TextEditingController();
  final authorCtrl = TextEditingController();
  static const tabs = ['Book', 'PDF', 'Text'];

  @override
  Widget build(BuildContext context) {
    return AppModal(
      title: 'Add Book',
      actions: [
        PrimaryButton(
          label: 'Add Book',
          expand: true,
          onTap: () {
            Get.back();
            Get.snackbar(
              'Added to Library',
              '${titleCtrl.text.isEmpty ? "New book" : titleCtrl.text} was added successfully.',
              backgroundColor: AppColors.cardElevated,
              colorText: AppColors.textPrimary,
              snackPosition: SnackPosition.BOTTOM,
              margin: const EdgeInsets.all(16),
              borderRadius: 14,
            );
          },
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: List.generate(tabs.length, (i) {
                final selected = tab == i;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => tab = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: selected ? AppColors.green : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(tabs[i],
                          style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.w600,
                              color: selected ? Colors.black : AppColors.textSecondary)),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Container(
              width: 90,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(Icons.add_photo_alternate_outlined,
                  color: AppColors.textMuted, size: 30),
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: Text('Book cover', style: AppTextStyles.caption),
          ),
          const SizedBox(height: 20),
          _field('Book title', titleCtrl, 'e.g. Atomic Habits'),
          const SizedBox(height: 14),
          _field('Author', authorCtrl, 'e.g. James Clear'),
        ],
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: TextField(
            controller: ctrl,
            style: AppTextStyles.body,
            cursorColor: AppColors.green,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTextStyles.bodySecondary,
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}
