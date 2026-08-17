import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/cards.dart';
import '../../core/widgets/inputs.dart';
import 'statistics_controller.dart';

class StatisticsView extends StatelessWidget {
  const StatisticsView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(StatisticsController());
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 900;
    final overviewCols = width >= 700 ? 4 : 2;

    return SafeArea(
      child: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.green));
        }
        if (c.sessions.isEmpty) {
          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
                isDesktop ? 32 : 18, isDesktop ? 28 : 18, isDesktop ? 32 : 18, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Statistics', style: AppTextStyles.h1),
                const SizedBox(height: 40),
                Center(
                  child: Text(
                    'No reading sessions yet.\nFinish a session in the Reader to see your stats here.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodySecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(isDesktop ? 32 : 18, isDesktop ? 28 : 18,
              isDesktop ? 32 : 18, 28),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Statistics', style: AppTextStyles.h1),
                const SizedBox(height: 18),
                FilterTabs(
                  options: StatisticsController.periods,
                  selected: c.period.value,
                  onSelected: (v) => c.period.value = v,
                ),
                const SizedBox(height: 20),
                GridView.count(
                  crossAxisCount: overviewCols,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.5,
                  children: [
                    StatCard(label: 'Avg WPM', value: '${c.avgWpm}'),
                    StatCard(label: 'Total Minutes', value: '${c.totalMinutes}'),
                    StatCard(label: 'Words Read', value: _formatCount(c.totalWordsRead)),
                    StatCard(label: 'Sessions', value: '${c.sessionCount}'),
                  ],
                ),
                const SizedBox(height: 20),
                ChartCard(
                  title: 'WPM Progress',
                  chart: SizedBox(height: 180, child: _wpmChart(c.wpmTrend)),
                ),
                const SizedBox(height: 16),
                ChartCard(
                  title: 'Reading Time',
                  chart: SizedBox(height: 180, child: _readingTimeChart(c.readingTimeTrend)),
                ),
                const SizedBox(height: 16),
                LayoutBuilder(builder: (context, constraints) {
                  final wide = constraints.maxWidth > 700;
                  final breakdown = c.categoryBreakdown;
                  final categories = ChartCard(
                    title: 'Categories',
                    chart: breakdown.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Text('No categorized sessions yet.',
                                style: AppTextStyles.bodySecondary),
                          )
                        : _categoriesChart(breakdown),
                  );
                  final streak = AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Best Streak', style: AppTextStyles.caption),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.local_fire_department_rounded,
                                color: Color(0xFFE0A83B), size: 40),
                            const SizedBox(width: 10),
                            Text('${c.bestStreakDays}',
                                style: AppTextStyles.numberLarge.copyWith(fontSize: 44)),
                            const SizedBox(width: 6),
                            Padding(
                              padding: const EdgeInsets.only(top: 14),
                              child: Text('days', style: AppTextStyles.bodySecondary),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Keep it going — current streak: ${c.currentStreakDays} days',
                            style: AppTextStyles.bodySecondary),
                      ],
                    ),
                  );
                  if (wide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: categories),
                        const SizedBox(width: 16),
                        Expanded(child: streak),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      categories,
                      const SizedBox(height: 16),
                      streak,
                    ],
                  );
                }),
              ],
            ),
          ),
        );
      }),
    );
  }

  String _formatCount(int value) {
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(value >= 10000 ? 0 : 1)}K';
    return '$value';
  }

  Widget _wpmChart(List<double> data) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineTouchData: const LineTouchData(enabled: false),
        minY: (data.reduce((a, b) => a < b ? a : b)) - 20,
        maxY: (data.reduce((a, b) => a > b ? a : b)) + 20,
        lineBarsData: [
          LineChartBarData(
            spots: [
              for (int i = 0; i < data.length; i++) FlSpot(i.toDouble(), data[i])
            ],
            isCurved: true,
            color: AppColors.green,
            barWidth: 3,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.green.withOpacity(0.25), AppColors.green.withOpacity(0.0)],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _readingTimeChart(List<double> data) {
    final maxVal = data.isEmpty ? 1.0 : data.reduce((a, b) => a > b ? a : b);
    return BarChart(
      BarChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        barTouchData: BarTouchData(enabled: false),
        maxY: maxVal + 15,
        barGroups: [
          for (int i = 0; i < data.length; i++)
            BarChartGroupData(x: i, barRods: [
              BarChartRodData(
                toY: data[i],
                color: AppColors.greenBright,
                width: 18,
                borderRadius: BorderRadius.circular(6),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: maxVal + 15,
                  color: AppColors.cardElevated,
                ),
              ),
            ]),
        ],
      ),
    );
  }

  Widget _categoriesChart(Map<String, double> breakdown) {
    final entries = breakdown.entries.toList();
    final colors = [
      AppColors.green,
      AppColors.greenBright,
      AppColors.greenMuted,
      const Color(0xFFE0A83B),
      AppColors.textMuted,
    ];
    return Column(
      children: [
        SizedBox(
          height: 140,
          child: PieChart(
            PieChartData(
              sectionsSpace: 3,
              centerSpaceRadius: 34,
              sections: [
                for (int i = 0; i < entries.length; i++)
                  PieChartSectionData(
                    value: entries[i].value,
                    color: colors[i % colors.length],
                    radius: 26,
                    showTitle: false,
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 14,
          runSpacing: 8,
          children: [
            for (int i = 0; i < entries.length; i++)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                        color: colors[i % colors.length], shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 6),
                  Text(entries[i].key, style: AppTextStyles.caption),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
