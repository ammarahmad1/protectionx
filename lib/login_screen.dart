import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:protectionx/db/share_pref.dart';
import 'package:protectionx/bottom_screens/home_screen.dart';
import 'package:protectionx/register_child.dart';
import 'package:protectionx/utils/constants.dart';
import 'package:protectionx/bottom_page.dart';
import 'package:protectionx/components/PrimaryButton.dart';
import 'package:protectionx/components/SecondaryButton.dart';
import 'package:protectionx/components/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPasswordShown = true;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() {
      isLoading = true;
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _formData['email'].toString(),
        password: _formData['password'].toString(),
      );

      if (userCredential.user != null) {
        setState(() {
          isLoading = false;
        });
        MySharedPrefference.saveUserType('user');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomPage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });

      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found with this email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password.';
      } else {
        errorMessage = 'Wrong credentials. Please try again.';
      }

      _showDialog(context, errorMessage);
      print(errorMessage);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showDialog(context, 'An error occurred. Please try again.');
      print('An error occurred. Please try again.');
    }
  }

  void _showDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.purpleAccent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            if (isLoading)
              Center(child: CircularProgressIndicator())
            else
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(height: 20), // Spacing at the top
                    // Logo and title
                    Column(
                      children: [
                        Image.asset(
                          'assets/logo.jpg',
                          height: 100,
                          width: 200,
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40), // Spacing between title and form
                    // Login form
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            hintText: 'Email',
                            textInputAction: TextInputAction.next,
                            keyboardtype: TextInputType.emailAddress,
                            prefix: Icon(Icons.email, color: Colors.white),
                            onsave: (email) {
                              _formData['email'] = email ?? "";
                            },
                            validate: (email) {
                              if (email!.isEmpty || !email.contains('@')) {
                                return 'Please enter a valid email.';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          CustomTextField(
                            hintText: 'Password',
                            isPassword: isPasswordShown,
                            prefix: Icon(Icons.lock, color: Colors.white),
                            onsave: (password) {
                              _formData['password'] = password ?? "";
                            },
                            validate: (password) {
                              if (password!.isEmpty || password.length < 6) {
                                return 'Password must be at least 6 characters long.';
                              }
                              return null;
                            },
                            suffix: IconButton(
                              onPressed: () {
                                setState(() {
                                  isPasswordShown = !isPasswordShown;
                                });
                              },
                              icon: Icon(
                                isPasswordShown ? Icons.visibility_off : Icons.visibility,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          PrimaryButton(
                            title: "Sign in",
                            onPressed: _onSubmit,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    // Forgot password and sign-up options
                    
                    SizedBox(height: 20),
                    SecondaryButton(
                      title: "Sign up",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterChildScreen()),
                        );
                      },
                    ),
                    SizedBox(height: 20), // Spacing at the bottom
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
