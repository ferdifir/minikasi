import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:minikasi/screen/materi_screen.dart';
import 'package:minikasi/screen/report/report_screen.dart';
import 'package:minikasi/screen/setting/setting_screen.dart';
import 'package:minikasi/services/firebase_db.dart';
import 'package:minikasi/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widget/icon_menu.dart';
import 'about_screen.dart';
import 'journal/journal_screen.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/dashboard';
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final db = FirebaseDbServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          FutureBuilder(
            future: db.getCompanyProfile(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                String nameCompany = snapshot.data!.nameCompany == ''
                    ? 'Update Nama Perusahaan Terlebih dahulu'
                    : snapshot.data!.nameCompany;

                String addressCompany = snapshot.data!.addressCompany == ''
                    ? 'Update Alamat Perusahaan Terlebih dahulu'
                    : snapshot.data!.addressCompany;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      nameCompany,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      addressCompany,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
          const SizedBox(height: 30),
          MenuIcon(
            firstIcon: Icons.edit_note,
            firstTitle: 'Jurnal',
            firsOnTap: () =>
                Navigator.pushReplacementNamed(context, JournalScreen.routeName),
            secondIcon: Icons.calculate,
            secondTitle: 'Laporan',
            secondOnTap: () =>
                Navigator.pushNamed(context, ReportScreen.routeName),
          ),
          const SizedBox(height: 20),
          MenuIcon(
            firstIcon: Icons.note_alt,
            firstTitle: 'Materi',
            firsOnTap: () =>
                Navigator.pushNamed(context, MateriScreen.routeName),
            secondIcon: Icons.settings,
            secondTitle: 'Pengaturan',
            secondOnTap: () {
              Navigator.pushReplacementNamed(context, SettingScreen.routeName);
            },
          ),
          const SizedBox(height: 20),
          MenuIcon(
              firstIcon: Icons.question_mark,
              firstTitle: 'Petunjuk',
              secondIcon: Icons.info,
              secondTitle: 'Tentang',
              secondOnTap: () =>
                  Navigator.pushNamed(context, AboutScreen.routeName)),
        ],
      ),
    );
  }
}
