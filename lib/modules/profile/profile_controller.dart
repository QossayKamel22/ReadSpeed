import 'dart:async';

import 'package:get/get.dart';

import '../../data/models/user_profile.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/services/auth_service.dart';

class ProfileController extends GetxController {
  final _auth = Get.find<AuthService>();
  final _userRepo = UserRepository();

  final isLoading = true.obs;
  final profile = Rxn<UserProfile>();

  StreamSubscription? _sub;

  @override
  void onInit() {
    super.onInit();
    final uid = _auth.uid;
    if (uid == null) {
      isLoading.value = false;
      return;
    }
    _sub = _userRepo.watch(uid).listen((p) {
      profile.value = p;
      isLoading.value = false;
    });
  }

  Future<void> updateDailyGoalMinutes(int minutes) async {
    final uid = _auth.uid;
    if (uid == null) return;
    await _userRepo.updateFields(uid, {'dailyGoalMinutes': minutes});
  }

  Future<void> updateDailyWpmTarget(int wpm) async {
    final uid = _auth.uid;
    if (uid == null) return;
    await _userRepo.updateFields(uid, {'dailyWpmTarget': wpm});
  }

  Future<void> updateDefaultWpm(int wpm) async {
    final uid = _auth.uid;
    if (uid == null) return;
    await _userRepo.updateFields(uid, {'defaultWpm': wpm});
  }

  Future<void> signOut() => _auth.signOut();

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }
}
