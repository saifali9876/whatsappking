import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsappking/Otp_verify.dart';

class PhoneVerify extends StatefulWidget {
  const PhoneVerify({super.key});

  @override
  State<PhoneVerify> createState() => _PhoneVerifyState();
}

class _PhoneVerifyState extends State<PhoneVerify> {
  final Map<String, Map<String, String>> countryCodes = {
    'United States': {'code': '1', 'flag': '🇺🇸'},
    'India': {'code': '91', 'flag': '🇮🇳'},
    'Canada': {'code': '1', 'flag': '🇨🇦'},
    'United Kingdom': {'code': '44', 'flag': '🇬🇧'},
    'Australia': {'code': '61', 'flag': '🇦🇺'},
    'Germany': {'code': '49', 'flag': '🇩🇪'},
    'France': {'code': '33', 'flag': '🇫🇷'},
    'Japan': {'code': '81', 'flag': '🇯🇵'},
    'Brazil': {'code': '55', 'flag': '🇧🇷'},
    'Mexico': {'code': '52', 'flag': '🇲🇽'},
    'Russia': {'code': '7', 'flag': '🇷🇺'},
  };

  String? selectedCountry = 'India';
  String phoneCode = '91';
  TextEditingController phoneNumberController = TextEditingController();
  bool showError = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // OTP Verification Variables
  String? verificationId;
  bool isLoading = false;

  void _showConfirmationDialog() {
    if (phoneNumberController.text.isEmpty || phoneNumberController.text.length != 10) {
      setState(() {
        showError = true;
      });
    } else {
      setState(() {
        showError = false;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'You entered the phone number',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.start,
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      '+$phoneCode ${phoneNumberController.text}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  'Is this ok or would you like to edit the phone number?',
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Edit'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _sendOtp('+$phoneCode${phoneNumberController.text}');
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _sendOtp(String phoneNumber) async {
    setState(() {
      isLoading = true;
    });
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          _navigateToOtpVerify(phoneNumber);
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message ?? 'Verification failed')),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            isLoading = false;
            this.verificationId = verificationId;
          });
          _navigateToOtpVerify(phoneNumber);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          this.verificationId = verificationId;
        },
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Something went wrong. Please try again.')),
      );
    }
  }

  void _navigateToOtpVerify(String phoneNumber) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtpClass(
          phoneNumber: phoneNumber, verificationId: verificationId!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Icon(Icons.arrow_back, color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Verify your phone number',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'WhatsApp will send an SMS message to verify your phone number. Enter your country code and phone number:',
              style: TextStyle(fontSize: 14, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Country',
                      border: UnderlineInputBorder(),
                    ),
                    value: selectedCountry,
                    items: countryCodes.keys
                        .map((country) => DropdownMenuItem(
                      value: country,
                      child: Row(
                        children: [
                          Text(countryCodes[country]!['flag'] ?? ''),
                          SizedBox(width: 8),
                          Text(country),
                        ],
                      ),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCountry = value;
                        phoneCode = countryCodes[value]!['code'] ?? '1';
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: '+ Code',
                      border: UnderlineInputBorder(),
                    ),
                    readOnly: true,
                    controller: TextEditingController(text: phoneCode),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  flex: 4,
                  child: TextFormField(
                    controller: phoneNumberController,
                    decoration: InputDecoration(
                      labelText: 'Phone number',
                      border: UnderlineInputBorder(),
                      counterText: '',
                      errorText: showError
                          ? 'Please enter a valid 10-digit phone number'
                          : null,
                      errorStyle: TextStyle(color: Colors.red),
                    ),
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 92),
            Center(
              child: ElevatedButton(

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 12),

                ),
                onPressed: () {
                  _showConfirmationDialog();
                },
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                  'NEXT',
                  style: TextStyle(color: Colors.white),

                ),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                'Carrier SMS charges may apply',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

