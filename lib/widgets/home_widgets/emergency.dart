import 'package:flutter/material.dart';
import 'package:protectionx/widgets/home_widgets/emergencies/FirebrigadeEmergency.dart';


import 'emergencies/AllcaseEmergency.dart';
import 'emergencies/AmbulanceEmergency.dart';
import 'emergencies/PoliceEmergency.dart';

class Emergency extends StatelessWidget {
  const Emergency({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 180,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            PoliceEmergency(),
            AmbulanceEmergency(),
            AllcaseEmergency(),
            FirebrigadeEmergency(),
          ],
        ),
      ),
    );
  }
}
