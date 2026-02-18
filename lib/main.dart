import 'package:chatapp/Pages/LoginSignup.dart';
import 'package:chatapp/Pages/SplashScreen.dart';
import 'Pages/LoginPage.dart';
import 'Pages/SignupPage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
      '/': (context) => const SplashScreen(),
      '/loginSignup': (context) => const LoginSignup(),
      '/login': (context) => const Loginpage(),
      '/signup': (context) => const SignupPage(),
},

    );
  }
}

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
    );
  }
}
