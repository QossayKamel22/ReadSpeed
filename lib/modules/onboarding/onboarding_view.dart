import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/logo.dart';
import '../../routes/app_routes.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 3),
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.green.withOpacity(0.06),
                    ),
                    child: const ReadSpeedLogo(size: 96),
                  ),
                  const SizedBox(height: 32),
                  Text('ReadSpeed',
                      style: AppTextStyles.display, textAlign: TextAlign.center),
                  const SizedBox(height: 10),
                  Text(
                    'Read Faster. Understand Better.',
                    style: AppTextStyles.body.copyWith(
                        color: AppColors.green, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Train your brain to read at superhuman speed with '
                    'science-backed RSVP techniques, track your progress, '
                    'and build a lifelong reading habit.',
                    style: AppTextStyles.bodySecondary,
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(flex: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (i) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: i == 0 ? 22 : 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: i == 0 ? AppColors.green : AppColors.border,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 28),
                  PrimaryButton(
                    label: 'Get Started',
                    expand: true,
                    icon: Icons.arrow_forward_rounded,
                    onTap: () => Get.toNamed(AppRoutes.signUp),
                  ),
                  const SizedBox(height: 14),
                  TextButton(
                    onPressed: () => Get.toNamed(AppRoutes.signIn),
                    child: Text('Sign in',
                        style: AppTextStyles.body.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
