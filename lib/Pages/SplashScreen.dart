import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override

    void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/loginSignup');
    });
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [

          /// Top-Right Blue Curve
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 140,
              height: 140,
              decoration: const BoxDecoration(
                color: Color(0xff5532AB),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(180),
                ),
              ),
            ),
          ),

          /// Bottom-Left Blue Curve
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: 160,
              height: 160,
              decoration: const BoxDecoration(
                color: Color(0xff5532AB),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(180),
                ),
              ),
            ),
          ),

          /// Center Content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                /// Logo Image
                SizedBox(
                  width: 300,
                  height: 300,
                  child: Image.asset(
                    'assets/Logo.jpg',
                     
                  ),
                ),

                const SizedBox(height: 20),

                /// App Name
                const Text(
                  'chatApp',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
