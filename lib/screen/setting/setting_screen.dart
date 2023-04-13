import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:minikasi/screen/dashboard_screen.dart';
import 'package:minikasi/screen/login_screen.dart';
import 'package:minikasi/screen/setting/company_setting_screen.dart';
import 'package:minikasi/screen/setting/codeaccount_setting_screen.dart';
import 'package:minikasi/services/firebase_auth.dart';
import 'package:minikasi/services/firebase_db.dart';

import '../../widget/list_menu.dart';
import 'balance_screen.dart';

class SettingScreen extends StatelessWidget {
  static const routeName = '/setting';
  SettingScreen({super.key});
  final FirebaseDbServices db = FirebaseDbServices();
  final FirebaseAuthServices auth = FirebaseAuthServices();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, DashboardScreen.routeName);
        return false;
      },
      child: Scaffold(
        body: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              const SizedBox(height: 50),
              Text(
                'Pengaturan',
                style: Theme.of(context).textTheme.headline2,
              ),
              const SizedBox(height: 10),
              Container(
                height: 1,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                color: Colors.grey,
              ),
              ListMenu(
                title: 'Pengaturan Perusahaan',
                onTap: () {
                  Navigator.pushNamed(context, CompanySettingScreen.routeName);
                },
              ),
              ListMenu(
                title: 'Pengaturan Kode Akun',
                onTap: () {
                  Navigator.pushNamed(
                      context, CodeAccountSettingScreen.routeName);
                },
              ),
              ListMenu(
                title: 'Saldo Awal',
                onTap: () {
                  Navigator.pushNamed(context, BalanceScreen.routeName);
                },
              ),
              ListMenu(
                title: 'Keluar',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Keluar'),
                        content: const Text('Apakah anda yakin ingin keluar?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Tidak'),
                          ),
                          TextButton(
                            onPressed: () async {
                              await auth
                                  .userLogout()
                                  .then((value) =>
                                      Navigator.pushReplacementNamed(
                                          context, LoginScreen.routeName))
                                  .onError((error, stackTrace) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(error.toString()),
                                    ));
                                  });
                            },
                            child: const Text('Ya'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
