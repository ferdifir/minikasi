import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/helper.dart';
import 'setting_controller.dart';

class InitialBalancePage extends StatelessWidget {
  InitialBalancePage({super.key});

  final controller = Get.put(SettingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saldo Awal'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Table(
            columnWidths: const <int, TableColumnWidth>{
              0: FlexColumnWidth(1.95),
              1: FlexColumnWidth(4),
              2: FlexColumnWidth(1.5),
              3: FlexColumnWidth(1.5),
              4: FlexColumnWidth(0.5),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                ),
                children: [
                  Helper.headerTable('Kode Akun'),
                  Helper.headerTable('Nama Akun'),
                  Helper.headerTable('Debit'),
                  Helper.headerTable('Kredit'),
                  Helper.headerTable('')
                ],
              ),
            ],
          ),
          Expanded(
            child: Obx(() => controller.initialBalanceListView.isEmpty
                ? const Center(
                    child: Text('Tidak ada data'),
                  )
                : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                    itemCount: controller.initialBalanceListView.length,
                    itemBuilder: (context, index) {
                      final initialBalanceList =
                          controller.initialBalanceListView[index];
                      return Table(
                        columnWidths: const <int, TableColumnWidth>{
                          0: FlexColumnWidth(1.95),
                          1: FlexColumnWidth(4),
                          2: FlexColumnWidth(1.5),
                          3: FlexColumnWidth(1.5),
                          4: FlexColumnWidth(0.5),
                        },
                        children: [
                          TableRow(
                            children: [
                              Helper.dataTable(
                                  initialBalanceList['accountCode'].toString()),
                              Helper.dataTable(
                                  initialBalanceList['accountName'].toString()),
                              Helper.dataTable(
                                  initialBalanceList['debit'].toString()),
                              Helper.dataTable(
                                  initialBalanceList['kredit'].toString()),
                              InkWell(
                                onTap: () {
                                  showEditBalance(initialBalanceList);
                                },
                                child: const Icon(
                                  Icons.edit,
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  )),
          ),
        ],
      ),
    );
  }

  void showEditBalance(Map<String,dynamic> initialBalanceList) {
    final kodeAkunController = TextEditingController(
      text: initialBalanceList['accountCode'].toString(),
    );
    final namaAkunController = TextEditingController(
      text: initialBalanceList['accountName'].toString(),
    );
    final debitController = TextEditingController(
      text: initialBalanceList['debit'].toString(),
    );
    final kreditController = TextEditingController(
      text: initialBalanceList['kredit'].toString(),
    );
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Edit Saldo Awal'),
        content: SizedBox(
          height: 260,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  readOnly: true,
                  controller: kodeAkunController,
                  decoration: const InputDecoration(
                    labelText: 'Kode Akun',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    prefixIcon: Icon(Icons.account_balance_wallet),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  readOnly: true,
                  controller: namaAkunController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Akun',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    prefixIcon: Icon(Icons.account_balance_wallet),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: debitController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Debit',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    prefixIcon: Icon(Icons.account_balance_wallet),
                  ),
                  onChanged: (value) {
                    if (value.isEmpty) {
                      debitController.text = '0';
                    }
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: kreditController,
                  decoration: const InputDecoration(
                    labelText: 'Kredit',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    prefixIcon: Icon(Icons.account_balance_wallet),
                  ),
                  onChanged: (value) {
                    if (value.isEmpty) {
                      kreditController.text = '0';
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              controller.editInitialBalance(
                int.parse(kodeAkunController.text),
                int.parse(debitController.text),
                int.parse(kreditController.text),
              );
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
