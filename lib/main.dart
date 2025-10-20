import 'package:flutter/material.dart';
import 'package:movinity/pages/home.dart';
import 'package:movinity/pages/pin_put.dart';
import 'package:movinity/pages/signin_movinity.dart';
import 'package:movinity/pages/signup_movinity.dart';
import 'package:movinity/pages/whos_watching.dart';
import 'pages/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignInPage(),
    );
  }
}
