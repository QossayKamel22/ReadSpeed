import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/logo.dart';
import '../home/home_view.dart';
import '../library/library_view.dart';
import '../profile/profile_view.dart';
import '../reader/reader_view.dart';
import '../statistics/statistics_view.dart';
import 'shell_controller.dart';

class ShellView extends StatelessWidget {
  const ShellView({super.key});

  static const _labels = ['Home', 'Library', 'Reader', 'Statistics', 'Profile'];
  static const _icons = [
    Icons.home_rounded,
    Icons.menu_book_rounded,
    Icons.bolt_rounded,
    Icons.bar_chart_rounded,
    Icons.person_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ShellController());
    final pages = const [
      HomeView(),
      LibraryView(),
      ReaderView(),
      StatisticsView(),
      ProfileView(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 900;
          return Obx(() {
            final content = IndexedStack(
              index: controller.tabIndex.value,
              children: pages,
            );
            if (isDesktop) {
              return Row(
                children: [
                  _Sidebar(controller: controller, labels: _labels, icons: _icons),
                  Expanded(
                    child: Container(
                      color: AppColors.background,
                      child: content,
                    ),
                  ),
                ],
              );
            }
            return Column(
              children: [
                Expanded(child: content),
                _BottomNav(controller: controller, labels: _labels, icons: _icons),
              ],
            );
          });
        },
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  final ShellController controller;
  final List<String> labels;
  final List<IconData> icons;

  const _Sidebar({required this.controller, required this.labels, required this.icons});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: const BoxDecoration(
        color: AppColors.backgroundSecondary,
        border: Border(right: BorderSide(color: AppColors.border)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 36),
            child: ReadSpeedLogo(size: 34, showWordmark: true),
          ),
          for (int i = 0; i < labels.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Obx(() {
                final selected = controller.tabIndex.value == i;
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => controller.goTo(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 13),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.green.withOpacity(0.12)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selected ? AppColors.green.withOpacity(0.4) : Colors.transparent,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(icons[i],
                              size: 19,
                              color: selected
                                  ? AppColors.green
                                  : AppColors.textSecondary),
                          const SizedBox(width: 13),
                          Text(
                            labels[i],
                            style: AppTextStyles.body.copyWith(
                              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                              color: selected
                                  ? AppColors.textPrimary
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.greenMuted,
                  child: Text('QK', style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w700)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Qossay Kamel',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.body.copyWith(fontSize: 13, fontWeight: FontWeight.w600)),
                      Text('Premium', style: AppTextStyles.caption.copyWith(color: AppColors.green)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final ShellController controller;
  final List<String> labels;
  final List<IconData> icons;

  const _BottomNav({required this.controller, required this.labels, required this.icons});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.backgroundSecondary,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      padding: EdgeInsets.only(
        top: 10,
        bottom: 8 + MediaQuery.of(context).padding.bottom,
        left: 8,
        right: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (int i = 0; i < labels.length; i++)
            Obx(() {
              final selected = controller.tabIndex.value == i;
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => controller.goTo(i),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icons[i],
                            size: 22,
                            color: selected ? AppColors.green : AppColors.textMuted),
                        const SizedBox(height: 4),
                        Text(
                          labels[i] == 'Statistics' ? 'Stats' : labels[i],
                          style: AppTextStyles.caption.copyWith(
                            fontSize: 10,
                            color: selected ? AppColors.green : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}
