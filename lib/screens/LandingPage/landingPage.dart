import 'package:flutter/material.dart';
import 'package:myapp/constants/Constantcolors.dart';

class LandingPage extends StatelessWidget {
  // const LandingPage({ Key? key }) : super(key: key);

  ConstantColors constantColors = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.whiteColor,
    );
  }
}