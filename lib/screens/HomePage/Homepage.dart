import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/constants/Constantcolors.dart';

class Homepage extends StatelessWidget {
  ConstantColors constantColors = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.redColor,
    );
  }
}