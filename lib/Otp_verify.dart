import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whatsappking/profile_info.dart';

class OtpClass extends StatefulWidget {
  final String phoneNumber;
  String verificationId;


   OtpClass({super.key, required this.phoneNumber,required this.verificationId});

  @override
  _OtpClassState createState() => _OtpClassState();
}

class _OtpClassState extends State<OtpClass> {
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());
  final List<TextEditingController> otpControllers = List.generate(6, (index) => TextEditingController());
  bool showError = false;

  void moveToNextField(int index) {
    if (otpControllers[index].text.isNotEmpty && index < 5) {
      FocusScope.of(context).requestFocus(focusNodes[index + 1]);
    } else if (index == 5 && otpControllers[5].text.isNotEmpty) {
      FocusScope.of(context).unfocus(); // Hide the keyboard when last field is filled
    }
  }

  void moveToPreviousField(int index) {
    if (otpControllers[index].text.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(focusNodes[index - 1]);
      otpControllers[index - 1].clear();
    }
  }

  void validateAndNavigate() {
    // Check if all OTP boxes are filled
    bool allFilled = otpControllers.every((controller) => controller.text.isNotEmpty);

    if (allFilled) {
      setState(() {
        showError = false;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileInfoScreen(),
        ),
      );
    } else {
      setState(() {
        showError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Verify ${widget.phoneNumber}",
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
          SizedBox(width: 8),
        ],
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              "Waiting to automatically detect an SMS sent to",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            Text(
              widget.phoneNumber,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                "Wrong number?",
                style: TextStyle(color: Colors.blue),
              ),
            ),
            SizedBox(height: 40),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 40,
                    height: 50,
                    child: RawKeyboardListener(
                      focusNode: FocusNode(),
                      onKey: (RawKeyEvent event) {
                        if (event is RawKeyDownEvent &&
                            event.logicalKey == LogicalKeyboardKey.backspace &&
                            otpControllers[index].text.isEmpty &&
                            index > 0) {
                          moveToPreviousField(index);
                        }
                      },
                      child: TextField(
                        controller: otpControllers[index],
                        focusNode: focusNodes[index],
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          counterText: "", // Hides the character counter
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: showError && otpControllers[index].text.isEmpty ? Colors.red : Colors.grey,
                            ),
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        onChanged: (value) {
                          if (value.length == 1) {
                            moveToNextField(index);
                          }
                        },
                      ),
                    ),
                  );
                }),
              ),
            ),
            if (showError)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Center(
                  child: Text(
                    "Please complete the OTP fields",
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),
              ),
            SizedBox(height: 40),
            Center(
              child: Text(
                "Enter the 6-digit code",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
            SizedBox(height: 40),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: validateAndNavigate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    "Next",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
