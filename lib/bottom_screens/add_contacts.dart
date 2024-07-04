import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:protectionx/bottom_screens/contacts_screen.dart';
import 'package:protectionx/components/PrimaryButton.dart';
import 'package:protectionx/db/db_services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:protectionx/model/contactsm.dart';

class AddContactsPage extends StatefulWidget {
  const AddContactsPage({Key? key}) : super(key: key);

  @override
  State<AddContactsPage> createState() => _AddContactsPageState();
}

class _AddContactsPageState extends State<AddContactsPage> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<TContact>? contactList;
  int count = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showList();
    });
  }

  void showList() async {
    List<TContact> list = await databaseHelper.getContactList();
    setState(() {
      contactList = list;
      count = list.length;
    });
  }

  void deleteContact(TContact contact) async {
    int result = await databaseHelper.deleteContact(contact.id);
    if (result != 0) {
      Fluttertoast.showToast(msg: "Contact removed");
      showList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Manage Contacts")),
      body: SafeArea(
        child: Column(children: [
          PrimaryButton(
            title: "Add your trusted Contacts",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContactsPage()),
              );
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: count,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    title: Text(contactList![index].name),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () async {
                            await FlutterPhoneDirectCaller.callNumber(
                                contactList![index].number);
                          },
                          icon: Icon(Icons.call, color: Colors.green),
                        ),
                        IconButton(
                          onPressed: () {
                            deleteContact(contactList![index]);
                          },
                          icon: Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ]),
      ),
    );
  }
}
