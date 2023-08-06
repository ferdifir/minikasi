import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'materi_controller.dart';
import 'materi_page.dart';

class UploadMateriPage extends StatelessWidget {
  UploadMateriPage({super.key});

  final controller = Get.put(MateriController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.off(() => MateriPage());
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Upload Materi'),
          actions: [
            IconButton(
              icon: const Icon(Icons.upload_file),
              onPressed: () {
                controller.pickMateri();
              }, // controller.pickPDFFile(),
            ),
          ],
        ),
        body: Column(children: [
          const SizedBox(height: 20),
          const Text('Pilih file PDF', style: TextStyle(fontSize: 20)),
          const SizedBox(height: 20),
          Obx(
            () => Expanded(
              child: controller.selectedPdf.value.isNotEmpty
                  ? SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Selected File: ${controller.selectedPdf.value}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 20),
                      ),
                    )
                  : Center(
                      child: IconButton(
                        iconSize: 200,
                        onPressed: () {
                          controller.pickMateri();
                        },
                        icon: const Icon(Icons.upload_file),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              controller.uploaPDFFileToFirebaseStorage();
            },
            child: const Text('Upload'),
          ),
          const SizedBox(height: 20),
        ]),
      ),
    );
  }
}
