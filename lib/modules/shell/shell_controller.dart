import 'package:get/get.dart';

class ShellController extends GetxController {
  final tabIndex = 0.obs;

  static const tabs = ['Home', 'Library', 'Reader', 'Statistics', 'Profile'];
  static const icons = [
    'home',
    'library',
    'reader',
    'statistics',
    'profile',
  ];

  void goTo(int i) {
    tabIndex.value = i;
  }
}
