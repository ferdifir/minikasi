import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:minikasi/screen/report/buku_besar_screen.dart';

import '../../widget/list_menu.dart';

class ReportScreen extends StatelessWidget {
  static const routeName = '/report';
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            const SizedBox(height: 50),
            Text(
              'LAPORAN',
              style: Theme.of(context).textTheme.headline2,
            ),
            const SizedBox(height: 10),
            Container(
              height: 1,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              color: Colors.grey,
            ),
            ListMenu(
              title: 'Buku Besar',
              onTap: () {
                Navigator.pushReplacementNamed(context, BukuBesarScreen.routeName);
              },
            ),
            ListMenu(title: 'Neraca Saldo'),
            ListMenu(title: 'Laba Rugi'),
            ListMenu(title: 'Perubahan Ekuitas'),
            ListMenu(title: 'Laporan Posisi Keuangan / Neraca'),
            ListMenu(title: 'Arus Kas'),
          ],
        ),
      ),
    );
  }
}
