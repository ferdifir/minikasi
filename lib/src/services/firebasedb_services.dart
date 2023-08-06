import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minikasi/src/models/jurnal_umum.dart';
import 'package:minikasi/src/utils/log.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/account_code.dart';
import '../models/company_profile.dart';
import '../models/initial_balance.dart';
import '../utils/constant.dart';

class FirebaseDbServices {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addUser(
    String uid,
    String email,
    String password,
  ) async {
    try {
      await _db.collection('account').doc(uid).set({
        'codeAccount': initialAccountCode,
      });

      await _db.collection('initial_balance').doc(uid).set({
        'initialBalance': initialBalance,
      });

      await _db.collection('jurnal_umum').doc(uid).set({
        'jurnalUmum': [],
      });

      await _db.collection('periode').doc(uid).set({
        'periode': '',
      });

      DocumentReference accountRef = _db.collection('account').doc(uid);
      DocumentReference initialBalanceRef =
          _db.collection('initial_balance').doc(uid);
      DocumentReference jurnalUmumRef = _db.collection('jurnal_umum').doc(uid);
      DocumentReference periodeRef = _db.collection('periode').doc(uid);

      await _db.collection('user').doc(uid).set({
        'email': email,
        'password': password,
        'admin': false,
        'createdAt': DateTime.now(),
        'company': {
          'addressCompany': "",
          'emailCompany': "",
          'nameCompany': "",
          'ownerCompany': "",
          'phoneCompany': "",
        },
        'codeAccount': accountRef,
        'initialBalance': initialBalanceRef,
        'jurnalUmum': jurnalUmumRef,
        'periode': periodeRef,
      });
    } catch (e) {
      Log.i(e.toString(), tag: 'Adding User');
    }
  }

  isAdmin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString(uidPrefKey) ?? '';
    final docRef = _db.collection('user').doc(uid);
    final doc = await docRef.get();
    return doc['admin'];
  }

  getPeriode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString(uidPrefKey) ?? '';
    final docRef = _db.collection('periode').doc(uid);
    final doc = await docRef.get();
    return doc['periode'];
  }

  updatePeriode(String periode) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final uid = pref.getString(uidPrefKey) ?? '';
    final docRef = _db.collection('periode').doc(uid);
    await docRef.update({'periode': periode});
  }

  Stream<List<AccountCode>> getAccountCode(String uid) {
    return _db.collection('account').doc(uid).snapshots().map((snapshot) {
      return snapshot
          .data()!['codeAccount']
          .map<AccountCode>((e) => AccountCode.fromDoc(e))
          .toList();
    });
  }

  Future<List<AccountCode>> getAccountCodeList(String uid) async {
    final docRef = _db.collection('account').doc(uid);
    final doc = await docRef.get();
    final accountCodeList = List<Map<String, dynamic>>.from(doc['codeAccount']);
    return accountCodeList
        .map<AccountCode>((e) => AccountCode.fromDoc(e))
        .toList();
  }

  getAccountCodeForBukuBesar(String uid) async {
    final docRef = _db.collection('account').doc(uid);
    final doc = await docRef.get();
    final accountCodeList = List<Map<String, dynamic>>.from(doc['codeAccount']);
    return accountCodeList;
  }

  Future<List<InitialBalance>> getInitialBalanceList(String uid) async {
    final docRef = _db.collection('initial_balance').doc(uid);
    final doc = await docRef.get();
    final initialBalanceList =
        List<Map<String, dynamic>>.from(doc['initialBalance']);
    //print(initialBalanceList);
    return initialBalanceList
        .map<InitialBalance>((e) => InitialBalance.fromDoc(e))
        .toList();
  }

  Stream<List<JurnalUmum>> getJurnalUmum(String uid) {
    return _db.collection('jurnal_umum').doc(uid).snapshots().map((snapshot) =>
        snapshot
            .data()!['jurnalUmum']
            .map<JurnalUmum>((e) => JurnalUmum.fromDoc(e))
            .toList());
  }

  getListJurnalUmum(String uid) async {
    final docRef = _db.collection('jurnal_umum').doc(uid);
    final doc = await docRef.get();
    final jurnalList = List<Map<String, dynamic>>.from(doc['jurnalUmum']);
    return jurnalList;
  }

  getListInitialBalance(String uid) async {
    final docRef = _db.collection('initial_balance').doc(uid);
    final doc = await docRef.get();
    final initialBalanceList =
        List<Map<String, dynamic>>.from(doc['initialBalance']);
    return initialBalanceList;
  }

  saveJurnal(String uid, Map<String, dynamic> data) async {
    try {
      final docRef = _db.collection('jurnal_umum').doc(uid);
      final doc = await docRef.get();
      final jurnalList = List<Map<String, dynamic>>.from(doc['jurnalUmum']);

      jurnalList.add(data);

      await docRef.update({'jurnalUmum': jurnalList});
      return true;
    } on FirebaseException catch (e) {
      Log.i(e);
      return false;
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

  Future<void> updateAccountCode(
    String accountName,
    int accountCode,
    String accountType,
  ) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final docId = pref.getString(uidPrefKey);

      final docRef = _db.collection('account').doc(docId);
      final doc = await docRef.get();
      final accountCodeList =
          List<Map<String, dynamic>>.from(doc['codeAccount']);

      for (var i = 0; i < accountCodeList.length; i++) {
        if (accountCodeList[i]['accountCode'] == accountCode) {
          accountCodeList[i]['accountCode'] = accountCode;
          accountCodeList[i]['accountName'] = accountName;
          accountCodeList[i]['accountType'] = accountType;
          break;
        }
      }

      await docRef.update({
        'codeAccount': accountCodeList,
      });
    } on FirebaseException catch (e) {
      Log.i(e.toString());
    }
  }
  // Future<void> updateAccountCode(
  //   String accountName,
  //   int accountCode,
  //   String accountType,
  // ) async {
  //   try {
  //     SharedPreferences pref = await SharedPreferences.getInstance();
  //     final docId = pref.getString(uidPrefKey);

  //     final docRef = _db.collection('account').doc(docId);
  //     final docSnapshot = await docRef.get();

  //     // Get the current list of account codes
  //     final List<dynamic> codeAccount = docSnapshot.get('codeAccount');
  //     final List<Map<String, dynamic>> updatedCodeAccount = [];

  //     // Iterate through the list of account codes and update the matching account code
  //     for (var account in codeAccount) {
  //       if (account['accountCode'] == accountCode) {
  //         updatedCodeAccount.add({
  //           'accountName': accountName,
  //           'accountCode': accountCode,
  //           'accountType': accountType,
  //         });
  //       } else {
  //         updatedCodeAccount.add(account);
  //       }
  //     }

  //     // Update the document with the new list of account codes
  //     await docRef.update({
  //       'codeAccount': updatedCodeAccount,
  //     });
  //   } on FirebaseException catch (e) {
  //     Log.i(e.toString());
  //   }
  // }

  addAccountCode(
    String accountName,
    int accountCode,
    String accountType,
  ) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final docId = pref.getString(uidPrefKey);
      final docRef = _db.collection('account').doc(docId);
      final doc = await docRef.get();
      final accountCodeList =
          List<Map<String, dynamic>>.from(doc['codeAccount']);

      accountCodeList.add({
        'accountCode': accountCode,
        'accountName': accountName,
        'accountType': accountType,
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
      final docRef = _db.collection('account').doc(docId);
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

  Stream<List<InitialBalance>> getInitialBalance(String uid) {
    return _db
        .collection('initial_balance')
        .doc(uid)
        .snapshots()
        .map((snapshot) {
      return snapshot
          .data()!['initialBalance']
          .map<InitialBalance>((e) => InitialBalance.fromDoc(e))
          .toList();
    });
  }

  addInitialBalanceAccount(
    int accountCode,
    int kredit,
    int debit,
  ) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final docId = pref.getString(uidPrefKey);
      final docRef = _db.collection('initial_balance').doc(docId);
      final doc = await docRef.get();
      final initialBalanceList =
          List<Map<String, dynamic>>.from(doc['initialBalance']);

      initialBalanceList.add({
        'accountCode': accountCode,
        'debit': debit,
        'kredit': kredit,
      });

      await docRef.update({
        'initialBalance': initialBalanceList,
      });
    } catch (e) {
      Log.i(e.toString());
    }
  }

  Future<bool> updateInitialBalance(
    int accountCode,
    int kredit,
    int debit,
  ) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final docId = pref.getString(uidPrefKey);
      final docRef = _db.collection('initial_balance').doc(docId);
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

  Future<bool> addMateriUrl(String materiUrl) async {
    try {
      final docRef = _db.collection('materi').doc('url_materi');
      await docRef.update({
        'url': materiUrl,
      });
      return true;
    } catch (e) {
      Log.i(e.toString());
      return false;
    }
  }

  Future<String> getPDFUrl() async {
    final docRef = _db.collection('materi').doc('url_materi');
    final doc = await docRef.get();
    return doc['url'];
  }
}
