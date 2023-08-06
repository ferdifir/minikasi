import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minikasi/src/utils/helper.dart';

import '../../utils/pdf_generator.dart';
import 'neraca_controller.dart';

class NeracaPage extends StatelessWidget {
  NeracaPage({super.key});

  final controller = Get.put(NeracaController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NeracaController>(
      init: NeracaController(),
      initState: (_) {},
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Neraca'),
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
                onPressed: () async {
                  Get.dialog(
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                  await PDFGenerator.generateNeraca(
                    controller.classfityAccount(),
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
          body: Container(
            width: double.infinity,
            margin: const EdgeInsets.all(10),
            child: Obx(
              () {
                var currentAsetList =
                    controller.classfityAccount()['Current Asset'];
                var fixedAsetList =
                    controller.classfityAccount()['Fixed Asset'];
                var shortTermLiabilityList =
                    controller.classfityAccount()['Short Term Liability'];
                var longTermLiabilityList =
                    controller.classfityAccount()['Long Term Liability'];
                var equityList = controller.classfityAccount()['Equity'];
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ASET',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Aset Lancar',
                        style: TextStyle(
                          fontSize: 18,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      buildListNeraca(currentAsetList),
                      const SizedBox(height: 10),
                      const Text(
                        'Aset Tetap',
                        style: TextStyle(
                          fontSize: 18,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      buildListNeraca(fixedAsetList),
                      buildTotalNeraca(
                        currentAsetList,
                        fixedAsetList,
                        'Aset',
                      ),
                      const Divider(
                        thickness: 2,
                        color: Colors.black,
                      ),
                      const Text(
                        'LIABILITAS',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Liabilitas Jangka Pendek',
                        style: TextStyle(
                          fontSize: 18,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      buildListNeraca(shortTermLiabilityList),
                      const SizedBox(height: 10),
                      const Text(
                        'Liabilitas Jangka Panjang',
                        style: TextStyle(
                          fontSize: 18,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      buildListNeraca(longTermLiabilityList),
                      buildTotalNeraca(
                        shortTermLiabilityList,
                        longTermLiabilityList,
                        'Liabilitas',
                      ),
                      const Divider(
                        thickness: 2,
                        color: Colors.black,
                      ),
                      const Text(
                        'EKUITAS',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      buildListNeraca(equityList, isEkuitas: true),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Table buildTotalNeraca(currentAsetList, fixedAsetList, String title) {
    return Table(
      children: [
        TableRow(
          children: [
            Container(
              padding: const EdgeInsets.only(
                left: 40,
                right: 10,
              ),
              child: Text(
                'Total $title',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                left: 80,
              ),
              child: Text(
                Helper.rupiahFormat(
                  totalSaldo(currentAsetList) + totalSaldo(fixedAsetList),
                ),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  ListView buildListNeraca(Map list, {bool isEkuitas = false}) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length + 1,
      itemBuilder: (context, index) {
        if (index == list.length) {
          return Table(
            children: [
              TableRow(children: [
                Container(
                  padding: const EdgeInsets.only(
                    left: 40,
                    right: 10,
                    top: 10,
                    bottom: 10,
                  ),
                  child: Text(
                    isEkuitas ? "Total Ekuitas" : "Total",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                          isEkuitas ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    left: 80,
                    top: 10,
                    bottom: 10,
                  ),
                  child: Text(
                    Helper.rupiahFormat(totalSaldo(list)),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: isEkuitas ? FontWeight.bold : null,
                    ),
                  ),
                ),
              ])
            ],
          );
        } else {
          return Table(
            children: [
              TableRow(children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    list.keys.elementAt(index).split('-')[1].trim(),
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    Helper.rupiahFormat(calculateSaldo(
                      list.values.elementAt(index)['debit'],
                      list.values.elementAt(index)['kredit'],
                    )),
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ])
            ],
          );
        }
      },
    );
  }

  totalSaldo(Map list) {
    var total = 0;
    for (var i = 0; i < list.length; i++) {
      total += calculateSaldo(
        list.values.elementAt(i)['debit'],
        list.values.elementAt(i)['kredit'],
      );
    }
    return total;
  }

  int calculateSaldo(int debit, int kredit) {
    var saldo = debit - kredit;
    return saldo;
  }
}
