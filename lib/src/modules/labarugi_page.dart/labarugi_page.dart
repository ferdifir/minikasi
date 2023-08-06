import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minikasi/src/utils/pdf_generator.dart';

import '../../utils/helper.dart';
import 'labarugi_controller.dart';

class LabaRugiPage extends StatelessWidget {
  LabaRugiPage({super.key});

  final controller = Get.put(LabaRugiController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Laporan Laba Rugi'),
            Obx(
              () => Text(
                'Periode: ${controller.periodeText.value}',
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () async {
              Get.dialog(
                const Center(
                  child: CircularProgressIndicator(),
                ),
              );
              await PDFGenerator.generateLabaRugi(
                controller.laporanLabaRugiForView(),
                controller.periodeText.value,
                controller.companyName.value,
              ).then((value) {
                Get.back();
                Get.snackbar('Berhasil',
                    'File tersimpan di dalam folder Laporan Minikasi');
              });
            },
            icon: const Icon(Icons.print),
          ),
        ],
      ),
      body: Obx(() {
        return controller.bukuBesar.isNotEmpty
            ? Container(
                margin: const EdgeInsets.all(10),
                child: buildLaporan(),
              )
            : const Center(
                child: Text('Tidak ada data'),
              );
      }),
    );
  }

  Column buildLaporan() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildText('Pendapatan Operasional'),
        const SizedBox(height: 10),
        buildListLabaRugi(
          controller.laporanLabaRugiForView()['pendapatanOperasional'],
        ),
        const SizedBox(height: 20),
        buildText('Pendapatan Non Operasional'),
        const SizedBox(height: 10),
        buildListLabaRugi(
          controller.laporanLabaRugiForView()['pendapatanNonOperasional'],
        ),
        const SizedBox(height: 20),
        buildText('Beban Operasional'),
        const SizedBox(height: 10),
        buildListLabaRugi(
          controller.laporanLabaRugiForView()['bebanOperasional'],
        ),
        SizedBox(
            height: controller
                        .laporanLabaRugiForView()['bebanNonOperasional']
                        .length ==
                    0
                ? 0
                : 20),
        controller.laporanLabaRugiForView()['bebanNonOperasional'].length == 0
            ? const Text('')
            : buildText('Beban Non Operasional'),
        const SizedBox(height: 10),
        controller.laporanLabaRugiForView()['bebanNonOperasional'].length == 0
            ? const Text('')
            : buildListLabaRugi(
                controller.laporanLabaRugiForView()['bebanNonOperasional'],
              ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildText('Laba/Rugi'),
            buildText(
              Helper.rupiahFormat(
                controller.laporanLabaRugiForView()['labaRugi'],
              ),
              fontWeight: FontWeight.normal,
            )
          ],
        ),
      ],
    );
  }

  Text buildText(
    String text, {
    TextAlign textAlign = TextAlign.start,
    FontWeight fontWeight = FontWeight.bold,
  }) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontWeight: fontWeight,
        fontSize: 18,
      ),
    );
  }

  buildListLabaRugi(
    dynamic data,
  ) {
    var totalSaldo = 0;
    for (var i = 0; i < data.length; i++) {
      totalSaldo += data[i]['saldo'] as int;
    }
    Map<int, TableColumnWidth> columnWidths = {
      0: const FlexColumnWidth(3),
      1: const FlexColumnWidth(2),
    };
    return ListView.builder(
      shrinkWrap: true,
      itemCount: data.length == 0 ? 1 : data.length + 1,
      itemBuilder: (context, index) {
        if (index == data.length) {
          return Table(
            columnWidths: columnWidths,
            children: [
              TableRow(
                children: [
                  TableCell(
                    child: buildText(
                      'Total',
                      fontWeight: FontWeight.normal,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  TableCell(
                    child: buildText(
                      Helper.rupiahFormat(totalSaldo),
                      fontWeight: FontWeight.normal,
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ],
          );
        } else {
          var nama = data[index]['nama'];
          var namaSub = nama.toString().substring(0, nama.indexOf('-'));
          return Table(
            columnWidths: columnWidths,
            children: [
              TableRow(children: [
                buildText(namaSub, fontWeight: FontWeight.normal),
                buildText(
                  Helper.rupiahFormat(data[index]['saldo']),
                  fontWeight: FontWeight.normal,
                ),
              ]),
            ],
          );
        }
      },
    );
  }

  TableRow tableRow(String title, String value) {
    return TableRow(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
      ),
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }
}
