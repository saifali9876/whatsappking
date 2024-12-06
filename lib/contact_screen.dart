import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsappking/all_screen.dart';
import 'package:whatsappking/chats_screen.dart';
import 'package:whatsappking/provider_page.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  TextEditingController _searchController = TextEditingController();
  List<Contact> _filteredContacts = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final contactProvider =
      Provider.of<ContactProvider>(context, listen: false);
      contactProvider.fetchContacts();
    });

    _searchController.addListener(_filterContacts);
  }

  void _filterContacts() {
    final contactProvider = Provider.of<ContactProvider>(context, listen: false);
    final searchTerm = _searchController.text.toLowerCase();

    setState(() {
      _filteredContacts = contactProvider.contacts.where((contact) {
        final name = contact.displayName?.toLowerCase() ?? '';
        return name.startsWith(searchTerm);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contactProvider = Provider.of<ContactProvider>(context);
    final contacts = _searchController.text.isEmpty
        ? contactProvider.contacts
        : _filteredContacts;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AllScreens(),));
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select contact',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${contacts.length} contacts',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search contacts',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
        ),
      ),
      body: contacts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          Contact contact = contacts[index];

          return ListTile(
            leading: contact.avatar != null && contact.avatar!.isNotEmpty
                ? CircleAvatar(
              backgroundImage: MemoryImage(contact.avatar!),
            )
                : CircleAvatar(
              backgroundColor: Colors.grey.shade200,
              child: Icon(
                Icons.person,
                color: Colors.grey,
              ),
            ),
            title: Text(contact.displayName ?? 'No Name'),
            subtitle: Text(
              contact.phones?.isNotEmpty == true
                  ? contact.phones!.first.value!
                  : 'No phone number',
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatsScreen(contact: contact),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
