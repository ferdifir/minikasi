import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minikasi/src/models/account_code.dart';
import 'package:minikasi/src/models/initial_balance.dart';
import 'package:minikasi/src/services/firebasedb_services.dart';
import 'package:minikasi/src/utils/log.dart';

import '../../services/sharedpref_service.dart';
import '../../utils/constant.dart';

class SettingController extends GetxController {
  final companyNameController = TextEditingController();
  final companyAddressController = TextEditingController();
  final companyOwnerController = TextEditingController();
  final companyPhoneController = TextEditingController();
  final companyEmailController = TextEditingController();
  String selectedAccountType = 'Aset Lancar';
  final db = FirebaseDbServices();
  final SharedPrefService _sharedPrefService = Get.find();
  String get uid => _sharedPrefService.getString(uidPrefKey) ?? '';
  RxList<AccountCode> accountCodeList = RxList<AccountCode>();
  List<AccountCode> accCodeList = <AccountCode>[];
  List<InitialBalance> initialBalanceList = <InitialBalance>[];
  RxList<dynamic> initialBalanceListView =
      RxList<dynamic>();

  @override
  void onInit() {
    super.onInit();
    getCompanyProfile();
    getInitialBalance();
  }

  getInitialBalanceForView() {
    var tempList = [];
    for (var accountCode in accCodeList) {
      for (var initialBalance in initialBalanceList) {
        if (accountCode.code == initialBalance.kodeAkun) {
          tempList.add({
            'accountName': accountCode.name,
            'accountCode': accountCode.code,
            'accountType': accountCode.type,
            'debit': initialBalance.debit,
            'kredit': initialBalance.kredit,
          });
        }
      }
    }
    
    initialBalanceListView.value = tempList;
  }

  editInitialBalance(int code, int debit, int kredit) {
    db.updateInitialBalance(code, kredit, debit).then((value) {
      getInitialBalance();
      Get.back();
    });
  }

  addInitialBalance(int code, int debit, int kredit) {
    db.addInitialBalanceAccount(code, kredit, debit).then((value) {
      getInitialBalance();
    });
  }

  getInitialBalance() async {
    db.getAccountCode(uid).listen((event) {
      accountCodeList.value = event;
    });
    initialBalanceList = await db.getInitialBalanceList(uid);
    accCodeList = await db.getAccountCodeList(uid);
    getInitialBalanceForView();
  }

  editAccountCode(String name, int code, String type) {
    db
        .updateAccountCode(name, code, type)
        .then((value) => Get.back())
        .catchError((e) => Log.i(e));
  }

  addAccountCode(String name, int code, String type) {
    db.addAccountCode(name, code, type).then((value) => Get.back());
  }

  deleteAccountCode(int code) {
    db.deleteAccountCode(code).then((value) => Get.back());
  }

  void getCompanyProfile() {
    db.getCompanyProfile().then((value) {
      companyNameController.text = value!.nameCompany;
      companyAddressController.text = value.addressCompany;
      companyOwnerController.text = value.ownerCompany;
      companyPhoneController.text = value.phoneCompany;
      companyEmailController.text = value.emailCompany;
    });
  }

  updateCompanyProfile() {
    db.updateCompanyProfile(
      companyAddressController.text,
      companyEmailController.text,
      companyNameController.text,
      companyOwnerController.text,
      companyPhoneController.text,
    );
  }
}
