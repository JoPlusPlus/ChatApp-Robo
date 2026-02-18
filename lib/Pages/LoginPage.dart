import 'package:chatapp/Widgets/socialButton.dart';
import 'package:flutter/material.dart';

class Loginpage extends StatelessWidget {
  const Loginpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xff5532AB),
      body: Column(
        children: [

          /// Top Header
          Container(
            height: 220,
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
            color: Color(0xff5532AB),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// Back Button
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),

                const SizedBox(height: 5),

                /// Sign In Title
                const Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    
                  ),
                ),

                const SizedBox(height: 6),

                /// Subtitle
                const Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          /// Form Container
          Expanded(
            // upper right and left curves
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
            
                  /// Username
                  const SizedBox(height: 40,), 
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Username',
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                    ),
                  ),
            
                  const SizedBox(height: 15),
            
                  /// Password
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                    ),
                  ),
            
                  const SizedBox(height: 8),
            
                  /// Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ),
            
                  const SizedBox(height: 10),
            
                  /// Sign In Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text('Sign In'),
                    ),
                  ),
            
                  const SizedBox(height: 100),
            
                  /// Continue with Google
                  SocialButton(
                    text: 'Continue with Google',
                    icon: Icons.g_mobiledata,
                    onTap: () {},
                    iconSize: 40,
                  ),
            
                  const SizedBox(height: 10),
            
                  /// Continue with Facebook
                  SocialButton(
                    text: 'Continue with Facebook',
                    icon: Icons.facebook,
                    onTap: () {},
                    iconSize: 30,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }}