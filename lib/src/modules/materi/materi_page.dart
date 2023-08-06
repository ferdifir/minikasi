//import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:minikasi/src/modules/materi/materi_controller.dart';
import 'package:minikasi/src/routes/app_routes.dart';

import 'upload_materi_page.dart';

class MateriPage extends StatelessWidget {
  MateriPage({super.key});

  final controller = Get.put(MateriController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Materi'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_outlined),
            onPressed: () {
              if (controller.isAdmin.value) {
                Get.to(() => UploadMateriPage());
              } else {
                Get.snackbar('Error', 'Anda tidak memiliki akses');
              }
            },
          ),
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Obx(
          () => controller.pdfFile.value != ''
              ? InAppWebView(
                  initialUrlRequest: URLRequest(
                    url: Uri.parse(controller.pdfFile.value),
                  ),
                  onLoadStart: (controller, url) {
                    Get.dialog(
                      loadingDialog(),
                    );
                  },
                  onLoadStop: (controller, url) {
                    Get.back();
                  },
                  onLoadError: (controller, url, code, message) {
                    Get.dialog(AlertDialog(
                      icon: const Icon(Icons.warning),
                      title: const Text('Error'),
                      content: Text(message),
                      actions: [
                        TextButton(
                          onPressed: () => Get.offNamed(AppRoutes.dashboard),
                          child: const Text('Kembali'),
                        )
                      ],
                    ));
                  },
                )
              : loadingDialog(),
        ),
      ),
    );
  }

  Dialog loadingDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 40,
              width: 40,
              child: CircularProgressIndicator(),
            ),
            const SizedBox(height: 20),
            const Text(
              'Please wait while we load your content',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
