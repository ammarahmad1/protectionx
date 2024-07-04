import 'package:flutter/material.dart';
import 'package:protectionx/bottom_screens/add_contacts.dart';
import 'package:protectionx/bottom_screens/chat_screen.dart';
import 'package:protectionx/bottom_screens/contact_registry.dart';
import 'package:protectionx/bottom_screens/contacts_screen.dart';
import 'package:protectionx/bottom_screens/home_screen.dart';
import 'package:protectionx/bottom_screens/profile_page.dart';

class BottomPage extends StatefulWidget {
  const BottomPage({super.key});

  @override
  State<BottomPage> createState() => _BottomPageState();
}

class _BottomPageState extends State<BottomPage> {
  int currentIndex=0;
  List<Widget> pages = [
    HomeScreen(),
    AddContactsPage(),
    ChatScreen(),
    ContactRegistry(),
    ProfilePage(),
  ];
  onTapped(int index) {
    setState(() {
      currentIndex=index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: onTapped,
        items: [
          BottomNavigationBarItem(
            label: 'home',
            icon: Icon(
              Icons.home, 
              )),
          BottomNavigationBarItem(
            label: 'contacts',
            icon: Icon(
              Icons.contacts, 
              )),
              
          BottomNavigationBarItem(
            label: 'chats',
            icon: Icon(
              Icons.chat, 
              )),     
          BottomNavigationBarItem(
            label: 'Contact Registry',
            icon: Icon(
              Icons.quick_contacts_dialer_rounded, 
              )),            
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(
              Icons.person, 
              )),            
        ]
        ),
      
    );
  }
}