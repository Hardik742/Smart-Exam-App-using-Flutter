import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserResultsScreen extends StatelessWidget {
  const UserResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Results"),
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
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("results").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text("Something went wrong", style: TextStyle(color: Colors.white)));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            }

            final results = snapshot.data?.docs ?? [];

            if (results.isEmpty) {
              return const Center(
                child: Text("No results found", style: TextStyle(color: Colors.white, fontSize: 18)),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final data = results[index].data() as Map<String, dynamic>;
                final name = data['userName'] ?? 'Unknown';
                final score = data['score'] ?? 0;

                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 6,
                  margin: EdgeInsets.only(bottom: 16),
                  color: Colors.white.withOpacity(0.9),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    trailing: Text("Marks: $score",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        )),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
