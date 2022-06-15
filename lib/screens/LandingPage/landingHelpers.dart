import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myapp/constants/Constantcolors.dart';
import 'package:myapp/screens/HomePage/Homepage.dart';
import 'package:myapp/screens/LandingPage/landingServices.dart';
import 'package:myapp/screens/LandingPage/landingUtils.dart';
import 'package:myapp/services/Authentication.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class LandingHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  Widget bodyImage(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.075),
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/logo.png'))),
    );
  }

  Widget taglineText(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 100, left: 50),
        constraints: BoxConstraints(maxWidth: 170.0),
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
                    color: Colors.amber,
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
              ]),
        ),
      ),
    );
  }

  Widget mainButton(BuildContext context) {
    return Positioned(
        top: MediaQuery.of(context).size.height * 0.85,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            GestureDetector(
              onTap: () {
                Provider.of<Authentication>(context, listen: false)
                    .signInWithGoogle(context);
              },
              child: Container(
                child: Icon(
                  FontAwesomeIcons.google,
                  color: constantColors.blueColor,
                ),
                width: 80.0,
                decoration: BoxDecoration(
                    border: Border.all(color: constantColors.blueColor),
                    borderRadius: BorderRadius.circular(10.0)),
              ),
            ),
            GestureDetector(
              child: Container(
                child: Icon(
                  FontAwesomeIcons.facebook,
                  color: constantColors.redColor,
                ),
                width: 80.0,
                decoration: BoxDecoration(
                    border: Border.all(color: constantColors.redColor),
                    borderRadius: BorderRadius.circular(10.0)),
              ),
            ),
            GestureDetector(
              onTap: (() {
                emailAuthSheet(context);
              }),
              child: Container(
                child: Icon(
                  EvaIcons.emailOutline,
                  color: constantColors.darkYellowColor,
                ),
                width: 80.0,
                decoration: BoxDecoration(
                    border: Border.all(color: constantColors.darkYellowColor),
                    borderRadius: BorderRadius.circular(10.0)),
              ),
            )
          ]),
        ));
  }

  Widget privacyText(BuildContext context) {
    return Positioned(
        top: 740.0,
        left: 20.0,
        right: 20.0,
        child: Container(
          child: Column(children: [
            Text("By continuing you agree the term",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
            Text(
              "By continuing you agree the term",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            )
          ]),
        ));
  }

  emailAuthSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 150.0),
                child: Divider(
                  thickness: 4.0,
                  color: constantColors.whiteColor,
                ),
              ),
              Provider.of<LandingServices>(context, listen: false).passwordLessSignIn(context),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                      color: constantColors.blueColor,
                      child: Text('Log in',
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold)),
                      onPressed: () {
                        Provider.of<LandingServices>(context, listen: false).loginSheet(context);
                      }),
                      MaterialButton(
                      color: constantColors.redColor,
                      child: Text('Sign up',
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold)),
                      onPressed: () {
                        Provider.of<LandingUltis>(context, listen: false).selectAvatarOptionsSheet(context);
                      })
                ],
              )
            ]),
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0))),
          );
        });
  }
}
