import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCBFDZigInTT8_WzQcovkjFoPPHLr3Qe6k",                // Replace with your Web API Key
      authDomain: "quizapp.firebaseapp.com",
      projectId: "quizapp-30692",
      storageBucket: "quizapp.appspot.com",
      messagingSenderId: "689136306740",
      appId: "1:689136306740:web:85b300aba021e1878cd861",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quiz App',
      home: LoginPage(),
    );
  }
}
