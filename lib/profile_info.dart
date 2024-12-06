import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsappking/installing.dart';
import 'dart:io';

class ProfileInfoScreen extends StatefulWidget {
  @override
  _ProfileInfoScreenState createState() => _ProfileInfoScreenState();
}

class _ProfileInfoScreenState extends State<ProfileInfoScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  final TextEditingController _nameController = TextEditingController();
  bool _isImageError = false;
  bool _isNameError = false;

  Future<void> _showImageSourceBottomSheet() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text("Camera"),
            onTap: () {
              _pickImage(ImageSource.camera);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.photo_library),
            title: Text("Gallery"),
            onTap: () {
              _pickImage(ImageSource.gallery);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _isImageError = false; // Reset the error when an image is selected
      });
    }
  }

  void _validateAndProceed() {
    setState(() {
      _isImageError = _selectedImage == null;
      _isNameError = _nameController.text.isEmpty;
    });

    if (!_isImageError && !_isNameError) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => InitializingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            "Profile info",
            style: TextStyle(
              color: Colors.green,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            Text(
              "Please provide your name and an optional profile photo",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 30),
            GestureDetector(
              onTap: _showImageSourceBottomSheet,
              child: Container(
                padding: EdgeInsets.all(4), // Padding for the border effect
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _isImageError ? Colors.red : Colors.transparent,
                    width: 2, // Border width
                  ),
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: _selectedImage != null ? FileImage(_selectedImage!) : null,
                  child: _selectedImage == null
                      ? Icon(
                    Icons.camera_alt,
                    color: Colors.grey,
                    size: 40,
                  )
                      : null,
                ),
              ),
            ),
            if (_isImageError)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  "Please select a profile photo",
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            SizedBox(height: 30),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: "Type your name here",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: _isNameError ? Colors.red : Colors.green),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                errorText: _isNameError ? "Please enter your name" : null,
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: _validateAndProceed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Text(
                "Next",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}