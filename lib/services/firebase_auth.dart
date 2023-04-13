import 'package:firebase_auth/firebase_auth.dart';
import 'package:minikasi/utils/constant.dart';
import 'package:minikasi/utils/log.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseAuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>> userLogin(String email, String password) async {
    bool result = false;
    String? errorMessage;
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ).then((value) {
        pref.setString(uidPrefKey, value.user!.uid);
        print(value.user!.uid);
      });
      result = true;
      errorMessage = null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      }
      result = false;
    }
    return {
      "isSuccess": result,
      "message": errorMessage,
    };
  }

  Future<UserCredential?> userRegister(String email, String password) async {
    late UserCredential? user;
    try {
      user = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Log.i('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Log.i('The account already exists for that email.');
      }
      user = null;
    } catch (e) {
      Log.i(e);
      user = null;
    }
    return user;
  }

  Future<bool> isUserLoggedIn() async {
    final user = _auth.currentUser;
    return user != null;
  }

  Future<void> userLogout() async {
    await _auth.signOut();
  }
}
