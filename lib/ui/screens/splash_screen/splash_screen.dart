import 'dart:async';
import 'package:exam4/ui/screens/login_register_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return const LoginScreen();
        },
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              child: SvgPicture.asset(
                "assets/images/tadiro.svg",
                width: 150,
                height: 200,
              ),
            ),
          ),
          Text(
            "Tadbiro",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 45,
              color: Colors.amber.shade900,
            ),
          )
        ],
      ),
    );
  }
}
