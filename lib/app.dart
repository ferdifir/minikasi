import 'package:flutter/material.dart';

import 'route/routes.dart';
import 'screen/splash_screen.dart';

class Minikasi extends StatelessWidget {
  const Minikasi({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Minikasi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: SplashScreen.routeName,
      routes: routes,
    );
  }
}
