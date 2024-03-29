import 'package:flutter/material.dart';
import 'package:myapp/constants/Constantcolors.dart';
import 'package:myapp/screens/LandingPage/landingHelpers.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  // const LandingPage({ Key? key }) : super(key: key);

  ConstantColors constantColors = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.whiteColor,
      body: Stack(
        children: [
          bodyColors(),
          Provider.of<LandingHelpers>(context, listen: false).bodyImage(context),
          Provider.of<LandingHelpers>(context, listen: false).taglineText(context),
          Provider.of<LandingHelpers>(context, listen: false).mainButton(context)
        ],
      ),
    );
  }
  bodyColors(){
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [
            0.5,0.9
          ],
          colors: [
            constantColors.lightBlueColor,
            constantColors.whiteColor,
          ]
        )
      ),
    );
  }
}