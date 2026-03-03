import 'package:chatapp/features/screens/chatscreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    print("Starting Firebase init...");
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase initialized successfully");
  } catch (e, stack) {
    print("Firebase init FAILED: $e");
    print("Stack: $stack");
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final query = Uri.base.queryParameters;
  final currentUserId = query['user'] ?? 'shahd1'; 
  final receiverId = currentUserId == 'shahd1' ? 'laila' : 'shahd1';
  final receiverName = currentUserId == 'shahd1' ? 'Laila' : 'Shahd1';

  runApp(MyApp(
    currentUserId: currentUserId,
    receiverId: receiverId,
    receiverName: receiverName,
  ));
}

class MyApp extends StatelessWidget {
  final String currentUserId;
  final String receiverId;
  final String receiverName;

  const MyApp({
    super.key,
    required this.currentUserId,
    required this.receiverId,
    required this.receiverName,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: ChatScreen(
        currentUserId: currentUserId,
        receiverId: receiverId,
        receiverName: receiverName,
        receiverImage: null,
      ),
    );
  }
}