import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:minikasi/app.dart';
import 'package:minikasi/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Minikasi());
}
