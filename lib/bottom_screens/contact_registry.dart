import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class ContactRegistry extends StatelessWidget {
  const ContactRegistry({Key? key}) : super(key: key);

  void showEmergencyNumbers(BuildContext context, String region) {
    String numbers = '';
    switch (region) {
      case 'Islamabad':
        numbers = '''
Emergency Number: 15
IGP Complaint Number: 1715
Fire Brigade Number: 16
Rescue Service Number: 1122
PIMS Hospital Number: 051-9261170
Polyclinic Hospital Number: 051-9214965
        ''';
        break;
      case 'Khyber Pukhtoonkhwa':
        numbers = '''
Rescue 1122 
Peshawar HQrs: 091-2264224-25
Mardan: 0937-9230770
Fire Brigade Cantt: 091-9212534
Fire Brigade City: 091-2566666
        ''';
        break;
      case 'Punjab':
        numbers = '''
Police Helplines: 15
Rescue Service: 1122
Fire Brigade: 16
Medical Facilities: 1122
Edhi Main Control Room: 115
        ''';
        break;
      case 'Sindh':
        numbers = '''
WOMEN HELP LINE: 1094
EDHI AMBULANCE SERVICE: 115
AMAN FOUNDATION AMBULANCE: +92 (21) 1021
SINDH POLICE MADADGAR: 15
CHHIPA HELPLINE: 1020
SAYLANI WELFARE: 111-729-526
SINDH CHILD PROTECTION AUTHORITY: 1121
        ''';
        break;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$region Emergency Numbers'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: numbers.split('\n').map((line) {
              final phoneMatch = RegExp(r'(\d{2,})').firstMatch(line);
              final phoneNumber = phoneMatch != null ? phoneMatch.group(0) : null;
              return phoneNumber != null
                  ? GestureDetector(
                      onTap: () => _makePhoneCall(phoneNumber),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          line,
                          style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(line),
                    );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    await FlutterPhoneDirectCaller.callNumber(phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Registry'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey[50]!, Colors.blueGrey[200]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(10.0),
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          children: <Widget>[
            _buildGridTile(context, 'assets/islamabad.png', 'Islamabad'),
            _buildGridTile(context, 'assets/khyberpukhtoonkhwa.png', 'Khyber Pukhtoonkhwa'),
            _buildGridTile(context, 'assets/punjab.png', 'Punjab'),
            _buildGridTile(context, 'assets/sindh.png', 'Sindh'),
          ],
        ),
      ),
    );
  }

  Widget _buildGridTile(BuildContext context, String asset, String region) {
    return GestureDetector(
      onTap: () => showEmergencyNumbers(context, region),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              asset,
              fit: BoxFit.cover,
            ),
            Container(
              color: Colors.black54,
              alignment: Alignment.center,
              child: Text(
                region,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
