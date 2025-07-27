import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

import 'package:mihir/screens/GettingStartedScreen.dart';
import 'package:mihir/screens/LoginScreen.dart';
import 'package:mihir/screens/Register.dart';

import 'ExamApp.dart';
import 'ResultHistoryScreen.dart';
import 'WeeklyTestScreen.dart';

class StartScreen extends StatefulWidget {
  final String userName;
  final String userEmail;

  StartScreen({required this.userName, required this.userEmail});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.blueAccent,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Exam App'),
        backgroundColor: Colors.indigoAccent,
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.blue),
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.userName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.userEmail,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.history, color: Colors.indigo),
              title: Text('My Results'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ResultHistoryScreen(userName: widget.userName),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () {
                Navigator.pop(context);
                showAboutDialog(
                  context: context,
                  applicationName: 'Exam App',
                  applicationVersion: '1.0.0',
                  children: [Text('This is a simple quiz app using Flutter.')],
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlue.shade100, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 100, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome, ${widget.userName} 👋",
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            WeeklyTestScreen(userName: widget.userName)),
                  );
                },
                child: Card(
                  color: Colors.orangeAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 6,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Icon(Icons.assessment,
                            size: 40, color: Colors.white),
                        SizedBox(width: 16),
                        Text("Weekly Test",
                            style:
                            TextStyle(fontSize: 20, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// ---------------- Exam Page -----------------

class ExamPage extends StatefulWidget {
  final List<Question> questions;
  final String userName;
  ExamPage({required this.questions, required this.userName});

  @override
  State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  int _index = 0;
  int _score = 0;
  int _totalTime = 300;
  Timer? _examTimer;
  List<int> _selectedAnswers = [];

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.indigo,
      statusBarIconBrightness: Brightness.light,
    ));
    startExamTimer();
  }

  void startExamTimer() {
    _examTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_totalTime > 0) {
        setState(() => _totalTime--);
      } else {
        timer.cancel();
        _finish();
      }
    });
  }

  void _answerQuestion(int selected) {
    if (_selectedAnswers.length <= _index) {
      _selectedAnswers.add(selected);
    } else {
      _selectedAnswers[_index] = selected;
    }
  }

  void _nextQuestion() {
    if (_index < widget.questions.length - 1) {
      setState(() => _index++);
    } else {
      _finish();
    }
  }

  void _prevQuestion() {
    if (_index > 0) {
      setState(() => _index--);
    }
  }

  void _finish() async {
    _examTimer?.cancel();
    setState(() => _index = widget.questions.length);

    // Score calculation
    _score = 0;
    for (int i = 0; i < _selectedAnswers.length; i++) {
      if (_selectedAnswers[i] == widget.questions[i].correctIndex) {
        _score++;
      }
    }

    await FirebaseFirestore.instance.collection('results').add({
      'userName': widget.userName,
      'score': _score,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  String formatTime(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _examTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_index >= widget.questions.length || _totalTime <= 0) {
      double percentage = (_score / widget.questions.length) * 100;
      return Scaffold(
        appBar: AppBar(
          title: const Text('Result'),
          backgroundColor: Colors.blueAccent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        backgroundColor: const Color(0xFFF9F1FF),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.emoji_events, size: 80, color: Colors.grey),
                const SizedBox(height: 20),
                Text(
                  "🎉 Congratulations, ${widget.userName}!",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Your marks: $_score / ${widget.questions.length}",
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 6),
                Text(
                  "Percentage: ${percentage.toStringAsFixed(2)}%",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blueAccent,

                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CheckAnswersPage(
                          questions: widget.questions,
                          selectedAnswers: _selectedAnswers,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.remove_red_eye),
                  label: const Text("Check Answers"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  icon: const Icon(Icons.restart_alt),
                  label: const Text("Back to Start"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final question = widget.questions[_index];
    final selected = _selectedAnswers.length > _index
        ? _selectedAnswers[_index]
        : -1;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Q${_index + 1} | Time Left: ${formatTime(_totalTime)}"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo, Colors.deepPurple],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: EdgeInsets.fromLTRB(16, 100, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Q${_index + 1}: ${question.text}",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 20),
            ...List.generate(question.options.length, (i) {
              return Container(
                margin: EdgeInsets.only(bottom: 10),
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selected == i
                        ? Colors.greenAccent
                        : Colors.white.withOpacity(0.9),
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: () {
                    _answerQuestion(i);
                    setState(() {});
                  },
                  child: Text(question.options[i], style: TextStyle(fontSize: 16)),
                ),
              );
            }),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.arrow_back),
                  label: Text("Previous"),
                  onPressed: _index > 0 ? _prevQuestion : null,
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.arrow_forward),
                  label: Text(_index < widget.questions.length - 1 ? "Next" : "Submit"),
                  onPressed:
                  _index < widget.questions.length - 1 ? _nextQuestion : _finish,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// ---------------- Check Answers Page -----------------

class CheckAnswersPage extends StatelessWidget {
  final List<Question> questions;
  final List<int> selectedAnswers;

  CheckAnswersPage({required this.questions, required this.selectedAnswers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade100,
      appBar: AppBar(
        title: Text('Review Answers'),
        backgroundColor: Colors.grey.shade300,
      ),
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final q = questions[index];
          final selected =
          selectedAnswers.length > index ? selectedAnswers[index] : -1;
          final correct = q.correctIndex;

          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title:
              Text(q.text, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(q.options.length, (i) {
                  final isSelected = i == selected;
                  final isCorrect = i == correct;

                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Icon(
                          isCorrect
                              ? Icons.check_circle
                              : isSelected
                              ? Icons.cancel
                              : Icons.circle_outlined,
                          color: isCorrect
                              ? Colors.green
                              : isSelected
                              ? Colors.red
                              : Colors.grey,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            "${q.options[i]}",
                            style: TextStyle(
                              fontWeight: isCorrect || isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isCorrect
                                  ? Colors.green
                                  : isSelected
                                  ? Colors.red
                                  : Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          );
        },
      ),
    );
  }
}
