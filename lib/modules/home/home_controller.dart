import 'package:get/get.dart';
import '../shell/shell_controller.dart';

class HomeController extends GetxController {
  final dailyGoalMinutes = 60;
  final dailyProgressMinutes = 35.obs;

  double get dailyProgress => dailyProgressMinutes.value / dailyGoalMinutes;

  void startSession() {
    Get.find<ShellController>().goTo(2); // Reader tab
  }
}
