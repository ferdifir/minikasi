import 'package:get/get.dart';
import 'package:minikasi/src/services/firebasedb_services.dart';

import '../../services/sharedpref_service.dart';
import '../../utils/constant.dart';

class BukuBesarController extends GetxController {
  final firebasedbServices = FirebaseDbServices();
  final SharedPrefService _sharedPrefService = Get.find();
  String get uid => _sharedPrefService.getString(uidPrefKey) ?? '';
  List<Map<String, dynamic>> jurnalUmum = [];
  List<Map<String, dynamic>> initialBalance = [];
  final RxMap bukuBesar = RxMap();
  Map bukuBesarAndInitialBalance = {};
  final RxList accountCode = [].obs;
  final periodeText = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    jurnalUmum = await firebasedbServices.getListJurnalUmum(uid);
    initialBalance = await firebasedbServices.getListInitialBalance(uid);
    accountCode.value =
        await firebasedbServices.getAccountCodeForBukuBesar(uid);
    generateListBukuBesar();
    generateBukuBesarAndInitialBalance();
    getPeriode();
  }

  getPeriode() {
    firebasedbServices.getPeriode().then((event) {
      periodeText.value = event;
    });
  }

  generateBukuBesarAndInitialBalance() {
    var data3 = {};

    for (var account in initialBalance) {
      var accountCode = account['accountCode'];

      data3[accountCode] = [];

      data3[accountCode].add({
        'tanggal': '',
        'keterangan': 'Saldo Awal',
        'debit': account['debit'],
        'kredit': account['kredit']
      });

      if (bukuBesar.containsKey(accountCode)) {
        bukuBesar[accountCode].forEach((transaction) {
          data3[accountCode].add(transaction);
        });
      }
    }

    var data4 = getNameOfCode(data3);

    bukuBesarAndInitialBalance = data4;
    // bukuBesarAndInitialBalance.removeWhere((key, value) =>
    // value.fold(0, (sum, item) => sum + item['debit'] + item['kredit']) == 0);
    for (var key in bukuBesarAndInitialBalance.keys.toList()) {
      var entries = bukuBesarAndInitialBalance[key]!;
      var entriesToRemove = [];
      for (var i = 0; i < entries.length; i++) {
        if (entries[i]['debit'] == 0 && entries[i]['kredit'] == 0) {
          entriesToRemove.add(i);
        }
      }
      for (var i = entriesToRemove.length - 1; i >= 0; i--) {
        entries.removeAt(entriesToRemove[i]);
      }
      if (entries.isEmpty) {
        bukuBesarAndInitialBalance.remove(key);
      }
    }
  }

  Map<dynamic, dynamic> getNameOfCode(Map<dynamic, dynamic> data3) {
    var newData = {};
    var data1 = data3;
    var data2 = accountCode;
    for (var i = 0; i < data2.length; i++) {
      var kode = data2[i]['accountCode'];
      var nama = '$kode - ${data2[i]['accountName']}';
      newData[nama] = data1[kode];
    }
    return newData;
  }

  sortByDate() {
    for (String key in bukuBesarAndInitialBalance.keys) {
      bukuBesarAndInitialBalance[key].sort((a, b) {
        if (a["tanggal"] == "" && b["tanggal"] == "") {
          return 0;
        } else if (a["tanggal"] == "") {
          return -1;
        } else if (b["tanggal"] == "") {
          return 1;
        } else {
          return a["tanggal"].compareTo(b["tanggal"]) as int;
        }
      });
    }
  }

  generateListBukuBesar() {
    for (final transaksi in jurnalUmum) {
      for (final detail in transaksi['detailTransaksi']) {
        final kodeAkun = detail['kodeAkun'];
        final transaksiAkun = {
          'tanggal': transaksi['tanggal'],
          'keterangan': transaksi['keterangan'],
          'debit': detail['debit'],
          'kredit': detail['kredit']
        };
        if (bukuBesar.containsKey(kodeAkun)) {
          bukuBesar[kodeAkun]!.add(transaksiAkun);
        } else {
          bukuBesar[kodeAkun] = [transaksiAkun];
        }
      }
    }
  }
}
