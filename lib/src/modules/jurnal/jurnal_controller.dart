import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minikasi/src/models/account_code.dart';
import 'package:minikasi/src/models/jurnal_umum.dart';
import 'package:minikasi/src/utils/constant.dart';

import '../../services/firebasedb_services.dart';
import '../../services/sharedpref_service.dart';

class JurnalController extends GetxController {
  Map<int, TableColumnWidth> columnWidth = const <int, TableColumnWidth>{
    0: FixedColumnWidth(100),
    1: FlexColumnWidth(),
    2: IntrinsicColumnWidth(),
    3: IntrinsicColumnWidth(),
  };

  // text controller
  late List<TextEditingController> akunControllers;
  late List<TextEditingController> debitControllers;
  late List<TextEditingController> kreditControllers;
  late List<String> selectedAkun;
  final TextEditingController tanggalController = TextEditingController();
  final TextEditingController keteranganController = TextEditingController();
  final TextEditingController periodeController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final firebaseDbServices = FirebaseDbServices();
  final RxList<AccountCode> accountCode = RxList<AccountCode>();
  final RxList<JurnalUmum> jurnalUmum = RxList<JurnalUmum>();

  // initial detail transaksi
  List<Map<String, dynamic>> detailTransaksi = [
    {'kodeAkun': '', 'debit': 0, 'kredit': 0},
    {'kodeAkun': '', 'debit': 0, 'kredit': 0},
  ];

  final SharedPrefService _sharedPrefService = Get.find();

  String get uid => _sharedPrefService.getString(uidPrefKey) ?? '';

  @override
  void onInit() {
    super.onInit();
    generateTextController();
    getAccountCode();
    getJurnalUmum();
    getPeriode();
  }

  getPeriode() {
    firebaseDbServices.getPeriode().then((event) {
      periodeController.text = event;
    });
  }

  updatePeriode(String periode) {
    firebaseDbServices.updatePeriode(periode).then((value) {
      periodeController.text = periode;
      Get.back();
    });
  }

  getJurnalUmum() {
    firebaseDbServices.getJurnalUmum(uid).listen((event) {
      jurnalUmum.assignAll(event);
    });
  }

  getAccountCode() {
    firebaseDbServices.getAccountCode(uid).listen((event) {
      accountCode.assignAll(event);
    });
  }

  void generateTextController() {
    selectedAkun =
        List.generate(detailTransaksi.length, (index) => '1101 - Kas');
    akunControllers = List.generate(
      detailTransaksi.length,
      (index) => TextEditingController(text: '1101 - Kas'),
    );
    debitControllers = List.generate(
      detailTransaksi.length,
      (index) => TextEditingController(text: '0'),
    );
    kreditControllers = List.generate(
      detailTransaksi.length,
      (index) => TextEditingController(text: '0'),
    );
  }

  void addDetailTransaksi() {
    detailTransaksi.add({'kodeAkun': '', 'debit': 0, 'kredit': 0});
    selectedAkun.add('1101 - Kas');
    akunControllers.add(TextEditingController());
    debitControllers.add(TextEditingController(text: '0'));
    kreditControllers.add(TextEditingController(text: '0'));
    update();
  }

  void removeDetailTransaksi(int index) {
    detailTransaksi.removeAt(index);
    akunControllers.removeAt(index);
    debitControllers.removeAt(index);
    kreditControllers.removeAt(index);
    update();
  }

  updateDetailTransaksi(int index, dynamic value, String type) {
    detailTransaksi[index][type] = value;
    update();
  }

  void saveJurnal() async {
    bool isValid = true;

    for (var detail in detailTransaksi) {
      if (detail['kodeAkun'] == '') {
        Get.snackbar('Gagal', 'Pilih akun terlebih dahulu');
        isValid = false;
        break;
      }
      if (detail['debit'].toString().isEmpty && detail['kredit'].toString().isEmpty) {
        Get.snackbar('Gagal', 'Saldo tidak boleh kosong');
        isValid = false;
      }
      if ((detail['debit'] == 0) ^ (detail['kredit'] == 0)) {
        isValid = true;
      } else {
        Get.snackbar('Gagal', 'Saldo tidak boleh kosong');
        isValid = false;
      }
    }
    
    if (isValid) {
      final Map<String, dynamic> data = {
        'tanggal': tanggalController.text,
        'keterangan': keteranganController.text,
        'detailTransaksi': detailTransaksi,
      };
      final result = await firebaseDbServices.saveJurnal(uid, data);
      if (result) {
        tanggalController.clear();
        keteranganController.clear();
        detailTransaksi = [
          {'kodeAkun': '', 'debit': 0, 'kredit': 0},
          {'kodeAkun': '', 'debit': 0, 'kredit': 0},
        ];
        generateTextController();
        Get.snackbar('Sukses', 'Berhasil menyimpan jurnal');
        update();
      } else {
        Get.snackbar('Gagal', 'Gagal menyimpan jurnal');
      }
    }
  }
}
