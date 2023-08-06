import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minikasi/src/routes/app_routes.dart';
import 'package:minikasi/src/services/firebaseauth_services.dart';

import 'company_setting_page.dart';

class SettingPage extends StatelessWidget {
  SettingPage({super.key});

  final auth = Get.put(FirebaseAuthServices());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offNamed(AppRoutes.dashboard);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pengaturan'),
        ),
        body: ListView(
          children: [
            ListTile(
              title: const Text('Pengaturan Perusahaan'),
              leading: const Icon(Icons.location_city),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => Get.to(() => CompanySettingPage()),
            ),
            ListTile(
              title: const Text('Pengaturan Akun'),
              leading: const Icon(Icons.account_circle),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => Get.toNamed(AppRoutes.codeAccountSetting),
            ),
            ListTile(
              title: const Text('Saldo Awal'),
              leading: const Icon(Icons.account_balance),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => Get.toNamed(AppRoutes.initialBalance),
            ),
            ListTile(
              title: const Text('Keluar'),
              leading: const Icon(Icons.exit_to_app),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    title: const Text('Keluar'),
                    content: const Text('Apakah anda yakin ingin keluar?'),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text('Tidak'),
                      ),
                      TextButton(
                        onPressed: () {
                          auth.userLogout().then(
                              (value) => Get.offAllNamed(AppRoutes.login));
                        },
                        child: const Text('Ya'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
