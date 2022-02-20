import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myapp/constants/Constantcolors.dart';
import 'package:myapp/screens/LandingPage/landingPage.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  ConstantColors constantColors = ConstantColors();
  @override
  void initState() {
    // TODO: implement initState
    Timer(
      Duration(seconds: 1), 
      ()=>Navigator.pushReplacement(context, PageTransition(child: LandingPage(), type: PageTransitionType.leftToRight))
      );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      body: Center(
        child: RichText(
          text: TextSpan(
            text: 'The',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: constantColors.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
            ),
            children: <TextSpan>[
              TextSpan(
                text: 'SocialHuflit',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: constantColors.blueColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 34.0,
              ),
              )
            ]
          ),
        ),
      ),
    );
  }
}