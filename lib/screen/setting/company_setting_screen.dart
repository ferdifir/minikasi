import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:minikasi/widget/text_input.dart';

import '../../model/company_profile.dart';
import '../../services/firebase_db.dart';

class CompanySettingScreen extends StatefulWidget {
  static const routeName = 'company_settings';
  const CompanySettingScreen({super.key});

  @override
  State<CompanySettingScreen> createState() => _CompanySettingScreenState();
}

class _CompanySettingScreenState extends State<CompanySettingScreen> {
  final db = FirebaseDbServices();
  final companyNameController = TextEditingController();
  final companyOwnerController = TextEditingController();
  final companyAddressController = TextEditingController();
  final companyPhoneController = TextEditingController();
  final companyEmailController = TextEditingController();

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
              FutureBuilder(
                future: db.getCompanyProfile(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    companyNameController.text = snapshot.data!.nameCompany;
                    companyOwnerController.text = snapshot.data!.ownerCompany;
                    companyAddressController.text =
                        snapshot.data!.addressCompany;
                    companyPhoneController.text = snapshot.data!.phoneCompany;
                    companyEmailController.text = snapshot.data!.emailCompany;
                  } else {
                    companyNameController.text = 'Loading...';
                    companyOwnerController.text = 'Loading...';
                    companyAddressController.text = 'Loading...';
                    companyPhoneController.text = 'Loading...';
                    companyEmailController.text = 'Loading...';
                  }
                  return Column(
                    children: [
                      const SizedBox(height: 20),
                      TextInput(
                        txtController: companyNameController,
                        label: 'Nama Perusahaan',
                        icon: Icons.location_city,
                      ),
                      const SizedBox(height: 20),
                      TextInput(
                        txtController: companyOwnerController,
                        label: 'Nama Pemilik',
                        icon: Icons.person,
                      ),
                      const SizedBox(height: 20),
                      TextInput(
                        txtController: companyAddressController,
                        label: 'Alamat',
                        icon: Icons.location_on,
                      ),
                      const SizedBox(height: 20),
                      TextInput(
                        txtController: companyPhoneController,
                        label: 'Telp',
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 20),
                      TextInput(
                        txtController: companyEmailController,
                        label: 'Email',
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ],
                  );
                },
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
        title: const Text('Perbarui Data Perusahaan'),
        content:
            const Text('Apakah anda yakin ingin memperbarui data perusahaan?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              db
                  .updateCompanyProfile(
                    companyAddressController.text,
                    companyEmailController.text,
                    companyNameController.text,
                    companyOwnerController.text,
                    companyPhoneController.text,
                  )
                  .then((value) => Navigator.of(context).pop());
            },
            child: const Text('Ya'),
          ),
        ],
      ),
    );
  }
}
