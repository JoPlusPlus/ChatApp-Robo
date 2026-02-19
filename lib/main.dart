import 'package:chatapp/Pages/LoginSignup.dart';
import 'package:chatapp/Pages/SplashScreen.dart';
import 'package:chatapp/Pages/main_navigation.dart';
import 'Pages/LoginPage.dart';
import 'Pages/SignupPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          shadowColor: Colors.transparent,
          scrolledUnderElevation: 0.0,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xffeeeff8), Color(0xfff3f4f9)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: const SplashScreen(),
        ),
        '/loginSignup': (context) => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xffeeeff8), Color(0xfff3f4f9)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: const LoginSignup(),
        ),
        '/login': (context) => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xffeeeff8), Color(0xfff3f4f9)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: const LoginPage(),
        ),
        '/signup': (context) => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xffeeeff8), Color(0xfff3f4f9)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: const SignupPage(),
        ),
        '/home': (context) => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xffeeeff8), Color(0xfff3f4f9)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: const MainNavigation(),
        ),
      },
    );
  }
}
