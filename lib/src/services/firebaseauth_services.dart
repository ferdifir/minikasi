import 'package:firebase_auth/firebase_auth.dart';
import 'package:minikasi/src/services/firebasedb_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constant.dart';
import '../utils/log.dart';

class FirebaseAuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDbServices _db = FirebaseDbServices();

  Future<String?> userLogin(String email, String password) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    late String? errorMessage = 'Error';
    try {
      var user = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      errorMessage = null;
      pref.setString(uidPrefKey, user.user!.uid);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
        Log.i('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
        Log.i('Wrong password provided for that user.');
      }
    }
    return errorMessage;
  }

  Future<String?> userRegister(
    String email,
    String password,
  ) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? errorMessage;
    try {
      var user = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      errorMessage = null;
      pref.setString(uidPrefKey, user.user!.uid);
      _db.addUser(user.user!.uid, email, password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
        Log.i('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
        Log.i('The account already exists for that email.');
      }
    } catch (e) {
      Log.i(e);
      errorMessage = e.toString();
    }
    return errorMessage;
  }

  Future<bool> isUserLoggedIn() async {
    final user = _auth.currentUser;
    return user != null;
  }

  Future<void> userLogout() async {
    await _auth.signOut();
  }
}
