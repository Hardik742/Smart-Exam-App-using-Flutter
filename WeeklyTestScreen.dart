import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:ui'; // for blur effect
import 'package:mihir/ExamApp.dart';
import 'StartScreen.dart';

class WeeklyTestScreen extends StatefulWidget {
  final String userName;

  WeeklyTestScreen({required this.userName});
  @override
  State<WeeklyTestScreen> createState() => _WeeklyTestScreenState();
}

class _WeeklyTestScreenState extends State<WeeklyTestScreen> {
  bool _loading = false;

  Future<List<Question>> _loadQuestions() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('questions')
        .get();

    return querySnapshot.docs
        .map((doc) => Question.fromFirestore(doc))
        .toList();
  }

  void _startExam() async {
    setState(() => _loading = true);

    List<Question> questions = await _loadQuestions();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ExamPage(questions: questions,userName: widget.userName,),
      ),
    );

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Weekly Test"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigoAccent.shade100, Colors.deepPurpleAccent.shade200],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Blur + semi-transparent card
          Center(
            child: _loading
                ? CircularProgressIndicator(color: Colors.white)
                : ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.white30),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.folder_special, size: 40, color: Colors.amberAccent),
                          SizedBox(width: 10),
                          Text(
                            "Weekly Test",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Divider(color: Colors.white54, thickness: 1, height: 30),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "📝 Instructions:",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 10),
                      _instruction("You have 5 minutes to complete the exam."),
                      _instruction("Each question has a 10-second limit."),
                      _instruction("Your score and review will be shown at the end."),
                      _instruction("Do not refresh or exit during the test."),
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          onPressed: _startExam,
                          icon: Icon(Icons.play_arrow),
                          label: Text("Start Weekly Exam"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amberAccent.shade200,
                            foregroundColor: Colors.black,
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            textStyle: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _instruction(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, color: Colors.white70, size: 20),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
