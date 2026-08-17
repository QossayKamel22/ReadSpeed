import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppSearchBar extends StatelessWidget {
  final String hint;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;

  const AppSearchBar({
    super.key,
    this.hint = 'Search...',
    this.onChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: AppTextStyles.body,
        cursorColor: AppColors.green,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.bodySecondary,
          prefixIcon: const Icon(Icons.search_rounded,
              color: AppColors.textMuted, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

class FilterTabs extends StatelessWidget {
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelected;

  const FilterTabs({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: options.map((o) {
          final isSelected = o == selected;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => onSelected(o),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.green : AppColors.card,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: isSelected ? AppColors.green : AppColors.border),
                  ),
                  child: Text(
                    o,
                    style: AppTextStyles.bodySecondary.copyWith(
                      color: isSelected ? Colors.black : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class SettingsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? iconColor;

  const SettingsRow({
    super.key,
    required this.icon,
    required this.label,
    this.value,
    this.onTap,
    this.trailing,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: (iconColor ?? AppColors.green).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: iconColor ?? AppColors.green),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(label,
                    style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500)),
              ),
              if (trailing != null)
                trailing!
              else if (value != null)
                Text(value!, style: AppTextStyles.bodySecondary),
              if (onTap != null && trailing == null)
                const Padding(
                  padding: EdgeInsets.only(left: 6),
                  child: Icon(Icons.chevron_right_rounded,
                      color: AppColors.textMuted, size: 20),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
