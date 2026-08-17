import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool expand;
  final EdgeInsetsGeometry padding;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onTap,
    this.icon,
    this.expand = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
  });

  @override
  Widget build(BuildContext context) {
    final child = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.green,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3322E06F),
            blurRadius: 20,
            spreadRadius: -6,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: Colors.black),
            const SizedBox(width: 8),
          ],
          Text(label, style: AppTextStyles.button),
        ],
      ),
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: child,
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool expand;

  const SecondaryButton({
    super.key,
    required this.label,
    this.onTap,
    this.icon,
    this.expand = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.cardElevated,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: AppColors.textPrimary),
                const SizedBox(width: 8),
              ],
              Text(label,
                  style: AppTextStyles.body
                      .copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

class IconCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final double size;
  final Color? bg;
  final Color? iconColor;

  const IconCircleButton({
    super.key,
    required this.icon,
    this.onTap,
    this.size = 44,
    this.bg,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(size),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: bg ?? AppColors.cardElevated,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.border),
          ),
          child: Icon(icon, size: size * 0.42, color: iconColor ?? AppColors.textPrimary),
        ),
      ),
    );
  }
}
