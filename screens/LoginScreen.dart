
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mihir/ExamApp.dart';

import '../Common.dart';
import 'AdminLoginScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/blob-scene-haikei.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(),
            Container(
              padding: EdgeInsets.only(left: 35, top: 150),
              child: Text(
                'Welcome\nBack',
                style: TextStyle(color: Colors.blueGrey, fontSize: 40),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          TextField(
                            controller: _emailController,
                            style: TextStyle(color: Colors.blueGrey),
                            decoration: InputDecoration(
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              hintText: "Email",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 30,
                          ),
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscure,               //  2. bind the state
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          suffixIcon: IconButton(            //  3. on/off eye button
                            icon: Icon(
                              _obscure ? Icons.visibility_off : Icons.visibility,
                              color: Colors.black12,
                            ),
                            onPressed: () {
                              setState(() => _obscure = !_obscure);
                            },
                          ),
                        ),
                      ),

                          SizedBox(
                            height: 40,
                          ),


                          appButtonWithRequiredParameter(
                            click: () async {
                              final email = _emailController.text.trim();
                              final password = _passwordController.text.trim();

                              try {
                                final query = await FirebaseFirestore.instance
                                    .collection('users')
                                    .where('email', isEqualTo: email)
                                    .where('password', isEqualTo: password)
                                    .get();

                                if (query.docs.isNotEmpty) {
                                  final userDoc = query.docs.first;
                                  final userName = userDoc['name']; // 👈 Get name from Firestore
                                  final userEmail = userDoc['email'];

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ExamApp(userName: userName,userEmail: userEmail), // 👈 Pass name to ExamApp
                                    ),
                                  );
                                }
                                else {
                                  //  No user found
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Invalid email or password")),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Error: ${e.toString()}")),
                                );
                              }
                            },

                          ),
                          TextButton(
                            onPressed: () {
                              // Navigate to a separate admin login screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AdminLoginScreen()),
                              );
                            },
                            child: Text(
                              "Login as Admin",
                              style: TextStyle(
                                color: Colors.blueGrey,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),

                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
