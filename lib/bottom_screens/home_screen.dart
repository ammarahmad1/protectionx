import 'package:flutter/material.dart';
import 'package:protectionx/widgets/home_widgets/custom_appBar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:protectionx/widgets/home_widgets/custom_carousal.dart';
import 'package:protectionx/widgets/home_widgets/emergency.dart';

import '../widgets/home_widgets/safehome/SafeHome.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(),
            CustomeCarousel(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Emergency Call",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Emergency(),
            // SafeHome(),
        ],
        ),
      ),
    );
  }
}