import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minikasi/src/utils/constant.dart';
import 'package:minikasi/src/utils/helper.dart';

import 'setting_controller.dart';

class CodeAccountPage extends StatelessWidget {
  CodeAccountPage({super.key});

  final controller = Get.put(SettingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan Akun'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              showEditDialog(null);
            },
            icon: const Icon(Icons.add_box_outlined),
          )
        ],
      ),
      body: Column(
        children: [
          Table(
            columnWidths: const <int, TableColumnWidth>{
              0: FlexColumnWidth(1.5),
              1: FlexColumnWidth(4),
              2: FlexColumnWidth(0.5),
              3: FlexColumnWidth(0.5),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                ),
                children: [
                  Helper.headerTable('Kode Akun'),
                  Helper.headerTable('Nama Akun'),
                  Helper.headerTable(''),
                  Helper.headerTable(''),
                ],
              ),
            ],
          ),
          Expanded(
              child: Obx(
            () => controller.accountCodeList.isNotEmpty
                ? ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: controller.accountCodeList.length,
                    itemBuilder: (context, index) {
                      return Table(
                        columnWidths: const <int, TableColumnWidth>{
                          0: FlexColumnWidth(1.5),
                          1: FlexColumnWidth(4),
                          2: FlexColumnWidth(0.5),
                          3: FlexColumnWidth(0.5),
                        },
                        children: [
                          TableRow(
                            children: [
                              Helper.dataTable(controller
                                  .accountCodeList[index].code
                                  .toString()),
                              Helper.dataTable(
                                  controller.accountCodeList[index].name),
                              InkWell(
                                onTap: () {
                                  showEditDialog(index);
                                },
                                child: const Icon(
                                  Icons.edit,
                                  size: 16,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  showDeleteDialog(
                                      controller.accountCodeList[index].code);
                                },
                                child: const Icon(
                                  Icons.delete,
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  )
                : const Center(
                    child: Text('Tidak ada data'),
                  ),
          ))
        ],
      ),
    );
  }

  void showEditDialog(int? index) {
    final accountCodeController = TextEditingController();
    final accountNameController = TextEditingController();
    Get.generalDialog(
      pageBuilder: (context, a, b) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.all(16),
                      child: Text(
                        index != null ? 'Edit Nama Akun' : 'Tambah Akun',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(8),
                      child: TextField(
                        controller: accountCodeController
                          ..text = index != null
                              ? controller.accountCodeList[index].code
                                  .toString()
                              : '',
                        keyboardType: TextInputType.number,
                        readOnly: index != null ? true : false,
                        decoration: const InputDecoration(
                          labelText: 'Kode Akun',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          prefixIcon: Icon(Icons.account_balance_wallet),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(8),
                      child: TextField(
                        controller: accountNameController
                          ..text = index != null
                              ? controller.accountCodeList[index].name
                              : '',
                        decoration: const InputDecoration(
                          labelText: 'Nama Akun',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          prefixIcon: Icon(Icons.account_balance_wallet),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(8),
                      // if index is null, it means that the user is adding a new account
                      // disable the dropdown button if the user is editing an account
                      child: DropdownButtonFormField(
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Tipe Akun',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          prefixIcon: Icon(Icons.account_balance_wallet),
                        ),
                        value: index != null
                            ? controller.accountCodeList[index].type
                            : controller.selectedAccountType,
                        items: accountTypeList.map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(
                              e,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            controller.selectedAccountType = value;
                          }
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (index != null) {
                          controller.editAccountCode(
                            accountNameController.text,
                            int.parse(accountCodeController.text),
                            controller.accountCodeList[index].type,
                          );
                        } else {
                          controller.addAccountCode(
                            accountNameController.text,
                            int.parse(accountCodeController.text),
                            controller.selectedAccountType,
                          );
                          controller.addInitialBalance(
                            int.parse(accountCodeController.text),
                            0,
                            0,
                          );
                        }
                      },
                      child: const Text('Simpan'),
                    ),
                    const SizedBox(height: 16)
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showDeleteDialog(int accountCode) {
    Get.dialog(AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: const Text('Hapus Akun'),
      content: const Text('Apakah anda yakin ingin menghapus akun ini?'),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text('Tidak'),
        ),
        TextButton(
          onPressed: () {
            controller.deleteAccountCode(accountCode);
          },
          child: const Text('Ya'),
        ),
      ],
    ));
  }
}
