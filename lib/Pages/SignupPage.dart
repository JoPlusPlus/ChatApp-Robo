import 'package:chatapp/Widgets/inputField.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xff5532AB),iconTheme: IconThemeData(color: Colors.white),),
      backgroundColor: Colors.white,
      body: Stack(
        children: [

          /// Background Blue Color
          Container(
            decoration: const BoxDecoration(
              color: Color(0xff5532AB),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(60),
                bottomRight: Radius.circular(60),
              ),
            ),
          ),

          
          Column(
            children: [

              /// Signup Title
              Column(
                children: const [
                  Icon(Icons.chat, size: 60, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
          
              const SizedBox(height: 40),
          
              
              Expanded(
                // Upper right and left corners rounded
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 30,
                    ),
                    color: Colors.white,

                    /// ===== Email/Password =====
                    child: Column(
                      
                      children: [
                        SizedBox(height: 60,),
                        /// Email
                        Inputfield(hintText: 'Email Address'),
                            
                        const SizedBox(height: 15),
                            
                        /// Password
                        Inputfield(hintText: 'Password', isPassword: true),
                            
                        const SizedBox(height: 15),
                            
                        /// Confirm Password
                        Inputfield(hintText: 'Confirm Password', isPassword: true),
                            
                        const SizedBox(height: 25),
                            
                        /// Signup Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff5532AB),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: const Text('Create Account'),
                          ),
                        ),
                            
                        const SizedBox(height: 15),
                            
                        /// Already have account
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Already have an account?', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(context, '/login');
                              },
                              child: const Text('Sign In', style: TextStyle(color: Color(0xff5532AB),fontSize: 18),),
                            ),
                          ],
                        ),
                            
                        const Spacer(),
                            
                        /// Google and Facebook Icons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.g_mobiledata, size: 32),
                            SizedBox(width: 20),
                            Icon(Icons.facebook, size: 28),
                            SizedBox(width: 20),
                          ],
                        ),
                            
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

