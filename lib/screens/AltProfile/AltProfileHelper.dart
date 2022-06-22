import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myapp/constants/Constantcolors.dart';
import 'package:myapp/screens/HomePage/Homepage.dart';
import 'package:page_transition/page_transition.dart';

class AltProfileHelper with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  appBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_rounded),
        color: constantColors.whiteColor,
        onPressed: () {
          Navigator.pushReplacement(
              context,
              PageTransition(
                  child: Homepage(), type: PageTransitionType.bottomToTop));
        },
      ),
      backgroundColor: constantColors.blueGreyColor.withOpacity(0.4),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            EvaIcons.moreVertical,
            color: constantColors.whiteColor,
          ),
          color: constantColors.whiteColor,
          onPressed: () {
            Navigator.pushReplacement(
                context,
                PageTransition(
                    child: Homepage(), type: PageTransitionType.bottomToTop));
          },
        ),
      ],
      title: RichText(
          text: TextSpan(
              text: 'The',
              style: TextStyle(
                  color: constantColors.whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
              children: <TextSpan>[
            TextSpan(
                text: 'Social',
                style: TextStyle(
                    color: constantColors.blueColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0))
          ])),
    );
  }

  Widget headerProfile(BuildContext context, dynamic snapshot, String userUid) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.18,
                width: MediaQuery.of(context).size.width * 0.25,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: CircleAvatar(
                        backgroundColor: constantColors.transparent,
                        radius: 60.0,
                        backgroundImage:
                            NetworkImage(snapshot.data.data()['userimage']),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.18,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.06),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15)),
                            height: 70,
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: Column(
                              children: [
                                Text(
                                  '0',
                                  style: TextStyle(
                                      color: constantColors.darkColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28),
                                ),
                                Flexible(
                                  child: Text(
                                    'Followers',
                                    style: TextStyle(
                                        color: constantColors.darkColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15)),
                            height: 70,
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: Column(
                              children: [
                                Text(
                                  '0',
                                  style: TextStyle(
                                      color: constantColors.darkColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28),
                                ),
                                Text(
                                  'Following',
                                  style: TextStyle(
                                      color: constantColors.darkColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                )
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15)),
                            height: 70,
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: Column(
                              children: [
                                Text(
                                  '0',
                                  style: TextStyle(
                                      color: constantColors.darkColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28),
                                ),
                                Text(
                                  'Posts',
                                  style: TextStyle(
                                      color: constantColors.darkColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 30),
            child: Text(
              snapshot.data.data()['username'],
              style: TextStyle(
                  color: constantColors.darkColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon(EvaIcons.email, color: constantColors.greenColor),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    snapshot.data.data()['useremail'],
                    style: TextStyle(
                        color: constantColors.darkColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget divider() {
    return Center(
      child: SizedBox(
        height: 25.0,
        width: 350.0,
        child: Divider(
          color: constantColors.darkColor,
        ),
      ),
    );
  }

  Widget middleProfile(BuildContext context, dynamic snapshot) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 150.0,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(2.0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(FontAwesomeIcons.userAstronaut,
                    color: constantColors.yellowColor, size: 16),
                Text(
                  "Recently added ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: constantColors.darkColor),
                )
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.darkColor.withOpacity(0.4),
                borderRadius: BorderRadius.circular(15.0)),
          )
        ],
      ),
    );
  }

  Widget footerProfile(BuildContext context, dynamic snapshot) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Image.asset('assets/images/empty.png'),
        height: MediaQuery.of(context).size.height * 0.5,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: constantColors.darkColor.withOpacity(0.4),
            borderRadius: BorderRadius.circular(5.0)),
      ),
    );
  }
}


// Padding(
//                   padding: const EdgeInsets.only(top: 8.0),
//                   child: Text(
//                     snapshot.data.data()['username'],
//                     style: TextStyle(
//                         color: constantColors.darkColor,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16.0),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(EvaIcons.email, color: constantColors.greenColor),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 8),
//                         child: Text(
//                           snapshot.data.data()['useremail'],
//                           style: TextStyle(
//                               color: constantColors.darkColor,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16.0),
//                         ),
//                       ),
//                     ],
//                   ),
//                 )