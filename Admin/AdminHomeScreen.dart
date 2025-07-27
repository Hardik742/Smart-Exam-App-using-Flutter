import 'package:flutter/material.dart';
import 'UploadQuestionScreen.dart';
import 'UserResultsScreen.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Panel"),
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurpleAccent, Colors.indigoAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Welcome Admin 👨‍💻",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 40),
                _adminOptionCard(
                  context,
                  icon: Icons.upload_file,
                  label: "Upload Questions",
                  color: Colors.orangeAccent,
                  destination: UploadQuestionScreen(),
                ),
                SizedBox(height: 20),
                _adminOptionCard(
                  context,
                  icon: Icons.bar_chart,
                  label: "View User Results",
                  color: Colors.lightGreen,
                  destination: UserResultsScreen(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _adminOptionCard(BuildContext context,
      {required IconData icon,
        required String label,
        required Color color,
        required Widget destination}) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        leading: Icon(icon, size: 36, color: Colors.white),
        tileColor: color,
        title: Text(
          label,
          style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => destination),
          );
        },
      ),
    );
  }
}
