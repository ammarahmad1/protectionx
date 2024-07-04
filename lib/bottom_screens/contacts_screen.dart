import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:protectionx/db/db_services.dart';
import 'package:protectionx/model/contactsm.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact> contacts = [];
  List<Contact> contactsFiltered = [];
  DatabaseHelper _databaseHelper = DatabaseHelper();
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    askPermissions();
    searchController.addListener(filterContacts);
  }

  @override
  void dispose() {
    searchController.removeListener(filterContacts);
    searchController.dispose();
    super.dispose();
  }

  String flattenPhoneNumber(String phoneStr) {
    return phoneStr.replaceAllMapped(RegExp(r'^(\+)|\D'), (Match m) {
      return m[0] == "+" ? "+" : "";
    });
  }

  void filterContacts() {
    List<Contact> _contacts = contacts.where((contact) {
      String searchTerm = searchController.text.toLowerCase();
      String searchTermFlattened = flattenPhoneNumber(searchTerm);
      String contactName = contact.displayName?.toLowerCase() ?? "";
      bool nameMatch = contactName.contains(searchTerm);
      if (nameMatch) return true;
      if (searchTermFlattened.isEmpty) return false;

      return contact.phones?.any((phone) {
        String phoneFlattened = flattenPhoneNumber(phone.value ?? "");
        return phoneFlattened.contains(searchTermFlattened);
      }) ?? false;
    }).toList();

    setState(() {
      contactsFiltered = _contacts;
    });
  }

  Future<void> askPermissions() async {
    PermissionStatus permissionStatus = await getContactsPermissions();
    if (permissionStatus == PermissionStatus.granted) {
      getAllContacts();
    } else {
      handleInvalidPermissions(permissionStatus);
    }
  }

  Future<void> getAllContacts() async {
    List<Contact> _contacts = await ContactsService.getContacts(withThumbnails: false);
    setState(() {
      contacts = _contacts;
    });
  }

  Future<PermissionStatus> getContactsPermissions() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted && permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    }
    return permission;
  }

  void handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus.isDenied || permissionStatus.isPermanentlyDenied) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Access Denied'),
          content: Text('Kindly allow contact access to proceed.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Search your contacts',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: contacts.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: isSearching ? contactsFiltered.length : contacts.length,
                      itemBuilder: (BuildContext context, int index) {
                        Contact contact = isSearching ? contactsFiltered[index] : contacts[index];
                        return ListTile(
                          title: Text(contact.displayName ?? 'No name'),
                          leading: (contact.avatar != null && contact.avatar!.isNotEmpty)
                              ? CircleAvatar(
                                  backgroundImage: MemoryImage(contact.avatar!),
                                )
                              : CircleAvatar(
                                  child: Text(contact.initials()),
                                ),
                          onTap: () {
                            if (contact.phones != null && contact.phones!.isNotEmpty) {
                              String phoneNum = contact.phones!.first.value ?? 'No phone number';
                              String name = contact.displayName ?? 'No name';
                              _addContact(TContact(phoneNum, name));
                            } else {
                              Fluttertoast.showToast(msg: "No phone number available for this contact.");
                            }
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _addContact(TContact newContact) async {
    int result = await _databaseHelper.insertContact(newContact);
    if (result != 0) {
      Fluttertoast.showToast(msg: "Emergency Contact added successfully");
    } else {
      Fluttertoast.showToast(msg: "Failed to add contact. Try again");
    }
    Navigator.of(context).pop(true);
  }
}
