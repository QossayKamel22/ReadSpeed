import 'package:get/get.dart';
import '../modules/auth/auth_gate_view.dart';
import '../modules/auth/sign_in_view.dart';
import '../modules/auth/sign_up_view.dart';
import '../modules/onboarding/onboarding_view.dart';
import '../modules/shell/shell_view.dart';
import 'app_routes.dart';
import 'auth_guard.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.gate, page: () => const AuthGateView()),
    GetPage(name: AppRoutes.onboarding, page: () => const OnboardingView()),
    GetPage(name: AppRoutes.signIn, page: () => const SignInView()),
    GetPage(name: AppRoutes.signUp, page: () => const SignUpView()),
    GetPage(
      name: AppRoutes.shell,
      page: () => const ShellView(),
      middlewares: [AuthGuard()],
    ),
  ];
}
