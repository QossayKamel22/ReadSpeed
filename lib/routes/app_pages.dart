import 'package:get/get.dart';
import '../modules/onboarding/onboarding_view.dart';
import '../modules/shell/shell_view.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.onboarding, page: () => const OnboardingView()),
    GetPage(name: AppRoutes.shell, page: () => const ShellView()),
  ];
}
