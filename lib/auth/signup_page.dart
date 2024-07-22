import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/User.dart';
import '../screens/home/home_page.dart';
import 'AuthService.dart';
import 'login_page.dart';

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

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

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
          icon: const Icon(Icons.arrow_back, color: Color(0xFFDC143C)),
          onPressed: () {
            Navigator.of(context).pop();
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
                      SizedBox(height: constraints.maxHeight * 0.02),
                      Image.asset(
                        'assets/logos/food_icon.png',
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
                      ),
                      SizedBox(height: constraints.maxHeight * 0.02),
                      _buildTextFieldWithIcon(
                        Icons.email,
                        'Email',
                        controller: _emailController,
                        color: const Color(0xFFDC143C),
                        validator: 'Please enter your email',
                      ),
                      SizedBox(height: constraints.maxHeight * 0.02),
                      _buildTextFieldWithIcon(
                        Icons.lock,
                        'Password',
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        color: const Color(0xFFDC143C),
                        validator: 'Please enter a password',
                        toggleVisibility: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      SizedBox(height: constraints.maxHeight * 0.02),
                      _buildTextFieldWithIcon(
                        Icons.lock,
                        'Confirm Password',
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        color: const Color(0xFFDC143C),
                        validator: 'Please confirm your password',
                        toggleVisibility: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                      SizedBox(height: constraints.maxHeight * 0.02),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xFFDC143C),
                          ),
                          child: const Text('Sign Up'),
                        ),
                      ),
                      SizedBox(height: constraints.maxHeight * 0.02),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                          );
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Already have an account? "),
                            Text(
                              'Log In',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFDC143C),
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
                        children: [
                          SizedBox(
                            height: 40,
                            child: Card(
                              child: GestureDetector(
                                onTap: () async {
                                  await AuthService().siginWithGoogle().then((value) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const HomePage()),
                                    );
                                  }).catchError((error) {
                                    print('Error signing in with Google: $error');
                                    // Handle error with AlertDialog or other method
                                  });
                                },
                                child: SizedBox(
                                  width: 250,
                                  height: 100,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          "assets/logos/google_logo.png",
                                          width: 50,
                                          height: 50,
                                        ),
                                        const Text(
                                          "Sign In With Google",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
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
        VoidCallback? toggleVisibility,
      }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: color),
        hintText: hintText,
        suffixIcon: toggleVisibility != null
            ? IconButton(
          icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off, color: color),
          onPressed: toggleVisibility,
        )
            : null,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validator ?? 'Please enter $hintText';
        }
        if (hintText == 'Confirm Password' && value != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Create a new user document in Firestore
        final user = UserModel(
          id: userCredential.user!.uid,
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          address: '',
          phoneNumber: '',
          lastActive: DateTime.now(),
          profileImageUrl: '',
          isActive: false,
        );

        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set(user.toMap());

        // Navigate to the LoginPage after successful sign-up
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } catch (e) {
        // Handle errors here
        print('Error signing up: $e');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to sign up. Please try again.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }
}
