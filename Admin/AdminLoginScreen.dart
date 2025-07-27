import 'package:flutter/material.dart';
import 'package:mihir/ExamApp.dart';
import 'package:mihir/admin/AdminHomeScreen.dart';
import 'package:mihir/admin/UploadQuestionScreen.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _obscure = true;

  // ✅ Hardcoded Admin Credentials
  final String adminEmail = "admin@gmail.com";
  final String adminPassword = "admin123";

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
            Container(
              padding: EdgeInsets.only(left: 35, top: 150),
              child: Text(
                'Admin\nLogin',
                style: TextStyle(color: Colors.blueGrey, fontSize: 40),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.5),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 35),
                      child: Column(
                        children: [
                          TextField(
                            controller: _emailController,
                            style: TextStyle(color: Colors.blueGrey),
                            decoration: InputDecoration(
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              hintText: "Admin Email",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          TextField(
                            controller: _passwordController,
                            obscureText: _obscure,
                            decoration: InputDecoration(
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              hintText: "Password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              suffixIcon: IconButton(
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
                          SizedBox(height: 40),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              final email = _emailController.text.trim();
                              final password = _passwordController.text.trim();

                              if (email == adminEmail &&
                                  password == adminPassword) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AdminHomeScreen(),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                    Text("Invalid admin credentials."),
                                  ),
                                );
                              }
                            },
                            child: Text("Login as Admin"),
                          ),
                        ],
                      ),
                    ),
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
