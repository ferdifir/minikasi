import 'package:flutter/material.dart';

class Helper {
  static String? isValidEmail(String email) {
    final regex = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$');
    if (regex.hasMatch(email)) {
      return null;
    } else {
      return 'Silahkan masukkan email yang valid';
    }
  }

  static String? isValidPassword(String password) {
    if (password.length >= 6) {
      return null;
    } else {
      return 'Password harus lebih dari 6 karakter';
    }
  }

  static Container headerTable(String text) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  static Container dataTable(String text) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Text(text),
    );
  }
}