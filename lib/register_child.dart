import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:protectionx/login_screen.dart';
import 'package:protectionx/model/user_model.dart';
import 'package:protectionx/utils/constants.dart';
import 'components/PrimaryButton.dart';
import 'components/SecondaryButton.dart';
import 'components/custom_textfield.dart';

class RegisterChildScreen extends StatefulWidget {
  @override
  State<RegisterChildScreen> createState() => _RegisterChildScreenState();
}

class _RegisterChildScreenState extends State<RegisterChildScreen> {
  bool isPasswordShown = true;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  _onSubmit() async {
    _formKey.currentState!.save();
    if (_formData['password'] != _formData['rpassword']) {
      dialogue(context, 'Password and retype password not equal');
    } else {
      setState(() {
        isLoading = true;
      });
      try {
        FirebaseAuth auth = FirebaseAuth.instance;
        await auth.createUserWithEmailAndPassword(
          email: _formData['email'].toString(),
          password: _formData['password'].toString(),
        ).then((u) async {
          DocumentReference<Map<String, dynamic>> db =
              FirebaseFirestore.instance.collection('users').doc(u.user!.uid);

          final user = UserModel(
            name: _formData['name'].toString(),
            phone: _formData['phone'].toString(),
            childEmail: _formData['email'].toString(),
            guardianEmail: _formData['gemail'].toString(),
            guardianPhone: _formData['gphone'].toString(),
            id: u.user!.uid,
            type: 'child',
          );
          final jsonData = user.toJson();
          await db.set(jsonData).whenComplete(() {
            setState(() {
              isLoading = false;
            });
            goTo(context, LoginScreen());
          });
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
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Register",
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
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 1,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomTextField(
                          hintText: 'Name',
                          textInputAction: TextInputAction.next,
                          keyboardtype: TextInputType.name,
                          prefix: Icon(Icons.person),
                          onsave: (name) {
                            _formData['name'] = name ?? "";
                          },
                          validate: (name) {
                            if (name!.isEmpty || name.length < 2) {
                              return 'Name not correct';
                            }
                            return null;
                          },
                        ),
                        CustomTextField(
                          hintText: 'Phone',
                          textInputAction: TextInputAction.next,
                          keyboardtype: TextInputType.phone,
                          prefix: Icon(Icons.dialpad),
                          onsave: (phone) {
                            _formData['phone'] = phone ?? "";
                          },
                          validate: (phone) {
                            if (phone!.isEmpty || phone.length < 2) {
                              return 'Phone number not correct';
                            }
                            return null;
                          },
                        ),
                        CustomTextField(
                          hintText: 'Email',
                          textInputAction: TextInputAction.next,
                          keyboardtype: TextInputType.emailAddress,
                          prefix: Icon(Icons.email),
                          onsave: (email) {
                            _formData['email'] = email ?? "";
                          },
                          validate: (email) {
                            if (email!.isEmpty ||
                                email.length < 2 ||
                                !email.contains("@")) {
                              return 'Email not correct';
                            }
                            return null;
                          },
                        ),
                        CustomTextField(
                          hintText: 'Guardian Email',
                          textInputAction: TextInputAction.next,
                          keyboardtype: TextInputType.emailAddress,
                          prefix: Icon(Icons.email),
                          onsave: (gemail) {
                            _formData['gemail'] = gemail ?? "";
                          },
                          validate: (gemail) {
                            if (gemail!.isEmpty ||
                                gemail.length < 2 ||
                                !gemail.contains("@")) {
                              return 'Guardian email not correct';
                            }
                            return null;
                          },
                        ),
                        CustomTextField(
                          hintText: 'Guardian Phone',
                          textInputAction: TextInputAction.next,
                          keyboardtype: TextInputType.phone,
                          prefix: Icon(Icons.dialpad),
                          onsave: (gphone) {
                            _formData['gphone'] = gphone ?? "";
                          },
                          validate: (gphone) {
                            if (gphone!.isEmpty || gphone.length < 2) {
                              return 'Guardian phone number not correct';
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
                            if (password!.isEmpty || password.length < 4) {
                              return 'Password not correct';
                            }
                            return null;
                          },
                          suffix: IconButton(
                              onPressed: () {
                                setState(() {
                                  isPasswordShown = !isPasswordShown;
                                });
                              },
                              icon: isPasswordShown
                                  ? Icon(Icons.visibility_off)
                                  : Icon(Icons.visibility)),
                        ),
                        CustomTextField(
                          hintText: 'Re-enter Password',
                          isPassword: isPasswordShown,
                          prefix: Icon(Icons.lock),
                          onsave: (rpassword) {
                            _formData['rpassword'] = rpassword ?? "";
                          },
                          validate: (rpassword) {
                            if (rpassword!.isEmpty || rpassword.length < 4) {
                              return 'Re-entered password not correct';
                            }
                            return null;
                          },
                          suffix: IconButton(
                              onPressed: () {
                                setState(() {
                                  isPasswordShown = !isPasswordShown;
                                });
                              },
                              icon: isPasswordShown
                                  ? Icon(Icons.visibility_off)
                                  : Icon(Icons.visibility)),
                        ),
                        isLoading
                            ? CircularProgressIndicator()
                            : PrimaryButton(
                                title: "Register",
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
                SecondaryButton(
                    title: "Login with your account",
                    onPressed: () {
                      goTo(context, LoginScreen());
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
