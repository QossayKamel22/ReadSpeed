import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/logo.dart';
import '../../routes/app_routes.dart';
import 'auth_controller.dart';
import 'widgets/auth_text_field.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(AuthController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  const Center(child: ReadSpeedLogo(size: 56)),
                  const SizedBox(height: 24),
                  Text('Create your account', style: AppTextStyles.display.copyWith(fontSize: 28)),
                  const SizedBox(height: 6),
                  Text('Start building a lifelong reading habit.',
                      style: AppTextStyles.bodySecondary),
                  const SizedBox(height: 28),
                  AuthTextField(label: 'Name', controller: c.nameCtrl, hint: 'e.g. Qossay Kamel'),
                  const SizedBox(height: 14),
                  AuthTextField(
                    label: 'Email',
                    controller: c.emailCtrl,
                    hint: 'you@example.com',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 14),
                  AuthTextField(
                    label: 'Password',
                    controller: c.passwordCtrl,
                    hint: 'At least 6 characters',
                    obscure: true,
                  ),
                  const SizedBox(height: 8),
                  Obx(() {
                    final err = c.errorMessage.value;
                    if (err == null) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(err,
                          style: AppTextStyles.caption.copyWith(color: AppColors.danger)),
                    );
                  }),
                  const SizedBox(height: 20),
                  Obx(() => PrimaryButton(
                        label: c.isLoading.value ? 'Creating account...' : 'Create Account',
                        expand: true,
                        onTap: c.isLoading.value ? null : c.submitSignUp,
                      )),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an account?', style: AppTextStyles.bodySecondary),
                      TextButton(
                        onPressed: () => Get.offNamed(AppRoutes.signIn),
                        child: Text('Sign in',
                            style: AppTextStyles.body.copyWith(
                                color: AppColors.green, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
