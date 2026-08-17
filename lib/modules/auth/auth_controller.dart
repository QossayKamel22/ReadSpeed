import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/services/auth_service.dart';
import '../../routes/app_routes.dart';

class AuthController extends GetxController {
  final _auth = Get.find<AuthService>();

  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final nameCtrl = TextEditingController();

  final isLoading = false.obs;
  final errorMessage = RxnString();

  Future<void> submitSignIn() async {
    if (isLoading.value) return;
    errorMessage.value = null;
    if (emailCtrl.text.trim().isEmpty || passwordCtrl.text.isEmpty) {
      errorMessage.value = 'Enter your email and password.';
      return;
    }
    isLoading.value = true;
    try {
      await _auth.signIn(email: emailCtrl.text, password: passwordCtrl.text);
      Get.offAllNamed(AppRoutes.shell);
    } catch (e) {
      errorMessage.value = AuthService.friendlyError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitSignUp() async {
    if (isLoading.value) return;
    errorMessage.value = null;
    if (nameCtrl.text.trim().isEmpty) {
      errorMessage.value = 'Tell us your name.';
      return;
    }
    if (emailCtrl.text.trim().isEmpty || passwordCtrl.text.isEmpty) {
      errorMessage.value = 'Enter an email and password.';
      return;
    }
    if (passwordCtrl.text.length < 6) {
      errorMessage.value = 'Password must be at least 6 characters.';
      return;
    }
    isLoading.value = true;
    try {
      await _auth.signUp(
        email: emailCtrl.text,
        password: passwordCtrl.text,
        displayName: nameCtrl.text,
      );
      Get.offAllNamed(AppRoutes.shell);
    } catch (e) {
      errorMessage.value = AuthService.friendlyError(e);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    nameCtrl.dispose();
    super.onClose();
  }
}
