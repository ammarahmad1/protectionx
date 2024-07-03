import 'package:flutter/material.dart';

Color primaryColor = Color.fromARGB(255, 204, 0, 65);

void goto(BuildContext context, Widget nextScreen) {
  Navigator.push(
    context, 
    MaterialPageRoute(builder: (context) => nextScreen,
    ));
}

Widget progressIndicator(BuildContext context) {
   return Stack(
    children: [
      Opacity(
        opacity: 0.3,
        child: ModalBarrier(dismissible: false, color: Colors.black),
      ),
      Center(
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: CircularProgressIndicator(
              strokeWidth: 6.0,
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            ),
          ),
        ),
      ),
    ],
  );
}

dialogue(BuildContext context, String text){
 showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        text,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Customize the title text style
      ),
      content: SizedBox(
        width: 300, // Set a fixed width for the dialog
        child: Text(
          text,
          style: TextStyle(fontSize: 16), // Customize the content text style
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'OK',
            style: TextStyle(color: Colors.blue, fontSize: 16), // Customize the button text style
          ),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Add rounded corners to the dialog
      ),
    ),
  );  
}


void goTo(BuildContext context, Widget nextScreen) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => nextScreen,
      ));
}
