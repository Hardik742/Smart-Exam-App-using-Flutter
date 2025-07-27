import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ResultHistoryScreen extends StatelessWidget {
  final String userName;

  const ResultHistoryScreen({super.key, required this.userName});

  Future<List<Map<String, dynamic>>> fetchResults() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('results')
        .where('userName', isEqualTo: userName)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("📊 My Exam Results"),
        backgroundColor: Colors.indigo,
        elevation: 4,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo.shade50, Colors.blue.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: fetchResults(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());

            if (snapshot.hasError) {
              print("Error: ${snapshot.error}");
              return Center(child: Text("Error loading data."));
            }

            final results = snapshot.data ?? [];

            if (results.isEmpty) {
              return Center(
                child: Text(
                  "You have not attempted any quizzes yet.",
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            return Column(
              children: [
                SizedBox(height: 20),
                Text(
                  "Total Attempts: ${results.length}",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo.shade800,
                  ),
                ),
                Divider(
                  thickness: 1.2,
                  color: Colors.indigo.shade200,
                  indent: 40,
                  endIndent: 40,
                  height: 30,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final result = results[index];
                      final score = result['score'];

                      return Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.indigo.shade100,
                              child: Icon(Icons.assignment_turned_in,
                                  color: Colors.indigo),
                            ),
                            title: Text(
                              "Attempt ${index + 1}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Text("Score: $score"),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
