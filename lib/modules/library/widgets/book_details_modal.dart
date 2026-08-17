import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_modal.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/cards.dart';
import '../../../core/widgets/progress_bar.dart';
import '../../../data/models/book.dart';
import '../../shell/shell_controller.dart';

class BookDetailsModal extends StatelessWidget {
  final Book book;
  const BookDetailsModal({super.key, required this.book});

  static Future<void> show(BuildContext context, Book book) {
    return AppModal.show(context, BookDetailsModal(book: book));
  }

  @override
  Widget build(BuildContext context) {
    return AppModal(
      title: 'Book Details',
      actions: [
        Row(
          children: [
            Expanded(
              child: SecondaryButton(
                label: 'Read Preview',
                onTap: () => Get.back(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: PrimaryButton(
                label: 'Start Reading',
                onTap: () {
                  Get.back();
                  Get.find<ShellController>().goTo(2);
                },
              ),
            ),
          ],
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BookCoverBox(
                  color: book.coverColor,
                  icon: book.coverIcon,
                  width: 92,
                  height: 128,
                  radius: 16),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(book.title, style: AppTextStyles.h2),
                    const SizedBox(height: 4),
                    Text(book.author, style: AppTextStyles.bodySecondary),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            color: AppColors.green, size: 18),
                        const SizedBox(width: 4),
                        Text(book.rating.toString(), style: AppTextStyles.body),
                        const SizedBox(width: 14),
                        const Icon(Icons.menu_book_outlined,
                            color: AppColors.textMuted, size: 16),
                        const SizedBox(width: 4),
                        Text('${book.pages} pages', style: AppTextStyles.bodySecondary),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.green.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(book.category,
                          style: AppTextStyles.caption.copyWith(color: AppColors.green)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          if (book.progress > 0) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Your progress', style: AppTextStyles.caption),
                Text('${(book.progress * 100).round()}%',
                    style: AppTextStyles.caption.copyWith(color: AppColors.green)),
              ],
            ),
            const SizedBox(height: 8),
            AppProgressBar(value: book.progress),
            const SizedBox(height: 18),
          ],
          Text('Description', style: AppTextStyles.h3),
          const SizedBox(height: 8),
          Text(book.description, style: AppTextStyles.bodySecondary.copyWith(height: 1.5)),
        ],
      ),
    );
  }
}
