import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minikasi/src/modules/splash/splash_binding.dart';
import 'package:minikasi/src/modules/splash/splash_screen.dart';
import 'package:minikasi/src/routes/app_page.dart';

class Minikasi extends StatelessWidget {
  const Minikasi({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Minikasi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
      initialBinding: SplashBinding(),
      getPages: AppPages.routes,
      defaultTransition: Transition.circularReveal,
    );
  }
}
