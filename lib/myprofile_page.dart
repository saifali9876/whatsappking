import 'package:flutter/material.dart';
import 'package:whatsappking/all_screen.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        title: Text(
          'My Profile',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AllScreens()),
            );
          },
        ),
      ),
      body: Center(
        child: Text('My Profile Content'),
      ),
    );
  }
}
