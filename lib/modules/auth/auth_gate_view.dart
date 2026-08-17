import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/logo.dart';
import '../../data/services/auth_service.dart';
import '../../routes/app_routes.dart';

/// Initial route. Shows a brief splash while Firebase resolves whether a
/// user session already exists, then routes to the shell (signed in) or
/// onboarding (signed out) — this is what makes auth state "persist" across
/// app restarts instead of forcing sign-in every launch.
class AuthGateView extends StatefulWidget {
  const AuthGateView({super.key});

  @override
  State<AuthGateView> createState() => _AuthGateViewState();
}

class _AuthGateViewState extends State<AuthGateView> {
  @override
  void initState() {
    super.initState();
    final auth = Get.find<AuthService>();
    if (auth.isReady.value) {
      _route(auth);
    } else {
      ever<bool>(auth.isReady, (ready) {
        if (ready) _route(auth);
      });
    }
  }

  void _route(AuthService auth) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Get.offAllNamed(auth.isSignedIn ? AppRoutes.shell : AppRoutes.onboarding);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: Center(child: ReadSpeedLogo(size: 72)),
    );
  }
}
