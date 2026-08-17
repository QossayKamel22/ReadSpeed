import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppProgressBar extends StatelessWidget {
  final double value; // 0..1
  final double height;
  final Color? color;
  final Color? trackColor;

  const AppProgressBar({
    super.key,
    required this.value,
    this.height = 8,
    this.color,
    this.trackColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: Container(
        height: height,
        color: trackColor ?? AppColors.cardElevated,
        child: Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: value.clamp(0, 1),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 500),
              builder: (context, v, child) => Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      (color ?? AppColors.green).withOpacity(0.85),
                      color ?? AppColors.greenBright,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CircularProgress extends StatelessWidget {
  final double value;
  final double size;
  final String? centerText;
  final String? centerSubText;

  const CircularProgress({
    super.key,
    required this.value,
    this.size = 88,
    this.centerText,
    this.centerSubText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: value.clamp(0, 1),
              strokeWidth: 7,
              backgroundColor: AppColors.cardElevated,
              valueColor: const AlwaysStoppedAnimation(AppColors.green),
              strokeCap: StrokeCap.round,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                centerText ?? '${(value * 100).round()}%',
                style: TextStyle(
                  fontSize: size * 0.2,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              if (centerSubText != null)
                Text(
                  centerSubText!,
                  style: TextStyle(
                    fontSize: size * 0.09,
                    color: AppColors.textMuted,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
