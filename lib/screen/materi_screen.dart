import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class MateriScreen extends StatefulWidget {
  static const routeName = '/materi';
  const MateriScreen({super.key});

  @override
  State<MateriScreen> createState() => _MateriScreenState();
}

class _MateriScreenState extends State<MateriScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Materi'),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: InAppWebView(
          initialFile: 'assets/materi.htm',
        ),
      ),
    );
  }
}
