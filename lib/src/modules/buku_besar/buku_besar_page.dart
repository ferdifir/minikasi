import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'buku_besar_controller.dart';

class BukuBesarPage extends StatelessWidget {
  BukuBesarPage({Key? key}) : super(key: key);

  final controller = Get.put(BukuBesarController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buku Besar'),
        actions: [
          Obx(() => Container(
                margin: const EdgeInsets.only(right: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Periode: '),
                    Text(
                      controller.periodeText.value,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ))
        ],
      ),
      body: Obx(
        () => controller.bukuBesar.isNotEmpty
            ? ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: controller.bukuBesarAndInitialBalance.length,
                itemBuilder: (context, index) {
                  String key = controller.bukuBesarAndInitialBalance.keys
                      .elementAt(index);
                  List<dynamic> transaksi =
                      controller.bukuBesarAndInitialBalance[key] ?? [];
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              key.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Divider(),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemCount: transaksi.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> item = transaksi[index];
                              return ListTile(
                                title: Text(item['keterangan']),
                                subtitle: Text(item['tanggal']),
                                trailing: Text(
                                  (item['debit'] > 0
                                      ? 'Debit: ${(item['debit'])}'
                                      : 'Kredit: ${item['kredit']}'),
                                  style: TextStyle(
                                    color: item['debit'] > 0
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            : const Center(
                child: Text(
                  'Tidak ada data',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
      ),
    );
  }
}
