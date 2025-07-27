import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'screens/LoginScreen.dart';
import 'StartScreen.dart';

class Question {
  final String text;
  final List<String> options;
  final int correctIndex;

  Question({required this.text, required this.options, required this.correctIndex});

  factory Question.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final List<String> options = [
      data['optionA'] ?? '',
      data['optionB'] ?? '',
      data['optionC'] ?? '',
      data['optionD'] ?? '',
    ];
    final correctAnswer = data['correctAnswer'] ?? '';
    final correctIndex = options.indexOf(correctAnswer);

    return Question(
      text: data['question'] ?? '',
      options: options,
      correctIndex: data['correctIndex'] ?? 0,
    );
  }
}
class Exam {
  final String id;
  final String title;
  final String description;

  Exam({required this.id, required this.title, required this.description});

  factory Exam.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Exam(
      id: doc.id,
      title: data['title'] ?? 'No Title',
      description: data['description'] ?? '',
    );
  }
}


class ExamApp extends StatelessWidget {
  final String userName;
  final String userEmail;
  const ExamApp({super.key, required this.userName, required this.userEmail});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StartScreen(userName: userName, userEmail: userEmail),
      debugShowCheckedModeBanner: false,
    );
  }
}