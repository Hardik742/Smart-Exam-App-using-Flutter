import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Upload Question',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: UploadQuestionScreen(),
    );
  }
}

class UploadQuestionScreen extends StatefulWidget {
  @override
  _UploadQuestionScreenState createState() => _UploadQuestionScreenState();
}

class _UploadQuestionScreenState extends State<UploadQuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController questionController = TextEditingController();
  final TextEditingController optionAController = TextEditingController();
  final TextEditingController optionBController = TextEditingController();
  final TextEditingController optionCController = TextEditingController();
  final TextEditingController optionDController = TextEditingController();
  final TextEditingController correctAnswerController = TextEditingController();

  Future<void> uploadQuestion() async {
    if (_formKey.currentState!.validate()) {
      final questionText = questionController.text.trim();
      final optionA = optionAController.text.trim();
      final optionB = optionBController.text.trim();
      final optionC = optionCController.text.trim();
      final optionD = optionDController.text.trim();
      final correctAnswer = correctAnswerController.text.trim().toLowerCase();

      final options = [optionA, optionB, optionC, optionD];
      final correctIndex = options.indexWhere(
              (option) => option.toLowerCase() == correctAnswer);

      if (correctIndex == -1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Correct answer does not match any option.")),
        );
        return;
      }

      final query = await FirebaseFirestore.instance
          .collection('questions')
          .where('question', isEqualTo: questionText)
          .get();

      if (query.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("This question already exists.")),
        );
        return;
      }

      await FirebaseFirestore.instance.collection('questions').add({
        'question': questionText,
        'optionA': optionA,
        'optionB': optionB,
        'optionC': optionC,
        'optionD': optionD,
        'correctIndex': correctIndex,
        'correctAnswer': options[correctIndex],
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Question uploaded successfully")),
      );

      _formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Question"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade100, Colors.indigo.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.white.withOpacity(0.95),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text("Enter New Question",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                      _buildTextField("Question", questionController),
                      _buildTextField("Option A", optionAController),
                      _buildTextField("Option B", optionBController),
                      _buildTextField("Option C", optionCController),
                      _buildTextField("Option D", optionDController),
                      _buildTextField(
                          "Correct Answer (must match one option)", correctAnswerController),
                      SizedBox(height: 30),
                      ElevatedButton.icon(
                        onPressed: uploadQuestion,
                        icon: Icon(Icons.upload),
                        label: Text('Upload'),
                        style: ElevatedButton.styleFrom(
                          padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          backgroundColor: Colors.deepPurpleAccent,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: (value) => value!.isEmpty ? 'Required field' : null,
      ),
    );
  }
}
