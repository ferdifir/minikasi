import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minikasi/src/routes/app_routes.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../common/menu_icon.dart';
import 'dashboard_controller.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({super.key});

  final controller = Get.put(DashboardController());
  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();
  final GlobalKey _three = GlobalKey();
  final GlobalKey _four = GlobalKey();
  final GlobalKey _five = GlobalKey();
  final GlobalKey _six = GlobalKey();
  final GlobalKey _seven = GlobalKey();
  final GlobalKey _eight = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ShowCaseWidget(
        builder: Builder(builder: (context) {
          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 40),
                Showcase(
                  key: _one,
                  description: 'Ini adalah nama perusahaan anda\n'
                      'Anda dapat mengubahnya di menu pengaturan',
                  child: Obx(() => Text(
                        controller.companyName.value == ''
                            ? 'Loading...'
                            : controller.companyName.value,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline4,
                      )),
                ),
                Showcase(
                  key: _two,
                  description: 'Ini adalah alamat perusahaan anda\n'
                      'Anda dapat mengubahnya di menu pengaturan',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 20,
                      ),
                      Obx(() => Text(
                            controller.companyAddress.value == ''
                                ? 'Loading...'
                                : controller.companyAddress.value,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyText1,
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                MenuIcon(
                  firstIcon: 'assets/jurnal.png',
                  firstTitle: 'Jurnal',
                  firsOnTap: () async {
                    var inet = await controller.checkInternet();
                    if (inet) {
                      Get.toNamed(AppRoutes.journal);
                    } else {
                      showNoInetDialog();
                    }
                  },
                  firstKey: _three,
                  firstDescription: 'Ini adalah menu jurnal\n'
                      'Anda dapat melihat jurnal anda disini\n'
                      'dan juga menambahkan jurnal baru disini',
                  secondIcon: 'assets/laporan.png',
                  secondTitle: 'Laporan',
                  secondOnTap: () async {
                    var inet = await controller.checkInternet();
                    if (inet) {
                      if (controller.totalJurnal.value == 0) {
                        Get.snackbar(
                          'Perhatian',
                          'Anda belum memiliki jurnal',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      } else {
                        Get.toNamed(AppRoutes.report);
                      }
                    } else {
                      showNoInetDialog();
                    }
                  },
                  secondKey: _four,
                  secondDescription: 'Ini adalah menu laporan\n'
                      'Anda dapat melihat laporan anda disini\n'
                      'dan juga mencetak laporan anda disini',
                ),
                const SizedBox(height: 20),
                MenuIcon(
                  firstIcon: 'assets/materi.png',
                  firstTitle: 'Materi',
                  firsOnTap: () async {
                    var inet = await controller.checkInternet();
                    if (inet) {
                      Get.toNamed(AppRoutes.materi);
                    } else {
                      showNoInetDialog();
                    }
                  },
                  firstKey: _five,
                  firstDescription: 'Ini adalah menu materi\n'
                      'Anda dapat melihat materi anda disini',
                  secondIcon: 'assets/pengaturan.png',
                  secondTitle: 'Pengaturan',
                  secondOnTap: () async {
                    var inet = await controller.checkInternet();
                    if (inet) {
                      Get.toNamed(AppRoutes.setting);
                    } else {
                      showNoInetDialog();
                    }
                  },
                  secondKey: _six,
                  secondDescription: 'Ini adalah menu pengaturan\n'
                      'Anda dapat mengubah pengaturan anda disini',
                ),
                const SizedBox(height: 20),
                MenuIcon(
                  firstIcon: 'assets/petunjuk.png',
                  firstTitle: 'Petunjuk',
                  firsOnTap: () {
                    ShowCaseWidget.of(context).startShowCase([
                      _one,
                      _two,
                      _three,
                      _four,
                      _five,
                      _six,
                      _seven,
                      _eight,
                    ]);
                  },
                  firstKey: _seven,
                  firstDescription: 'Ini adalah menu petunjuk\n'
                      'Anda dapat melihat petunjuk penggunaan aplikasi disini',
                  secondIcon: 'assets/tentang.png',
                  secondTitle: 'Tentang',
                  secondOnTap: () {
                    showAboutDialog(
                      anchorPoint: const Offset(0.5, 0.5),
                      context: context,
                      applicationName: 'Minikasi',
                      applicationVersion: '1.0.0',
                      applicationIcon: Image.asset(
                        'assets/logo.png',
                        width: 50,
                        height: 50,
                      ),
                      children: [
                        const Text(
                          'Minikasi adalah aplikasi yang bisa memudahkan anda dalam hal perhitungan jurnal umum, neraca, laporan keuangan.',
                        ),
                      ],
                    );
                  },
                  secondKey: _eight,
                  secondDescription: 'Ini adalah menu tentang\n'
                      'Anda dapat melihat informasi tentang aplikasi disini',
                )
              ],
            ),
          );
        }),
      ),
    );
  }

  void showNoInetDialog() {
    Get.dialog(
      AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        title: const Text('No Internet Connection'),
        content:
            const Text('Please check your internet connection and try again.'),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}
