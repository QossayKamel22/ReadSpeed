import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/cards.dart';
import '../../core/widgets/inputs.dart';
import '../../data/services/auth_service.dart';
import '../../routes/app_routes.dart';
import 'profile_controller.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  Future<void> _editNumber(
    BuildContext context, {
    required String title,
    required int initial,
    required String suffix,
    required ValueChanged<int> onSave,
  }) async {
    final ctrl = TextEditingController(text: '$initial');
    final result = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardElevated,
        title: Text(title, style: AppTextStyles.h3),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          keyboardType: TextInputType.number,
          style: AppTextStyles.body,
          cursorColor: AppColors.green,
          decoration: InputDecoration(
            suffixText: suffix,
            suffixStyle: AppTextStyles.bodySecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel', style: AppTextStyles.bodySecondary),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(int.tryParse(ctrl.text)),
            child: Text('Save', style: AppTextStyles.body.copyWith(color: AppColors.green)),
          ),
        ],
      ),
    );
    if (result != null && result > 0) onSave(result);
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ProfileController());
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return SafeArea(
      child: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.green));
        }
        final profile = c.profile.value;
        final initials = (profile?.displayName ?? 'R')
            .trim()
            .split(RegExp(r'\s+'))
            .where((s) => s.isNotEmpty)
            .take(2)
            .map((s) => s[0].toUpperCase())
            .join();

        return SingleChildScrollView(
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
                        child: Text(initials.isEmpty ? 'R' : initials,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                                fontSize: 20)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(profile?.displayName ?? 'Reader', style: AppTextStyles.h3),
                            const SizedBox(height: 2),
                            Text(profile?.email ?? '', style: AppTextStyles.bodySecondary),
                          ],
                        ),
                      ),
                      if (profile?.premium == true)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                    children: [
                      SettingsRow(
                        icon: Icons.flag_rounded,
                        label: 'Daily Goal',
                        value: '${profile?.dailyGoalMinutes ?? 60} min',
                        onTap: () => _editNumber(
                          context,
                          title: 'Daily Goal (minutes)',
                          initial: profile?.dailyGoalMinutes ?? 60,
                          suffix: 'min',
                          onSave: c.updateDailyGoalMinutes,
                        ),
                      ),
                      const Divider(color: AppColors.border, height: 1),
                      SettingsRow(
                        icon: Icons.speed_rounded,
                        label: 'Daily WPM Target',
                        value: '${profile?.dailyWpmTarget ?? 350} WPM',
                        onTap: () => _editNumber(
                          context,
                          title: 'Daily WPM Target',
                          initial: profile?.dailyWpmTarget ?? 350,
                          suffix: 'WPM',
                          onSave: c.updateDailyWpmTarget,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),

                _sectionTitle('Preferences'),
                AppCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Column(
                    children: [
                      SettingsRow(
                        icon: Icons.bolt_rounded,
                        label: 'Default WPM',
                        value: '${profile?.defaultWpm ?? 320} WPM',
                        onTap: () => _editNumber(
                          context,
                          title: 'Default WPM',
                          initial: profile?.defaultWpm ?? 320,
                          suffix: 'WPM',
                          onSave: c.updateDefaultWpm,
                        ),
                      ),
                      const Divider(color: AppColors.border, height: 1),
                      const SettingsRow(
                          icon: Icons.dark_mode_rounded, label: 'Theme', value: 'Dark'),
                      const Divider(color: AppColors.border, height: 1),
                      const SettingsRow(
                          icon: Icons.font_download_rounded, label: 'Font', value: 'Inter'),
                      const Divider(color: AppColors.border, height: 1),
                      const SettingsRow(
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
                        onTap: () async {
                          await Get.find<AuthService>().signOut();
                          Get.offAllNamed(AppRoutes.onboarding);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),
      child: Text(title, style: AppTextStyles.caption),
    );
  }
}
