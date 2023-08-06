import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import 'arus_kas_controller.dart';

class ArusKasPage extends StatelessWidget {
  ArusKasPage({super.key});

  final controller = Get.put(ArusKasController());

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}