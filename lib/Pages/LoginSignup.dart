import 'package:flutter/material.dart';

class LoginSignup extends StatelessWidget {
  const LoginSignup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          /// Logo image
          SizedBox(height: 100,),
          SizedBox(
            width: 300,
            height: 200,
            child: Image.asset(
              'assets/Logo.jpg',
              width: 90,
            ),
          ),
                    
          const SizedBox(height: 10),

          /// SignIn/SignUp Container
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 30,
              ),
              decoration: const BoxDecoration(
                color: Color(0xff5532AB), 
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// Welcome Text
                  const Text(
                    'Welcome',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),

                  const SizedBox(height: 8),

                  /// Description
                  const Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit idvn evnienv einviev vneinve vev e',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// Buttons Row
                  Row(
                    children: [

                      /// Sign In Button 
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('Sign In', style: TextStyle(color: Colors.black,fontSize: 20),),
                        ),
                      ),

                      const SizedBox(width: 12),

                      /// Sign Up Button 
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('Sign Up', style: TextStyle(color: Colors.black,fontSize: 20),),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
