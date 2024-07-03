import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:protectionx/utils/quotes.dart';

class CustomAppBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
      return Container(
        child: Text(
          sweetSayings[0],
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      );
    
  }
}