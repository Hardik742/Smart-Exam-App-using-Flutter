import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mihir/ExamApp.dart';
import 'package:mihir/screens/SplashScreen.dart';
import 'package:mihir/screens/LoginScreen.dart';
import 'package:mihir/StartScreen.dart';
import 'package:mihir/screens/GettingStartedScreen.dart';
import 'package:mihir/screens/Register.dart';

import 'admin/UploadQuestionScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ExamApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
      routes: {
        LoginScreen.routeName: (ctx) => LoginScreen(),
        Register.routeName: (ctx) => Register(),
      },
    );
  }
}
