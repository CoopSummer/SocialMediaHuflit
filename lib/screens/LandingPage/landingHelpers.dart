import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myapp/constants/Constantcolors.dart';

class LandingHelpers with ChangeNotifier{
  ConstantColors constantColors= ConstantColors();
  Widget bodyImage(BuildContext context){
    return Container(
      height: MediaQuery.of(context).size.height*0.65,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/login.png'))
      ),
    );
  }

  Widget taglineText(BuildContext context){
    return Positioned(
      top: 450.0,
      left: 10.0,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 170.0
        ),
        child: RichText(
          text: TextSpan(
            text: 'Are',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: constantColors.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
            ),
            children: <TextSpan>[
              TextSpan(
                text: 'You ',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: constantColors.blueColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 34.0,
              ),
              ),
              TextSpan(
                text: 'Social ',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: constantColors.whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 34.0,
              ),
              ),
                            TextSpan(
                text: '?',
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
      ));
  }
  
  Widget mainButton(BuildContext context){
    return Positioned(
      top: 630.0,

      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              child: Container(
                child: Icon(FontAwesomeIcons.google, color: constantColors.blueColor,),
                width: 80.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: constantColors.blueColor
                  ),
                  borderRadius: BorderRadius.circular(10.0)
                ),
              ),
            ),
            GestureDetector(
              child: Container(
                child: Icon(FontAwesomeIcons.facebook, color: constantColors.redColor,),
                width: 80.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: constantColors.redColor
                  ),
                  borderRadius: BorderRadius.circular(10.0)
                ),
              ),
            ),
            GestureDetector(
              child: Container(
                child: Icon(EvaIcons.emailOutline, color: constantColors.yellowColor,),
                width: 80.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: constantColors.yellowColor
                  ),
                  borderRadius: BorderRadius.circular(10.0)
                ),
              ),
            )
          ]
        ),)); 
  }
}