import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/book_card.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/cards.dart';
import '../../core/widgets/progress_bar.dart';
import '../library/widgets/book_details_modal.dart';
import 'home_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(HomeController());
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return SafeArea(
      child: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.green));
        }
        final firstName = (c.profile.value?.displayName ?? 'Reader').split(' ').first;
        final continueBook = c.continueReading;

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(isDesktop ? 32 : 18, isDesktop ? 28 : 18,
              isDesktop ? 32 : 18, 28),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Hi, $firstName 👋', style: AppTextStyles.h1),
                          const SizedBox(height: 4),
                          Text("Let's complete your daily goal!",
                              style: AppTextStyles.bodySecondary),
                        ],
                      ),
                    ),
                    IconCircleButton(
                      icon: Icons.notifications_none_rounded,
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Daily goal
                AppCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('DAILY GOAL', style: AppTextStyles.caption),
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text('${c.dailyProgressMinutes}',
                                    style: AppTextStyles.numberGreen),
                                Text(' / ${c.dailyGoalMinutes} min',
                                    style: AppTextStyles.bodySecondary),
                              ],
                            ),
                            const SizedBox(height: 14),
                            AppProgressBar(value: c.dailyProgress.toDouble()),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      CircularProgress(value: c.dailyProgress.toDouble(), size: 76),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Continue reading
                if (continueBook != null) ...[
                  ContinueReadingCard(
                    book: continueBook,
                    onTap: () => BookDetailsModal.show(context, continueBook),
                  ),
                  const SizedBox(height: 24),
                ],

                // Metrics
                Text('Quick Metrics', style: AppTextStyles.h3),
                const SizedBox(height: 12),
                LayoutBuilder(builder: (context, constraints) {
                  return GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: isDesktop ? 1.4 : 0.95,
                    children: [
                      MetricCard(
                          label: 'WPM', value: '${c.avgWpm}', icon: Icons.speed_rounded),
                      MetricCard(
                          label: 'Accuracy',
                          value: '${c.avgAccuracy}%',
                          icon: Icons.track_changes_rounded,
                          accent: AppColors.greenBright),
                      MetricCard(
                          label: 'Streak',
                          value: '${c.streakDays} days',
                          icon: Icons.local_fire_department_rounded,
                          accent: const Color(0xFFE0A83B)),
                    ],
                  );
                }),
                const SizedBox(height: 24),

                // Quick start
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: c.startSession,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [AppColors.greenMuted, Color(0xFF0B4A29)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(color: AppColors.green.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.25),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.play_arrow_rounded,
                                color: AppColors.greenBright, size: 26),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Start a new reading session',
                                    style: AppTextStyles.h3
                                        .copyWith(color: Colors.white)),
                                const SizedBox(height: 2),
                                Text('Jump into the speed reader now',
                                    style: AppTextStyles.bodySecondary
                                        .copyWith(color: Colors.white70)),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_rounded, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Recent books
                Text('Recent Books', style: AppTextStyles.h3),
                const SizedBox(height: 12),
                if (c.recentBooks.isEmpty)
                  Text('No books yet — add one from the Library tab.',
                      style: AppTextStyles.bodySecondary)
                else
                  SizedBox(
                    height: 234,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: c.recentBooks.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 14),
                      itemBuilder: (context, i) {
                        final book = c.recentBooks[i];
                        return SizedBox(
                          width: 158,
                          child: BookCard(
                            book: book,
                            onTap: () => BookDetailsModal.show(context, book),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
