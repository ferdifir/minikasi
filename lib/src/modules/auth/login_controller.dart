import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minikasi/src/routes/app_routes.dart';
import 'package:minikasi/src/services/firebaseauth_services.dart';
import 'package:minikasi/src/services/firebasedb_services.dart';

import '../../services/sharedpref_service.dart';
import '../../utils/constant.dart';

class LoginController extends GetxController {
  RxBool hidePassword = true.obs;
  final emailTxtController = TextEditingController();
  final passwordTxtController = TextEditingController();
  final auth = FirebaseAuthServices();
  final db = FirebaseDbServices();

  final SharedPrefService _sharedPrefService = Get.find();

  saveUid(String uid) {
    _sharedPrefService.setString(uidPrefKey, uid);
  }

  userLogin() async {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
    final email = emailTxtController.text;
    final password = passwordTxtController.text;
    final result = await auth.userLogin(email, password);

    if (result == null) {
      Get.back();
      Get.offAllNamed(AppRoutes.dashboard);
    } else {
      Get.back();
      Get.snackbar('Error', result);
    }
  }

  userRegister() async {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
    final email = emailTxtController.text;
    final password = passwordTxtController.text;
    final result = await auth.userRegister(email, password);

    if (result == null) {
      Get.back();
      Get.offAllNamed(AppRoutes.dashboard);
    } else {
      Get.back();
      Get.snackbar('Error', result);
    }
  } 
}
