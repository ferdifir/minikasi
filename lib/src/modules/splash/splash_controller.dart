import 'package:get/get.dart';
import 'package:minikasi/src/routes/app_routes.dart';
import 'package:minikasi/src/services/firebaseauth_services.dart';

class SplashController extends GetxController {

  final auth = FirebaseAuthServices();

  @override
  void onInit() {
    super.onInit();
    Future.delayed(
      const Duration(seconds: 2),
      () => checkUserLogin(),
    );
  }

  checkUserLogin() async {
    bool isLogin = await auth.isUserLoggedIn();
    if (isLogin) {
      Get.offAllNamed(AppRoutes.dashboard);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }
}