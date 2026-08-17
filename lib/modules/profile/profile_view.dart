import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/cards.dart';
import '../../core/widgets/inputs.dart';
import '../../routes/app_routes.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(isDesktop ? 32 : 18, isDesktop ? 28 : 18,
            isDesktop ? 32 : 18, 28),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Profile', style: AppTextStyles.h1),
              const SizedBox(height: 18),

              // Profile card
              AppCard(
                child: Row(
                  children: [
                    Container(
                      width: 62,
                      height: 62,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [AppColors.greenBright, AppColors.greenMuted],
                        ),
                      ),
                      alignment: Alignment.center,
                      child: const Text('QK',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontSize: 20)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Qossay Kamel', style: AppTextStyles.h3),
                          const SizedBox(height: 2),
                          Text('kamelqossay@gmail.com',
                              style: AppTextStyles.bodySecondary),
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.green.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.green.withOpacity(0.4)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.workspace_premium_rounded,
                              size: 14, color: AppColors.green),
                          SizedBox(width: 5),
                          Text('Premium',
                              style: TextStyle(
                                  color: AppColors.green,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              _sectionTitle('Reading Goals'),
              AppCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Column(
                  children: const [
                    SettingsRow(
                        icon: Icons.flag_rounded, label: 'Daily Goal', value: '60 min'),
                    Divider(color: AppColors.border, height: 1),
                    SettingsRow(
                        icon: Icons.speed_rounded,
                        label: 'Daily WPM Target',
                        value: '350 WPM'),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              _sectionTitle('Preferences'),
              AppCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Column(
                  children: const [
                    SettingsRow(
                        icon: Icons.bolt_rounded, label: 'Default WPM', value: '320 WPM'),
                    Divider(color: AppColors.border, height: 1),
                    SettingsRow(
                        icon: Icons.dark_mode_rounded, label: 'Theme', value: 'Dark'),
                    Divider(color: AppColors.border, height: 1),
                    SettingsRow(
                        icon: Icons.font_download_rounded, label: 'Font', value: 'Inter'),
                    Divider(color: AppColors.border, height: 1),
                    SettingsRow(
                        icon: Icons.highlight_rounded,
                        label: 'Highlight Style',
                        value: 'Bold Green'),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              _sectionTitle('More'),
              AppCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Column(
                  children: [
                    const SettingsRow(
                        icon: Icons.language_rounded, label: 'Language', value: 'English'),
                    const Divider(color: AppColors.border, height: 1),
                    const SettingsRow(
                        icon: Icons.info_outline_rounded,
                        label: 'About ReadSpeed',
                        value: 'v1.0.0'),
                    const Divider(color: AppColors.border, height: 1),
                    SettingsRow(
                      icon: Icons.logout_rounded,
                      label: 'Logout',
                      iconColor: AppColors.danger,
                      onTap: () => Get.offAllNamed(AppRoutes.onboarding),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),
      child: Text(title, style: AppTextStyles.caption),
    );
  }
}
