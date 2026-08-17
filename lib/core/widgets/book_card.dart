import 'package:flutter/material.dart';
import '../../data/models/book.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'cards.dart';
import 'progress_bar.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback? onTap;

  const BookCard({super.key, required this.book, this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [book.coverColor, book.coverColor.withOpacity(0.45)],
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(book.coverIcon,
                        size: 38, color: Colors.white.withOpacity(0.85)),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.35),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(book.typeLabel,
                          style: AppTextStyles.caption.copyWith(
                              color: Colors.white, fontSize: 10)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(book.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text(book.author,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: AppProgressBar(value: book.progress, height: 5)),
              const SizedBox(width: 8),
              Text('${(book.progress * 100).round()}%',
                  style: AppTextStyles.caption
                      .copyWith(color: AppColors.green, fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }
}

class ContinueReadingCard extends StatelessWidget {
  final Book book;
  final VoidCallback? onTap;

  const ContinueReadingCard({super.key, required this.book, this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          BookCoverBox(color: book.coverColor, icon: book.coverIcon),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('CONTINUE READING',
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.green, letterSpacing: 1)),
                const SizedBox(height: 6),
                Text(book.title, style: AppTextStyles.h3),
                const SizedBox(height: 2),
                Text(book.author, style: AppTextStyles.bodySecondary),
                const SizedBox(height: 12),
                AppProgressBar(value: book.progress, height: 6),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text('${(book.progress * 100).round()}%',
              style: AppTextStyles.h2.copyWith(color: AppColors.green)),
        ],
      ),
    );
  }
}
