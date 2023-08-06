import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minikasi/src/services/firebasedb_services.dart';
import 'package:minikasi/src/services/firebasestorage_services.dart';

class MateriController extends GetxController {
  final pdfFile = ''.obs;
  final selectedPdf = ''.obs;
  final _firebaseStorage = FirebaseStorageServices();
  final _firebaseDb = FirebaseDbServices();
  final isAdmin = false.obs;

  @override
  void onInit() async {
    super.onInit();
    getMateriUrl();
    isAdmin.value = await _firebaseDb.isAdmin();
  }

  getMateriUrl() async {
    await _firebaseDb.getPDFUrl().then((value) {
      pdfFile.value = value;
      update();
    });
  }

  pickMateri() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['htm', 'html'],
    );
    if (result != null) {
      File file = File(result.files.single.path!);
      selectedPdf.value = file.path;
      update();
    } else {
      Get.snackbar('Error', 'Pilih file PDF terlebih dahulu');
    }
  }

  uploaPDFFileToFirebaseStorage() async {
    if (selectedPdf.value.isEmpty) {
      Get.snackbar('Error', 'Pilih file PDF terlebih dahulu');
    } else {
      Get.dialog(const Center(child: CircularProgressIndicator()));
      File file = File(selectedPdf.value);
      await _firebaseStorage
          .uploadPDFFile(file)
          .then((value) => _firebaseDb.addMateriUrl(value).then((value) {
                if (value) {
                  Get.back();
                  Get.snackbar('Sukses', 'File berhasil diupload');
                  update();
                } else {
                  Get.back();
                  Get.snackbar('Error', 'File gagal diupload');
                }
              }));
    }
  }
}
