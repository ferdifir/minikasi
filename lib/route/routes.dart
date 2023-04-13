import 'package:flutter/material.dart';
import 'package:minikasi/screen/about_screen.dart';
import 'package:minikasi/screen/journal/add_journal_screen.dart';
import 'package:minikasi/screen/dashboard_screen.dart';
import 'package:minikasi/screen/journal/journal_screen.dart';
import 'package:minikasi/screen/login_screen.dart';
import 'package:minikasi/screen/materi_screen.dart';
import 'package:minikasi/screen/register_screen.dart';
import 'package:minikasi/screen/report/buku_besar_screen.dart';
import 'package:minikasi/screen/report/report_screen.dart';
import 'package:minikasi/screen/setting/balance_screen.dart';
import 'package:minikasi/screen/setting/company_setting_screen.dart';
import 'package:minikasi/screen/setting/setting_screen.dart';
import 'package:minikasi/screen/splash_screen.dart';
import 'package:minikasi/screen/setting/codeaccount_setting_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => const SplashScreen(),
  DashboardScreen.routeName: (context) => DashboardScreen(),
  JournalScreen.routeName: (context) => const JournalScreen(),
  AddJournalScreen.routeName: (context) => AddJournalScreen(),
  ReportScreen.routeName: (context) => const ReportScreen(),
  SettingScreen.routeName: (context) => SettingScreen(),
  AboutScreen.routeName: (context) => const AboutScreen(),
  MateriScreen.routeName: (context) => const MateriScreen(),
  LoginScreen.routeName: (context) => const LoginScreen(),
  RegisterScreen.routeName: (context) => const RegisterScreen(),
  CompanySettingScreen.routeName: (context) => const CompanySettingScreen(),
  CodeAccountSettingScreen.routeName: (context) => const CodeAccountSettingScreen(),
  BalanceScreen.routeName: (context) => const BalanceScreen(),
  BukuBesarScreen.routeName: (context) => const BukuBesarScreen(),
};