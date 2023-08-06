import 'dart:io';

import 'package:flutter/material.dart';
//import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
//import 'package:url_launcher/url_launcher.dart';
//import 'package:open_file/open_file.dart';

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

  static String rupiahFormat(int value) {
    // only using built in dart methods
    final formatter = NumberFormat.decimalPattern('id');
    return 'Rp. ${formatter.format(value)}';
  }

  static Container headerTable(String text) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  static Container dataTable(String text) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
        ),
      ),
    );
  }

  // static Future openFile(File file) async {
  //   final url = file.path;

  //   //await OpenFile.open(url);
  //   await launchUrl(Uri.parse(url));
  // }

}
