import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:food_app/auth/login_page.dart';
import 'package:food_app/screens/user_navigation.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth for authentication

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const DoEatApp());
}
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}

class DoEatApp extends StatelessWidget {
  const DoEatApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DoEat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FirebaseAuth.instance.currentUser != null
          ? const LoginPage() // Navigate to HomePage if user is logged in
          : UserNavigation(), // Navigate to LoginPage if user is not logged in
    );
  }
}
