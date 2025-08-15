import 'package:flutter/material.dart';

class Slide {
  final String imageUrl;
  final String title;
  final String description;

  const Slide({
    required this.imageUrl,
    required this.title,
    required this.description,
  });
}

final slideList = [
  Slide(
    imageUrl: 'assets/image1.webp',
    title: 'Ace Your Exams with Confidence',
    description: 'Practice smart, not hard. Get access to quality quizzes, instant feedback, and performance tracking — all in one app!',
  ),
  Slide(
    imageUrl: 'assets/image2.webp',
    title: 'Know Your Strengths',
    description: 'Get instant scores, see your performance trends, and focus on weak areas. Boost your score with real-time analytics.',
  ),
  Slide(
    imageUrl: 'assets/image3.png',
    title: 'Let’s Begin!',
    description: 'Join thousands of learners improving every day. Start your journey to success now!',
  ),
];