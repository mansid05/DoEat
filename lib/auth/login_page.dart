import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart'; // Make sure to include firebase_core
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:food_app/Admin/admin_navigation.dart';
import 'package:food_app/auth/signup_page.dart'; // Replace with your actual import path
import 'package:food_app/screens/privacy_policy_page.dart'; // Replace with your actual import path
import 'package:food_app/screens/three_fragment_page.dart';

import '../Admin/admin_home_page.dart'; // Replace with your actual import path

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    messaging.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked!');
    });
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _emailOrNumberError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LOGIN', style: TextStyle(color: Color(0xFFDC143C))),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFFDC143C), // Crimson color for back arrow
          ),
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.admin_panel_settings,
              color: Color(0xFFDC143C), // Crimson color for admin icon
            ),
            onPressed: () {
              // Navigate to admin login page or perform admin login logic
              _adminLogin();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: Image.asset('assets/logos/food_bottom_left.png', width: 80.0),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Image.asset('assets/logos/food_bottom_right.png', width: 80.0),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 20.0),
                  Image.asset(
                    'assets/logos/food_icon.png', // Replace with your food icon asset path
                    width: 120.0,
                    height: 120.0,
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Color(0xFFDC143C), // Icon color
                      ),
                      hintText: 'Email or Number',
                      errorText: _emailOrNumberError,
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Email or Phone Number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Color(0xFFDC143C), // Icon color
                      ),
                      hintText: 'Password',
                      errorText: _passwordError,
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  SizedBox(
                    width: double.infinity, // Make button full width
                    child: ElevatedButton(
                      onPressed: () {
                        _submitForm();
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFFDC143C), // Crimson color for button background
                      ),
                      child: const Text('Log In'),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignupPage(),
                        ),
                      );
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account? "),
                        Text(
                          'Sign Up',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFDC143C), // Crimson color for Sign Up text
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  const Text('--------------- OR ---------------', style: TextStyle(fontSize: 16.0)),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _buildSocialButton('assets/logos/facebook_logo.png', 40.0),
                      const SizedBox(width: 20.0), // Space between logos
                      _buildSocialButton('assets/logos/google_logo.png', 40.0),
                      const SizedBox(width: 20.0), // Space between logos
                      _buildSocialButton('assets/logos/twitter_logo.png', 40.0),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  const SizedBox(height: 20.0), // Added extra spacing
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.copyright,
                        size: 16.0,
                        color: Colors.blueGrey,
                      ),
                      SizedBox(width: 5.0),
                      Text('Royals Webtech',
                          style: TextStyle(color: Colors.blueGrey)),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PrivacyPolicyPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'Privacy Policy',
                      style: TextStyle(
                        color: Color(0xFFDC143C),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitForm() async {
    setState(() {
      if (_formKey.currentState!.validate()) {
        // Attempt Firebase authentication
        FirebaseAuth.instance
            .signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        )
            .then((UserCredential userCredential) {
          if (userCredential.user != null) {
            // Successful login
            if (_emailController.text == 'admin@gmail.com') {
              // Navigate to AdminPage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminNavigation(), // Replace with your admin page
                ),
              );
            } else {
              // Normal user login
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ThreeFragmentPage(), // Replace with your user page
                ),
              );
            }
          }
        }).catchError((error) {
          // Handle login errors
          setState(() {
            _emailOrNumberError = 'Invalid email or password';
            _passwordError = 'Invalid email or password';
          });
        });
      } else {
        // Validation failed
        setState(() {
          _emailOrNumberError = _emailController.text.isEmpty
              ? 'Please enter Email or Phone Number'
              : null;
          _passwordError =
          _passwordController.text.isEmpty ? 'Please enter Password' : null;
        });
      }
    });
  }

  void _adminLogin() async {
    setState(() {
      if (_emailController.text.trim() == 'admin@gmail.com' &&
          _passwordController.text.trim() == 'admin@123') {
        // Navigate to AdminPage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AdminHomePage(), // Replace with your admin page
          ),
        );
      } else {
        // Clear fields and show error for incorrect admin credentials
        setState(() {
          _emailOrNumberError = 'Invalid admin credentials';
          _passwordError = 'Invalid admin credentials';
        });
      }
    });
  }

  Widget _buildSocialButton(String imagePath, double size) {
    return Image.asset(
      imagePath,
      width: size, // Adjust size as needed
      height: size,
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginPage(),
  ));
}