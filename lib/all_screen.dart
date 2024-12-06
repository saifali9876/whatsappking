import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsappking/contact_screen.dart';
import 'package:whatsappking/myprofile_page.dart';
import 'package:provider/provider.dart';
import 'package:whatsappking/provider_page.dart';

class AllScreens extends StatefulWidget {
  const AllScreens({super.key});

  @override
  State<AllScreens> createState() => _AllScreensState();
}

class _AllScreensState extends State<AllScreens> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _openCamera() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      print("Image path: ${photo.path}");
    }
  }

  Future<void> _openGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      print("Image path: ${image.path}");
    }
  }

  void _navigateToContactPage() {
    // Fetch contacts and navigate to ContactPage when done
    final contactProvider = Provider.of<ContactProvider>(context, listen: false);
    contactProvider.fetchContacts().then((_) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ContactPage()),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(120),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.blue.shade800,
            title: Text(
              'ChatKing',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.camera_alt, color: Colors.white),
                onPressed: _openCamera,
              ),
              SizedBox(width: 10),
              Icon(Icons.search, color: Colors.white),
              SizedBox(width: 10),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: Colors.white),
                onSelected: (value) {
                  if (value == 'My Profile') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MyProfile()),
                    );
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      value: 'My Profile',
                      child: Text('My Profile'),
                    ),
                  ];
                },
              ),
            ],
            bottom: TabBar(
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: [
                Tab(text: 'Chats'),
                Tab(text: 'Groups'),
                Tab(text: 'Calls'),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Center(child: Text('Chats Screen Content')),
            Center(child: Text('Groups Screen Content')),
            Center(child: Text('Calls Screen Content')),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.chat,color: Colors.white,),
          backgroundColor: Colors.blue.shade800 ,onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ContactPage(),));
        },
        ),
      ),
    );
  }
}
