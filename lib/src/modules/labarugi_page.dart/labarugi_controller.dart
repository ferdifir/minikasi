import 'package:get/get.dart';

import '../../services/firebasedb_services.dart';
import '../../services/sharedpref_service.dart';
import '../../utils/constant.dart';

class LabaRugiController extends GetxController {
  final firebasedbServices = FirebaseDbServices();
  final SharedPrefService _sharedPrefService = Get.find();
  String get uid => _sharedPrefService.getString(uidPrefKey) ?? '';
  List<Map<String, dynamic>> jurnalUmum = [];
  List<Map<String, dynamic>> initialBalance = [];
  final RxMap bukuBesar = RxMap();
  Map bukuBesarAndInitialBalance = {};
  final RxList accountCode = [].obs;
  RxInt totalDebit = 0.obs;
  RxInt totalKredit = 0.obs;
  final periodeText = ''.obs;
  final companyName = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    jurnalUmum = await firebasedbServices.getListJurnalUmum(uid);
    initialBalance = await firebasedbServices.getListInitialBalance(uid);
    accountCode.value =
        await firebasedbServices.getAccountCodeForBukuBesar(uid);
    generateListBukuBesar();
    generateBukuBesarAndInitialBalance();
    calculateTotalDebitKredit();
    getPeriode();
    getCompanyName();
  }

  getCompanyName() {
    firebasedbServices.getCompanyProfile().then((event) {
      companyName.value = event!.nameCompany;
    });
  }

  getPeriode() {
    firebasedbServices.getPeriode().then((event) {
      periodeText.value = event;
    });
  }

  calculateTotalDebitKredit() {
    getNeraca().values.forEach((account) {
      totalDebit += account['debit'];
      totalKredit += account['kredit'];
    });
  }

  getNeraca() {
    var data4 = {};

    bukuBesarAndInitialBalance.forEach((accountCode, transactions) {
      var totalDebit = 0;
      var totalKredit = 0;

      transactions.forEach((transaction) {
        totalDebit += transaction['debit'] as int;
        totalKredit += transaction['kredit'] as int;
      });

      data4[accountCode] = {'debit': totalDebit, 'kredit': totalKredit};
    });
    return data4;
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

  laporanLabaRugiForView() {
    var accountData = generateListToClassifyAcount();
    var pendapatanOperasional = [];
    var bebanOperasional = [];
    var bebanNonOperasional = [];
    var pendapatanNonOperasional = [];
    var labaRugi = 0;

    accountData.forEach((key, value) {
      if (key.contains('Pendapatan Operasional')) {
        pendapatanOperasional.add({
          'nama': key,
          'saldo': value['kredit']
        });
        labaRugi += value['kredit'] as int;
      } else if (key.contains('Beban Operasional')) {
        bebanOperasional.add({
          'nama': key,
          'saldo': value['debit'],
        });
        labaRugi -= value['debit'] as int;
      } else if (key.contains('Pendapatan Non Operasional')) {
        pendapatanNonOperasional.add({
          'nama': key,
          'saldo': value['kredit']
        });
        labaRugi += value['kredit'] as int;
      } else if (key.contains('Beban Non Operasional')) {
        bebanNonOperasional.add({
          'nama': key,
          'saldo': value['debit'],
        });
        labaRugi -= value['debit'] as int;
      }
    });

    return {
      'pendapatanOperasional': pendapatanOperasional,
      'bebanOperasional': bebanOperasional,
      'pendapatanNonOperasional': pendapatanNonOperasional,
      'bebanNonOperasional': bebanNonOperasional,
      'labaRugi': labaRugi
    };
  }

  generateListToClassifyAcount() {
    var data2 = accountCode;
    var data1 = getNeraca();
    var data3 = {};

    for (var i = 0; i < data2.length; i++) {
      var accountCode = data2[i]['accountCode'];
      var accountName = data2[i]['accountName'];
      var accountType = data2[i]['accountType'];

      var debit = data1['$accountCode - $accountName']['debit'];
      var kredit = data1['$accountCode - $accountName']['kredit'];

      data3['$accountName - $accountType'] = {
        'debit': debit,
        'kredit': kredit
      };
    }

    return data3;
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
