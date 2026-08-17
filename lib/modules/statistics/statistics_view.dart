import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/cards.dart';
import '../../core/widgets/inputs.dart';
import '../../data/mock/mock_data.dart';
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
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(isDesktop ? 32 : 18, isDesktop ? 28 : 18,
            isDesktop ? 32 : 18, 28),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Statistics', style: AppTextStyles.h1),
              const SizedBox(height: 18),
              Obx(() => FilterTabs(
                    options: StatisticsController.periods,
                    selected: c.period.value,
                    onSelected: (v) => c.period.value = v,
                  )),
              const SizedBox(height: 20),
              GridView.count(
                crossAxisCount: overviewCols,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: const [
                  StatCard(label: 'Avg WPM', value: '320', delta: '+12%'),
                  StatCard(label: 'Total Minutes', value: '1,240', delta: '+8%'),
                  StatCard(label: 'Words Read', value: '245K', delta: '+15%'),
                  StatCard(label: 'Sessions', value: '28', delta: '+4%'),
                ],
              ),
              const SizedBox(height: 20),
              ChartCard(
                title: 'WPM Progress',
                chart: SizedBox(height: 180, child: _wpmChart()),
              ),
              const SizedBox(height: 16),
              ChartCard(
                title: 'Reading Time',
                chart: SizedBox(height: 180, child: _readingTimeChart()),
              ),
              const SizedBox(height: 16),
              LayoutBuilder(builder: (context, constraints) {
                final wide = constraints.maxWidth > 700;
                final categories = ChartCard(
                  title: 'Categories',
                  chart: _categoriesChart(),
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
                          Text('21', style: AppTextStyles.numberLarge.copyWith(fontSize: 44)),
                          const SizedBox(width: 6),
                          Padding(
                            padding: const EdgeInsets.only(top: 14),
                            child: Text('days', style: AppTextStyles.bodySecondary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Keep it going — current streak: 7 days',
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
      ),
    );
  }

  Widget _wpmChart() {
    final data = MockData.wpmTrend;
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

  Widget _readingTimeChart() {
    final data = MockData.readingTimeTrend;
    return BarChart(
      BarChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        barTouchData: BarTouchData(enabled: false),
        maxY: (data.reduce((a, b) => a > b ? a : b)) + 15,
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
                  toY: (data.reduce((a, b) => a > b ? a : b)) + 15,
                  color: AppColors.cardElevated,
                ),
              ),
            ]),
        ],
      ),
    );
  }

  Widget _categoriesChart() {
    final entries = MockData.categoryBreakdown.entries.toList();
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
