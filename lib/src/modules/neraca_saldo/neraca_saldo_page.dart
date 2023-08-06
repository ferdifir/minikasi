import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minikasi/src/utils/helper.dart';
import 'package:minikasi/src/utils/pdf_generator.dart';

import 'neraca_saldo_controller.dart';

class NeracaSaldoPage extends StatelessWidget {
  NeracaSaldoPage({super.key});

  final controller = Get.put(NeracaSaldoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Neraca Saldo'),
            Obx(() => Text(
                  'Periode: ${controller.periodeText.value}',
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                )),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              Get.dialog(
                const Center(
                  child: CircularProgressIndicator(),
                ),
              );
              PDFGenerator.generateNeracaSaldo(
                controller.getNeraca(),
                controller.periodeText.value,
                controller.companyName.value,
              ).then((value) {
                Get.back();
                Get.snackbar('Berhasil',
                    'File tersimpan di dalam folder Laporan Minikasi');
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Table(
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(3),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                ),
                children: [
                  Helper.headerTable('Kode Akun'),
                  Helper.headerTable('Nama Akun'),
                  Helper.headerTable('Saldo\nDebit'),
                  Helper.headerTable('Saldo\nKredit'),
                ],
              )
            ],
          ),
          Expanded(
            child: Obx(
              () => controller.bukuBesar.isNotEmpty
                  ? ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: controller.getNeraca().length,
                      itemBuilder: (context, index) {
                        var key = controller.getNeraca().keys.elementAt(index);
                        var value = controller.getNeraca()[key];
                        return Table(
                          columnWidths: const {
                            0: FlexColumnWidth(1),
                            1: FlexColumnWidth(3),
                            2: FlexColumnWidth(1),
                            3: FlexColumnWidth(1),
                          },
                          children: [
                            TableRow(
                              children: [
                                Helper.dataTable(
                                    key.toString().substring(0, 4)),
                                Helper.dataTable(key.toString().substring(7)),
                                Helper.dataTable(value['debit'].toString()),
                                Helper.dataTable(value['kredit'].toString()),
                              ],
                            )
                          ],
                        );
                      },
                    )
                  : const Center(
                      child: Text('Data Kosong'),
                    ),
            ),
          ),
          Obx(() => Table(
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(3),
                  2: FlexColumnWidth(1),
                  3: FlexColumnWidth(1),
                },
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                    ),
                    children: [
                      Helper.headerTable(''),
                      Helper.headerTable('Total'),
                      Helper.headerTable(
                          controller.totalDebit.value.toString()),
                      Helper.headerTable(
                          controller.totalKredit.value.toString()),
                    ],
                  )
                ],
              )),
        ],
      ),
    );
  }
}
