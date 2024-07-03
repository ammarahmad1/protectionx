import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:protectionx/db/share_pref.dart';
import 'package:protectionx/bottom_screens/home_screen.dart';
import 'package:protectionx/register_child.dart';
import 'package:protectionx/utils/constants.dart';

import 'components/PrimaryButton.dart';
import 'components/SecondaryButton.dart';
import 'components/custom_textfield.dart';

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
          
          MaterialPageRoute(builder: (context) => HomeScreen()),
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
        errorMessage = 'Wrong credientials. Please try again.';
      }

      dialogue(context, errorMessage);
      print(errorMessage);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      dialogue(context, 'An error occurred. Please try again.');
      print('An error occurred. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Stack(
            children: [
              if (isLoading)
                Center(child: CircularProgressIndicator())
              else
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Login",
                              style: TextStyle(fontSize: 40, color: primaryColor),
                            ),
                            Image.asset(
                              'assets/logo.jpg',
                              height: 100,
                              width: 100,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomTextField(
                                hintText: 'Email',
                                textInputAction: TextInputAction.next,
                                keyboardtype: TextInputType.emailAddress,
                                prefix: Icon(Icons.email),
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
                              CustomTextField(
                                hintText: 'Password',
                                isPassword: isPasswordShown,
                                prefix: Icon(Icons.lock),
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
                                  icon: isPasswordShown ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
                                ),
                              ),
                              PrimaryButton(
                                title: "Sign in",
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _onSubmit();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Forgot Password?',
                              style: TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            SecondaryButton(title: "Reset Your Password", onPressed: () {}),
                          ],
                        ),
                      ),
                      SecondaryButton(
                        title: "Sign up",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RegisterChildScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
