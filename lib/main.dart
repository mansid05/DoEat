import 'package:firebase_core/firebase_core.dart';
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

  runApp(const DoEatApp());
}

class DoEatApp extends StatelessWidget {
  const DoEatApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DoEat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            // Check if user is logged in
            if (snapshot.hasData) {
              return const UserNavigation(); // Redirect to UserNavigation if user is logged in
            } else {
              return const LoginPage(); // Redirect to LoginPage if user is not logged in
            }
          } else {
            // Show a loading indicator while checking authentication state
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
