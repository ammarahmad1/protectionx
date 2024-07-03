import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:protectionx/bottom_page.dart';
import 'package:protectionx/db/share_pref.dart';
import 'package:protectionx/bottom_screens/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:protectionx/login_screen.dart';
import 'package:protectionx/utils/constants.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  MySharedPrefference.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Protection X',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder(
        future: MySharedPrefference.getUserType(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            if (snapshot.data == "") {
              return LoginScreen();
            }
            if (snapshot.data == "user") {
              return BottomPage();
            }
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return LoginScreen();
        },
      ),
    );
  }
}

class CheckAuth extends StatelessWidget {
  // const CheckAuth({super.key});

  checkData() {
    if (MySharedPrefference.getUserType() == 'user') {
      // Your code to handle user type
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Your Scaffold implementation
    );
  }
}
