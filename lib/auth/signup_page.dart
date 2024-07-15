import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_app/auth/login_page.dart'; // Import your LoginPage or replace with your actual import path

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SIGN UP', style: TextStyle(color: Color(0xFFDC143C))),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFFDC143C), // Crimson color for back arrow
          ),
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back
          },
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Align(
                alignment: Alignment.bottomLeft,
                child: Image.asset('assets/logos/food_bottom_left.png', width: constraints.maxWidth * 0.2),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Image.asset('assets/logos/food_bottom_right.png', width: constraints.maxWidth * 0.2),
              ),
              SingleChildScrollView(
                padding: EdgeInsets.all(constraints.maxWidth * 0.05),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: constraints.maxHeight * 0.02), // Reduced height
                      Image.asset(
                        'assets/logos/food_icon.png', // Replace with your food icon asset path
                        width: constraints.maxWidth * 0.3,
                        height: constraints.maxWidth * 0.3,
                      ),
                      SizedBox(height: constraints.maxHeight * 0.05),
                      _buildTextFieldWithIcon(
                        Icons.person,
                        'Name',
                        controller: _nameController,
                        color: const Color(0xFFDC143C),
                        validator: 'Please enter your name',
                      ), // Crimson color for name icon
                      SizedBox(height: constraints.maxHeight * 0.02),
                      _buildTextFieldWithIcon(
                        Icons.email,
                        'Email',
                        controller: _emailController,
                        color: const Color(0xFFDC143C),
                        validator: 'Please enter your email',
                      ), // Crimson color for email icon
                      SizedBox(height: constraints.maxHeight * 0.02),
                      _buildTextFieldWithIcon(
                        Icons.lock,
                        'Password',
                        controller: _passwordController,
                        obscureText: true,
                        color: const Color(0xFFDC143C),
                        validator: 'Please enter password',
                      ), // Crimson color for password icon
                      SizedBox(height: constraints.maxHeight * 0.02),
                      _buildTextFieldWithIcon(
                        Icons.lock,
                        'Confirm Password',
                        controller: _confirmPasswordController,
                        obscureText: true,
                        color: const Color(0xFFDC143C),
                        validator: 'Please confirm your password',
                        confirmPassword: _passwordController.text,
                      ), // Crimson color for confirm password icon
                      SizedBox(height: constraints.maxHeight * 0.02),
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
                          child: const Text('Sign Up'),
                        ),
                      ),
                      SizedBox(height: constraints.maxHeight * 0.02),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()), // Navigate to LoginPage
                          );
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                            ),
                            Text(
                              'Log In',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFDC143C), // Crimson color for Log In text
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: constraints.maxHeight * 0.02),
                      const Text('--------------- OR ---------------', style: TextStyle(fontSize: 16.0)),
                      SizedBox(height: constraints.maxHeight * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _buildSocialButton('assets/logos/facebook_logo.png', constraints.maxWidth * 0.1),
                          SizedBox(width: constraints.maxWidth * 0.05), // Space between logos
                          _buildSocialButton('assets/logos/google_logo.png', constraints.maxWidth * 0.1),
                          SizedBox(width: constraints.maxWidth * 0.05), // Space between logos
                          _buildSocialButton('assets/logos/twitter_logo.png', constraints.maxWidth * 0.1),
                        ],
                      ),
                      SizedBox(height: constraints.maxHeight * 0.02),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTextFieldWithIcon(
      IconData icon,
      String hintText, {
        TextEditingController? controller,
        bool obscureText = false,
        Color? color,
        String? validator,
        String? confirmPassword,
      }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: color, // Icon color
        ),
        hintText: hintText,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validator ?? 'Please enter $hintText';
        }
        if (confirmPassword != null && value != confirmPassword) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }

  Widget _buildSocialButton(String imagePath, double size) {
    return Image.asset(
      imagePath,
      width: size, // Adjust size as needed
      height: size,
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Navigate to the LoginPage
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } catch (e) {
        // Handle errors here
        print('Error signing up: $e');
        // Display error message to the user using ScaffoldMessenger or showDialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to sign up. Please try again later.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SignupPage(),
  ));
}
