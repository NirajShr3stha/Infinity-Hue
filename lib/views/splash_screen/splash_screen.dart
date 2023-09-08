import 'dart:math';
import 'package:ai_diffusion/views/home_page.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1600), () {
      setState(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Homepage(),
          ),
        );
      });
    });
  }

//change color each time app opens 
//random color 
//rework later on
  @override
  Widget build(BuildContext context) {
    final Random random = Random();
    final Color backgroundColor = Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Image.asset(
          'assets/logo.png',
          height: 345,
          width: 345,
        ),
      ),
    );
  }
}
