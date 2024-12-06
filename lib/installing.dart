import 'package:flutter/material.dart';
import 'package:whatsappking/all_screen.dart'; // Import AllScreens

class InitializingScreen extends StatefulWidget {
  @override
  _InitializingScreenState createState() => _InitializingScreenState();
}

class _InitializingScreenState extends State<InitializingScreen> {
  @override
  void initState() {
    super.initState();
    // Delay for 3 seconds, then navigate to AllScreens
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AllScreens(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Initializing...",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Please wait a moment",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 50),
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green.withOpacity(0.1),
              ),
              child: const Center(
                child: Icon(
                  Icons.image,
                  color: Colors.green,
                  size: 80,
                ),
              ),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
