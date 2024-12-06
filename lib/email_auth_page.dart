// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:whatsappking/installing.dart'; // Import your InitializingScreen
//
// class AuthScreen extends StatefulWidget {
//   const AuthScreen({super.key});
//
//   @override
//   _AuthScreenState createState() => _AuthScreenState();
// }
//
// class _AuthScreenState extends State<AuthScreen> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   bool isLogin = true;
//
//   void _authenticate() async {
//     String email = _emailController.text.trim();
//     String password = _passwordController.text.trim();
//
//     if (email.isEmpty || password.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Please fill all fields"),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }
//
//     try {
//       if (isLogin) {
//         // Login
//         await _auth.signInWithEmailAndPassword(
//           email: email,
//           password: password,
//         );
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text("Login Successful!"),
//             backgroundColor: Colors.green,
//           ),
//         );
//         // Navigate to InitializingScreen
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => InitializingScreen(),
//           ),
//         );
//       } else {
//         // Sign Up
//         await _auth.createUserWithEmailAndPassword(
//           email: email,
//           password: password,
//         );
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text("Sign Up Successful!"),
//             backgroundColor: Colors.green,
//           ),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Error: $e"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
//
//   void _logout() async {
//     await _auth.signOut();
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text("Logged Out!"),
//         backgroundColor: Colors.green,
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blue,
//         title: Text(isLogin ? 'Login' : 'Sign Up'),
//         actions: [
//           if (FirebaseAuth.instance.currentUser != null)
//             IconButton(
//               onPressed: _logout,
//               icon: const Icon(Icons.logout),
//             ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _emailController,
//               decoration: const InputDecoration(labelText: 'Email'),
//             ),
//             TextField(
//               controller: _passwordController,
//               decoration: const InputDecoration(labelText: 'Password'),
//               obscureText: true,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _authenticate,
//               child: Text(isLogin ? 'Login' : 'Sign Up'),
//             ),
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   isLogin = !isLogin;
//                 });
//               },
//               child: Text(isLogin
//                   ? 'Create an Account'
//                   : 'Already have an account? Login'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
