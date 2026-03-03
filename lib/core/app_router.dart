import 'package:chatwala/feature/auth/ui/pages/login_signup_page.dart';
import 'package:chatwala/feature/auth/ui/pages/login_page.dart';
import 'package:chatwala/feature/auth/ui/pages/signup_page.dart';
import 'package:chatwala/feature/auth/ui/pages/splash_screen.dart';
import 'package:chatwala/feature/chat/screens/chatscreen.dart';
import 'package:chatwala/feature/main_navigation.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static const String splash = '/';
  static const String loginSignup = '/loginSignup';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String chat = '/chat';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _buildRoute(const SplashScreen());
      case loginSignup:
        return _buildRoute(const LoginSignupPage());
      case login:
        return _buildRoute(const LoginPage());
      case signup:
        return _buildRoute(const SignupPage());
      case home:
        return _buildRoute(const MainNavigation());
      case chat:
        final args = settings.arguments as Map<String, dynamic>;
        return _buildRoute(
          ChatScreen(
            currentUserId: args['currentUserId'],
            receiverId: args['receiverId'],
            receiverName: args['receiverName'],
            receiverImage: args['receiverImage'],
          ),
        );
      default:
        return _buildRoute(const SplashScreen());
    }
  }

  static MaterialPageRoute _buildRoute(Widget page) {
    return MaterialPageRoute(builder: (context) => page);
  }
}
