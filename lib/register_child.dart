import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:protectionx/login_screen.dart';
import 'package:protectionx/model/user_model.dart';
import 'package:protectionx/utils/constants.dart';
import 'package:protectionx/components/PrimaryButton.dart';
import 'package:protectionx/components/SecondaryButton.dart';
import 'package:protectionx/components/custom_textfield.dart';

class RegisterChildScreen extends StatefulWidget {
  @override
  State<RegisterChildScreen> createState() => _RegisterChildScreenState();
}

class _RegisterChildScreenState extends State<RegisterChildScreen> {
  bool isPasswordShown = true;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    if (_formData['password'] != _formData['rpassword']) {
      dialogue(context, 'Password and retype password do not match');
    } else {
      setState(() {
        isLoading = true;
      });

      try {
        FirebaseAuth auth = FirebaseAuth.instance;
        UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: _formData['email'].toString(),
          password: _formData['password'].toString(),
        );

        DocumentReference<Map<String, dynamic>> db =
            FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid);

        final user = UserModel(
          name: _formData['name'].toString(),
          phone: _formData['phone'].toString(),
          childEmail: _formData['email'].toString(),
          guardianEmail: _formData['gemail'].toString(),
          guardianPhone: _formData['gphone'].toString(),
          id: userCredential.user!.uid,
          type: 'child',
        );

        final jsonData = user.toJson();
        await db.set(jsonData).whenComplete(() {
          setState(() {
            isLoading = false;
          });
          goTo(context, LoginScreen());
        });
      } on FirebaseAuthException catch (e) {
        setState(() {
          isLoading = false;
        });

        if (e.code == 'email-already-in-use') {
          dialogue(context, 'The email address is already in use by another account.');
        } else {
          dialogue(context, e.message.toString());
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        dialogue(context, e.toString());
      }
    }
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
            isLoading
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
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
                              "Register",
                              style: TextStyle(
                                fontSize: 40,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 40), // Spacing between title and form
                        // Registration form
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              CustomTextField(
                                hintText: 'Name',
                                textInputAction: TextInputAction.next,
                                keyboardtype: TextInputType.name,
                                prefix: Icon(Icons.person, color: Colors.white),
                                onsave: (name) {
                                  _formData['name'] = name ?? "";
                                },
                                validate: (name) {
                                  if (name!.isEmpty || name.length < 2) {
                                    return 'Please enter a valid name.';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20),
                              CustomTextField(
                                hintText: 'Phone',
                                textInputAction: TextInputAction.next,
                                keyboardtype: TextInputType.phone,
                                prefix: Icon(Icons.dialpad, color: Colors.white),
                                onsave: (phone) {
                                  _formData['phone'] = phone ?? "";
                                },
                                validate: (phone) {
                                  if (phone!.isEmpty || phone.length < 2) {
                                    return 'Please enter a valid phone number.';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20),
                              CustomTextField(
                                hintText: 'Email',
                                textInputAction: TextInputAction.next,
                                keyboardtype: TextInputType.emailAddress,
                                prefix: Icon(Icons.email, color: Colors.white),
                                onsave: (email) {
                                  _formData['email'] = email ?? "";
                                },
                                validate: (email) {
                                  if (email!.isEmpty ||
                                      email.length < 2 ||
                                      !email.contains('@')) {
                                    return 'Please enter a valid email.';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20),
                              CustomTextField(
                                hintText: 'Guardian Email',
                                textInputAction: TextInputAction.next,
                                keyboardtype: TextInputType.emailAddress,
                                prefix: Icon(Icons.email, color: Colors.white),
                                onsave: (gemail) {
                                  _formData['gemail'] = gemail ?? "";
                                },
                                validate: (gemail) {
                                  if (gemail!.isEmpty ||
                                      gemail.length < 2 ||
                                      !gemail.contains('@')) {
                                    return 'Please enter a valid guardian email.';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20),
                              CustomTextField(
                                hintText: 'Guardian Phone',
                                textInputAction: TextInputAction.next,
                                keyboardtype: TextInputType.phone,
                                prefix: Icon(Icons.dialpad, color: Colors.white),
                                onsave: (gphone) {
                                  _formData['gphone'] = gphone ?? "";
                                },
                                validate: (gphone) {
                                  if (gphone!.isEmpty || gphone.length < 2) {
                                    return 'Please enter a valid guardian phone number.';
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
                                  if (password!.isEmpty || password.length < 4) {
                                    return 'Password must be at least 4 characters long.';
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
                              CustomTextField(
                                hintText: 'Re-enter Password',
                                isPassword: isPasswordShown,
                                prefix: Icon(Icons.lock, color: Colors.white),
                                onsave: (rpassword) {
                                  _formData['rpassword'] = rpassword ?? "";
                                },
                                validate: (rpassword) {
                                  if (rpassword!.isEmpty || rpassword.length < 4) {
                                    return 'Passwords do not match.';
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
                                title: "Register",
                                onPressed: _onSubmit,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        // Login button
                        SecondaryButton(
                          title: "Login with your account",
                          onPressed: () {
                            goTo(context, LoginScreen());
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
