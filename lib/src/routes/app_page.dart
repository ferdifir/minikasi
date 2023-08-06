import 'package:get/get.dart';
import 'package:minikasi/src/modules/auth/register_page.dart';
import 'package:minikasi/src/modules/dashboard/dashboard_page.dart';
import 'package:minikasi/src/modules/buku_besar/buku_besar_page.dart';
import 'package:minikasi/src/modules/labarugi_page.dart/labarugi_page.dart';
import 'package:minikasi/src/modules/materi/materi_page.dart';
import 'package:minikasi/src/modules/neraca/neraca_page.dart';
import 'package:minikasi/src/modules/neraca_saldo/neraca_saldo_page.dart';
import 'package:minikasi/src/modules/report/report_page.dart';
import 'package:minikasi/src/modules/settings/code_account_page.dart';
import 'package:minikasi/src/modules/settings/company_setting_page.dart';
import 'package:minikasi/src/modules/settings/intial_balance_page.dart';
import 'package:minikasi/src/modules/settings/setting_page.dart';

import '../modules/auth/login_page.dart';
import '../modules/jurnal/add_jurnal_page.dart';
import '../modules/jurnal/jurnal_page.dart';
import '../modules/splash/splash_binding.dart';
import '../modules/splash/splash_screen.dart';
import 'app_routes.dart';

class AppPages {
  static const initial = AppRoutes.splash;

  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => LoginPage(),
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => DashboardPage(),
    ),
    GetPage(
      name: AppRoutes.journal,
      page: () => JurnalPage(),
    ),
    GetPage(
      name: AppRoutes.addJournal,
      page: () => const AddJurnalPage(),
    ),
    GetPage(
      name: AppRoutes.setting,
      page: () => SettingPage(),
    ),
    GetPage(
      name: AppRoutes.report,
      page: () => const ReportPage(),
    ),
    GetPage(
      name: AppRoutes.bukuBesar,
      page: () => BukuBesarPage(),
    ),
    GetPage(
      name: AppRoutes.neracaSaldo,
      page: () => NeracaSaldoPage(),
    ),
    GetPage(
      name: AppRoutes.labaRugi,
      page: () => LabaRugiPage(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => RegisterPage(),
    ),
    GetPage(
      name: AppRoutes.companySetting,
      page: () => CompanySettingPage(),
    ),
    GetPage(
      name: AppRoutes.codeAccountSetting,
      page: () => CodeAccountPage(),
    ),
    GetPage(
      name: AppRoutes.initialBalance,
      page: () => InitialBalancePage(),
    ),
    GetPage(
      name: AppRoutes.neraca,
      page: () => NeracaPage(),
    ),
    GetPage(
      name: AppRoutes.materi,
      page: () => MateriPage(),
    )
  ];
}
