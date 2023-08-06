import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/text_input.dart';
import 'setting_controller.dart';

class CompanySettingPage extends StatelessWidget {
  CompanySettingPage({super.key});

  final controller = Get.put(SettingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan Perusahaan'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Column(
                children: [
                  const SizedBox(height: 20),
                  TextInput(
                    txtController: controller.companyNameController,
                    label: 'Nama Perusahaan',
                    icon: Icons.location_city,
                  ),
                  const SizedBox(height: 20),
                  TextInput(
                    txtController: controller.companyOwnerController,
                    label: 'Nama Pemilik',
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 20),
                  TextInput(
                    txtController: controller.companyAddressController,
                    label: 'Alamat',
                    icon: Icons.location_on,
                  ),
                  const SizedBox(height: 20),
                  TextInput(
                    txtController: controller.companyPhoneController,
                    label: 'Telp',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),
                  TextInput(
                    txtController: controller.companyEmailController,
                    label: 'Email',
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ],
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  showAlertUpdateProfile(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 100,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Perbarui Data Perusahaan'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> showAlertUpdateProfile(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Perbarui Data Perusahaan'),
        content:
            const Text('Apakah anda yakin ingin memperbarui data perusahaan?'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              controller.updateCompanyProfile();
              Get.back();
            },
            child: const Text('Ya'),
          ),
        ],
      ),
    );
  }
}
