import 'dart:async';
import 'package:flutter/material.dart';
import 'package:minikasi/screen/dashboard_screen.dart';
import 'package:minikasi/screen/login_screen.dart';
import 'package:minikasi/services/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash';

  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;
  final auth = FirebaseAuthServices();

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
      });
    });

    Timer(const Duration(seconds: 3), () {
      setState(() {
        _opacity = 0.0;
      });
      if (_opacity == 0.0) {
        auth.isUserLoggedIn().then((value) {
          if (value) {
            Navigator.pushReplacementNamed(context, DashboardScreen.routeName);
          } else {
            Navigator.pushReplacementNamed(context, LoginScreen.routeName);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: _opacity,
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/logo.png'),
                const SizedBox(height: 20),
                const Text(
                  'Minikasi',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
