import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppModal extends StatelessWidget {
  final String title;
  final Widget child;
  final List<Widget>? actions;

  const AppModal({
    super.key,
    required this.title,
    required this.child,
    this.actions,
  });

  static Future<T?> show<T>(BuildContext context, Widget content) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => content,
    );
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth > 560 ? 480 : maxWidth),
          margin: const EdgeInsets.symmetric(horizontal: 12),
          decoration: const BoxDecoration(
            color: AppColors.cardElevated,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: EdgeInsets.only(
            left: 22,
            right: 22,
            top: 14,
            bottom: MediaQuery.of(context).viewInsets.bottom + 22,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: AppTextStyles.h2),
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.close_rounded,
                        color: AppColors.textMuted),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Flexible(child: SingleChildScrollView(child: child)),
              if (actions != null) ...[
                const SizedBox(height: 18),
                ...actions!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
