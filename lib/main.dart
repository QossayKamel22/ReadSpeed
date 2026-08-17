import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/theme/app_theme.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase is scaffolded for future backend integration (auth, sync,
  // cloud stats). No live project is configured yet, so initialization is
  // best-effort and the app runs fully on local/mock data regardless.
  try {
    await Firebase.initializeApp();
  } catch (_) {
    // No firebase_options.dart / platform config present yet — safe to ignore.
  }
  runApp(const ReadSpeedApp());
}

class ReadSpeedApp extends StatelessWidget {
  const ReadSpeedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ReadSpeed',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      initialRoute: AppRoutes.onboarding,
      getPages: AppPages.pages,
      defaultTransition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 220),
    );
  }
}
