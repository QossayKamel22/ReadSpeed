import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
    if (onTap == null) return card;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: card,
      ),
    );
  }
}

class MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color accent;

  const MetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.accent = AppColors.green,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 17, color: accent),
          ),
          const SizedBox(height: 14),
          Text(value,
              style: AppTextStyles.h1.copyWith(fontSize: 24),
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? delta;
  final bool deltaPositive;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.delta,
    this.deltaPositive = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.caption),
          const SizedBox(height: 10),
          Text(value, style: AppTextStyles.h1.copyWith(fontSize: 26)),
          if (delta != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  deltaPositive
                      ? Icons.trending_up_rounded
                      : Icons.trending_down_rounded,
                  size: 14,
                  color: deltaPositive ? AppColors.green : AppColors.danger,
                ),
                const SizedBox(width: 4),
                Text(
                  delta!,
                  style: AppTextStyles.caption.copyWith(
                    color: deltaPositive ? AppColors.green : AppColors.danger,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class ChartCard extends StatelessWidget {
  final String title;
  final Widget chart;
  final Widget? trailing;

  const ChartCard({
    super.key,
    required this.title,
    required this.chart,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTextStyles.h3),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 18),
          chart,
        ],
      ),
    );
  }
}

class BookCoverBox extends StatelessWidget {
  final Color color;
  final IconData icon;
  final double width;
  final double height;
  final double radius;

  const BookCoverBox({
    super.key,
    required this.color,
    required this.icon,
    this.width = 56,
    this.height = 78,
    this.radius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color, color.withOpacity(0.5)],
        ),
        border: Border.all(color: AppColors.border),
      ),
      child: Icon(icon, color: Colors.white.withOpacity(0.85), size: width * 0.36),
    );
  }
}
