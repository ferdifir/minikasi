import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minikasi/src/routes/app_routes.dart';
import 'package:showcaseview/showcaseview.dart';

import 'jurnal_controller.dart';

class JurnalPage extends StatelessWidget {
  JurnalPage({super.key});

  final controller = Get.put(JurnalController());
  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();
  final GlobalKey _three = GlobalKey();
  final GlobalKey _four = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAllNamed(AppRoutes.dashboard);
        return true;
      },
      child: ShowCaseWidget(
        builder: Builder(builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Jurnal Umum'),
              centerTitle: false,
              actions: [
                Showcase(
                  key: _one,
                  description: 'Anda dapat mengatur Periode jurnal umum disini',
                  child: IconButton(
                    onPressed: () {
                      Get.dialog(
                        dialogPeriode(),
                      );
                    },
                    icon: const Icon(Icons.calendar_today),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    ShowCaseWidget.of(context).startShowCase([
                      _one,
                      _two,
                      _three,
                      _four,
                    ]);
                  },
                  icon: const Icon(Icons.info),
                )
              ],
            ),
            body: Column(
              children: [
                headerTable(),
                bodyTable(),
              ],
            ),
            floatingActionButton: Showcase(
              key: _four,
              description: 'Klik tombol ini untuk menambahkan jurnal umum',
              child: FloatingActionButton(
                onPressed: () {
                  if (controller.periodeController.text == '') {
                    Get.snackbar(
                      'Peringatan',
                      'Periode belum diatur',
                      duration: const Duration(seconds: 2),
                    );
                    Future.delayed(
                      const Duration(seconds: 2),
                      () {
                        ShowCaseWidget.of(context).startShowCase([
                          _one,
                        ]);
                      },
                    );
                  } else {
                    Get.toNamed(AppRoutes.addJournal);
                  }
                },
                child: const Icon(Icons.add),
              ),
            ),
          );
        }),
      ),
    );
  }

  Dialog dialogPeriode() {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        margin: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Masukkan Periode',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller.periodeController,
              decoration: const InputDecoration(
                hintText: 'contoh: Januari 2020',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                if (controller.periodeController.text == '') {
                  Get.snackbar('Peringatan', 'Periode tidak boleh kosong');
                } else {
                  controller.updatePeriode(controller.periodeController.text);
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  bodyTable() {
    return Obx(
      () => Expanded(
        child: ListView.builder(
          itemCount: controller.jurnalUmum.length,
          itemBuilder: (context, index) {
            return Table(columnWidths: controller.columnWidth, children: [
              TableRow(
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                ),
                children: [
                  Container(
                    height: 30,
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.all(8),
                    child: Text(
                      controller.jurnalUmum[index].tanggal!,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Container(
                    height: 30,
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.all(8),
                    child: Text(
                      controller.jurnalUmum[index].keterangan!,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Container(),
                  Container(),
                ],
              )
            ]);
          },
        ),
      ),
    );
  }

  Table headerTable() {
    return Table(
      columnWidths: controller.columnWidth,
      border: TableBorder.symmetric(
        outside: const BorderSide(
          color: Colors.black,
          width: 1,
          style: BorderStyle.solid,
        ),
      ),
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: Colors.blue[300],
          ),
          children: [
            Showcase(
              key: _two,
              description: 'Kolom Tanggal jurnal umum',
              child: Container(
                height: 30,
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.all(8),
                child: const Text(
                  'Tanggal',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Showcase(
              key: _three,
              description: 'Kolom Keterangan jurnal umum',
              child: Container(
                height: 30,
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.all(8),
                child: const Text(
                  'Keterangan',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Container(),
            Container(),
          ],
        )
      ],
    );
  }
}
