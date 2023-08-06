import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan'),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          ListTile(
            onTap: () => Get.toNamed(AppRoutes.bukuBesar),
            title: const Text('Buku Besar'),
            leading: const Icon(Icons.book),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            onTap: () => Get.toNamed(AppRoutes.neracaSaldo),
            title: const Text('Neraca Saldo'),
            leading: const Icon(Icons.account_balance_wallet),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            onTap: () => Get.toNamed(AppRoutes.labaRugi),
            title: const Text('Laba Rugi'),
            leading: const Icon(Icons.attach_money),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            onTap: () => Get.toNamed(AppRoutes.neraca),
            title: const Text('Neraca'),
            leading: const Icon(Icons.account_balance),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          // ListTile(
          //   onTap: () => Get.toNamed(AppRoutes.arusKas),
          //   title: const Text('Arus Kas'),
          //   leading: const Icon(Icons.account_balance),
          //   trailing: const Icon(Icons.arrow_forward_ios),
          // ),
        ],
      ),
    );
  }
}