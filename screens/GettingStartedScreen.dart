import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mihir/ExamApp.dart';
import 'package:mihir/screens/Register.dart';

import '../screens/LoginScreen.dart';
import '../slide.dart';
import '../widgets/SlideDots.dart';
import '../widgets/SlideItem.dart';



class GettingStartedScreen extends StatefulWidget {
  const GettingStartedScreen({super.key});

  @override
  State<GettingStartedScreen> createState() => _GettingStartedScreenState();
}

class _GettingStartedScreenState extends State<GettingStartedScreen> {
  int _currentPage = 0;
  late final PageController _pageController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < slideList.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (mounted) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: slideList.length,
                    itemBuilder: (ctx, i) => SlideItem(i),
                  ),
                  Positioned(
                    bottom: 35,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        slideList.length,
                            (i) => SlideDots(i == _currentPage),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(Register.routeName);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,         //  Green button
                    foregroundColor: Colors.white,
                    elevation: 5,
                    shadowColor: Colors.greenAccent,    //  Light green shadow
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Getting Started',
                    style: TextStyle(fontSize: 18),
                  ),
                ),

                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Have an account?',
                      style: TextStyle(fontSize: 16),
                    ),

                       TextButton(
                         onPressed: () {
                           Navigator.of(context).pushNamed(LoginScreen.routeName);
                           // your action
                         },
                           style: ElevatedButton.styleFrom(
                             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                           ),
                           child: const Text(
                           'Login',
                           style: TextStyle(fontSize: 16),
                           ),


                       ),

                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
