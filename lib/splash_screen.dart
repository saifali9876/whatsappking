import 'package:flutter/material.dart';
import 'package:whatsappking/home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            // WhatsApp logo
            Center(
              child: Image.asset(
                'asset/chat.png',
                height: 70,
              ),
            ),
            Spacer(flex: 2),
            // "from Meta" text
            Column(
              children: [
                Text(
                  'from',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.all_inclusive, // Meta icon (approximation)
                      color: Colors.green,
                      size: 18,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Meta',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 60), // Additional space at the bottom
          ],
        ),
      ),
    );
  }
}
