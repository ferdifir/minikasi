import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:minikasi/app.dart';
import 'package:minikasi/firebase_options.dart';

import 'src/services/sharedpref_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() async {
    final sharedPrefService = SharedPrefService();
    await sharedPrefService.init();
    return sharedPrefService;
  });
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Minikasi());
}
