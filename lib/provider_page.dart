import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactProvider extends ChangeNotifier {
  List<Contact> _contacts = [];

  List<Contact> get contacts => _contacts;

  Future<void> fetchContacts() async {
    // Check and request permissions
    PermissionStatus permissionStatus = await Permission.contacts.request();
    if (permissionStatus.isGranted) {
      try {
        // Fetch contacts
        Iterable<Contact> fetchedContacts = await ContactsService.getContacts();
        _contacts = fetchedContacts.toList();
        notifyListeners();
      } catch (e) {
        debugPrint("Error fetching contacts: $e");
      }
    } else {
      debugPrint("Contacts permission denied");
    }
  }
}
