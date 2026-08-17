import 'package:get/get.dart';

class StatisticsController extends GetxController {
  final period = '7 Days'.obs;
  static const periods = ['7 Days', '30 Days', '90 Days', 'All Time'];
}
