import 'package:get/get.dart';
import 'package:connectivity/connectivity.dart';

import '../../services/firebasedb_services.dart';
import '../../services/sharedpref_service.dart';
import '../../utils/constant.dart';

class DashboardController extends GetxController {
  final db = FirebaseDbServices();
  RxString companyName = ''.obs;
  RxString companyAddress = ''.obs;
  RxInt totalJurnal = 0.obs;
  final SharedPrefService _sharedPrefService = Get.find();
  String get uid => _sharedPrefService.getString(uidPrefKey) ?? '';

  @override
  void onInit() {
    super.onInit();
    db.getCompanyProfile().then((value) {
      if (value != null) {
        companyName.value = value.nameCompany;
        companyAddress.value = value.addressCompany;
        if (value.addressCompany == '' || value.nameCompany == '') {
          if (value.addressCompany == '') {
            companyAddress.value = 'Alamat Perusahaan';
          }
          if (value.nameCompany == '') {
            companyName.value = 'Nama Perusahaan';
          }
        }
      } else {
        companyName.value = 'Nama Perusahaan';
        companyAddress.value = 'Alamat Perusahaan';
      }
    });
    db.getJurnalUmum(uid).listen((value) {
      totalJurnal.value = value.length;
    });
  }

  Future<bool> checkInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }
    return true;
  }
}
