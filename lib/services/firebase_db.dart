import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minikasi/model/account_code.dart';
import 'package:minikasi/model/company_profile.dart';
import 'package:minikasi/model/initial_balance.dart';
import 'package:minikasi/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/jurnal_umum.dart';
import '../utils/log.dart';

class FirebaseDbServices {
  final _db = FirebaseFirestore.instance;

  Future<bool> checkUser(String email) async {
    final snapshot =
        await _db.collection('user').where('email', isEqualTo: email).get();
    return snapshot.docs.isNotEmpty;
  }

  Future<void> addUser(
    String uid,
    String name,
    String email,
    String password,
  ) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString(uidPrefKey, uid);
      await _db.collection('user').doc(uid).set({
        'name': name,
        'email': email,
        'password': password,
        'admin': false,
        'company': {
          'addressCompany': "",
          'emailCompany': "",
          'nameCompany': "",
          'ownerCompany': "",
          'phoneCompany': "",
        },
        'codeAccount': initialAccountCode,
        'initialBalance': initialBalance,
        'jurnalUmum': [],
      });
    } catch (e) {
      Log.i(e.toString(), tag: 'Adding User');
    }
  }

  Future<CompanyProfile?> getCompanyProfile() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final docId = pref.getString(uidPrefKey);
      final docRef = await _db.collection('user').doc(docId).get();
      final data = docRef.data();
      final companyProfile = data!['company'];
      return CompanyProfile.fromMap(companyProfile);
    } catch (e) {
      Log.i(e.toString(), tag: 'Get Company Profile');
      return null;
    }
  }

  Future<bool> updateCompanyProfile(
    String addressCompany,
    String emailCompany,
    String nameCompany,
    String ownerCompany,
    String phoneCompany,
  ) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final docId = pref.getString(uidPrefKey);
      await _db.collection('user').doc(docId).update({
        'company': {
          'addressCompany': addressCompany,
          'emailCompany': emailCompany,
          'nameCompany': nameCompany,
          'ownerCompany': ownerCompany,
          'phoneCompany': phoneCompany,
        }
      });
      return true;
    } catch (e) {
      Log.i(e.toString());
      return false;
    }
  }

  Future<bool> updateAccountCode(
    String accountName,
    int accountCode,
  ) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final docId = pref.getString(uidPrefKey);
      
      final docRef = _db.collection('user').doc(docId);
      final doc = await docRef.get();
      final accountCodeList =
          List<Map<String, dynamic>>.from(doc['codeAccount']);

      for (var i = 0; i < accountCodeList.length; i++) {
        if (accountCodeList[i]['accountCode'] == accountCode) {
          accountCodeList[i]['accountCode'] = accountCode;
          accountCodeList[i]['accountName'] = accountName;
          break;
        }
      }

      await docRef.update({
        'codeAccount': accountCodeList,
      });

      return true;
    } catch (e) {
      Log.i(e.toString());
      return false;
    }
  }

  addAccountCode(
    String accountName,
    int accountCode,
  ) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final docId = pref.getString(uidPrefKey);
      final docRef = _db.collection('user').doc(docId);
      final doc = await docRef.get();
      final accountCodeList =
          List<Map<String, dynamic>>.from(doc['codeAccount']);

      accountCodeList.add({
        'accountCode': accountCode,
        'accountName': accountName,
      });

      await docRef.update({
        'codeAccount': accountCodeList,
      });
    } catch (e) {
      Log.i(e.toString());
    }
  }

  deleteAccountCode(int accountCode) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final docId = pref.getString(uidPrefKey);
      final docRef = _db.collection('user').doc(docId);
      final doc = await docRef.get();
      final accountCodeList =
          List<Map<String, dynamic>>.from(doc['codeAccount']);

      for (var i = 0; i < accountCodeList.length; i++) {
        if (accountCodeList[i]['accountCode'] == accountCode) {
          accountCodeList.removeAt(i);
          break;
        }
      }

      await docRef.update({
        'codeAccount': accountCodeList,
      });
    } catch (e) {
      Log.i(e.toString());
    }
  }

  Stream<List<AccountCode>> getAccountCode(String uid) {
    return _db.collection('user').doc(uid).snapshots().map((snapshot) =>
        snapshot
            .data()!['codeAccount']
            .map<AccountCode>((e) => AccountCode.fromDoc(e))
            .toList());
  }

  Stream<List<InitialBalance>> getInitialBalance(String uid) {
    return _db.collection('user').doc(uid).snapshots().map((snapshot) {
      return snapshot
          .data()!['initialBalance']
          .map<InitialBalance>((e) => InitialBalance.fromDoc(e))
          .toList();
    });
  }

  Stream<List<JurnalUmum>> getJurnalUmum(String uid) {
    return _db.collection('user').doc(uid).snapshots().map((snapshot) {
      return snapshot
          .data()!['jurnalUmum']
          .map<JurnalUmum>((e) => JurnalUmum.fromDoc(e))
          .toList();
    });
  }

  Future<bool> updateInitialBalance(
    int accountCode,
    int kredit,
    int debit,
  ) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final docId = pref.getString(uidPrefKey);
      final docRef = _db.collection('user').doc(docId);
      final doc = await docRef.get();
      final initialBalanceList =
          List<Map<String, dynamic>>.from(doc['initialBalance']);

      for (var i = 0; i < initialBalanceList.length; i++) {
        if (initialBalanceList[i]['accountCode'] == accountCode) {
          initialBalanceList[i]['debit'] = debit;
          initialBalanceList[i]['kredit'] = kredit;
          break;
        }
      }

      await docRef.update({
        'initialBalance': initialBalanceList,
      });

      return true;
    } catch (e) {
      Log.i(e.toString());
      return false;
    }
  }

  addJurnalUmum(
    String date,
    int accountCode,
    String accountName,
    int kredit,
    int debit,
    String description,
  ) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final docId = pref.getString(uidPrefKey);
      final docRef = _db.collection('user').doc(docId);
      final doc = await docRef.get();
      final jurnalUmumList = List<Map<String, dynamic>>.from(doc['jurnalUmum']);

      jurnalUmumList.add({
        'date': date,
        'debit': debit,
        'kredit': kredit,
        'accountCode': accountCode,
        'accountName': accountName,
        'description': description,
      });

      await docRef.update({
        'jurnalUmum': jurnalUmumList,
      });
    } catch (e) {
      Log.i(e.toString());
    }
  }

  updateJurnalUmum(
    String date,
    int accountCode,
    String accountName,
    int kredit,
    int debit,
    String description,
  ) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final docId = pref.getString(uidPrefKey);
      final docRef = _db.collection('user').doc(docId);
      final doc = await docRef.get();
      final jurnalUmumList = List<Map<String, dynamic>>.from(doc['jurnalUmum']);

      for (var i = 0; i < jurnalUmumList.length; i++) {
        if (jurnalUmumList[i]['accountCode'] == accountCode) {
          jurnalUmumList[i]['date'] = date;
          jurnalUmumList[i]['debit'] = debit;
          jurnalUmumList[i]['kredit'] = kredit;
          jurnalUmumList[i]['accountCode'] = accountCode;
          jurnalUmumList[i]['accountName'] = accountName;
          jurnalUmumList[i]['description'] = description;
          break;
        }
      }

      await docRef.update({
        'jurnalUmum': jurnalUmumList,
      });
    } catch (e) {
      Log.i(e.toString());
    }
  }

  deleteJurnalUmum(int accountCode) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final docId = pref.getString(uidPrefKey);
      final docRef = _db.collection('user').doc(docId);
      final doc = await docRef.get();
      final jurnalUmumList = List<Map<String, dynamic>>.from(doc['jurnalUmum']);

      for (var i = 0; i < jurnalUmumList.length; i++) {
        if (jurnalUmumList[i]['accountCode'] == accountCode) {
          jurnalUmumList.removeAt(i);
          break;
        }
      }

      await docRef.update({
        'jurnalUmum': jurnalUmumList,
      });
    } catch (e) {
      Log.i(e.toString());
    }
  }

  // get first data of account code in return future
  Future<AccountCode> getFirstAccountCode() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final docId = pref.getString(uidPrefKey);
    final doc = await _db.collection('user').doc(docId).get();
    final accountCodeList = doc.data()!['codeAccount']
        .map<AccountCode>((e) => AccountCode.fromDoc(e))
        .toList();
    return accountCodeList.first;
  }

  // get list of jurnal umum by account code
  Stream<List<JurnalUmum>> getJurnalUmumByAccountCode(
      String uid, int accountCode) {
    return _db.collection('user').doc(uid).snapshots().map((snapshot) {
      return snapshot
          .data()!['jurnalUmum']
          .map<JurnalUmum>((e) => JurnalUmum.fromDoc(e))
          .where((element) => element.accountCode == accountCode)
          .toList();
    });
  }

  Stream<List<InitialBalance>> getInitialBalanceByAccountCode(
      String uid, int accountCode) {
    return _db.collection('user').doc(uid).snapshots().map((snapshot) {
      return snapshot
          .data()!['initialBalance']
          .map<InitialBalance>((e) => InitialBalance.fromDoc(e))
          .where((element) => element.accountCode == accountCode)
          .toList();
    });
  }

  Stream<List<InitialBalance>> getInitialBalanceByAccountName(
      String uid, String accountName) {
    return _db.collection('user').doc(uid).snapshots().map((snapshot) {
      return snapshot
          .data()!['initialBalance']
          .map<InitialBalance>((e) => InitialBalance.fromDoc(e))
          .where((element) => element.accountName == accountName)
          .toList();
    });
  }

  Stream<List<JurnalUmum>> getJurnalUmumByAccountName(
      String uid, String accountName) {
    return _db.collection('user').doc(uid).snapshots().map((snapshot) {
      return snapshot
          .data()!['jurnalUmum']
          .map<JurnalUmum>((e) => JurnalUmum.fromDoc(e))
          .where((element) => element.accountName == accountName)
          .toList();
    });
  }

  Stream<List<InitialBalance>> getInitialBalanceByDate(
      String uid, DateTime date) {
    return _db.collection('user').doc(uid).snapshots().map((snapshot) {
      return snapshot
          .data()!['initialBalance']
          .map<InitialBalance>((e) => InitialBalance.fromDoc(e))
          .where((element) => element.date == date)
          .toList();
    });
  }

}
