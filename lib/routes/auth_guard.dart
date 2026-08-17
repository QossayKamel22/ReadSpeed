import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../data/services/auth_service.dart';
import 'app_routes.dart';

/// Blocks navigation to protected routes (the app shell) unless a Firebase
/// user is signed in.
class AuthGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final auth = Get.find<AuthService>();
    if (!auth.isSignedIn) {
      return const RouteSettings(name: AppRoutes.onboarding);
    }
    return null;
  }
}
