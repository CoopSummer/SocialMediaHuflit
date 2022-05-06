import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myapp/constants/Constantcolors.dart';
import 'package:myapp/screens/LandingPage/landingPage.dart';
import 'package:myapp/services/Authentication.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class ProfileHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  Widget headerProfile(BuildContext context, dynamic snapshot) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 200.0,
            width: MediaQuery.of(context).size.width*0.25,
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
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    snapshot.data.data()['username'],
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.06),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15)),
                        height: 70,
                        width: MediaQuery.of(context).size.width*0.2,
                        child: Column(
                          children: [
                            Text(
                              '0',
                              style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28),
                            ),
                            Flexible(
                              child: Text(
                                'Followers',
                                style: TextStyle(
                                    color: constantColors.whiteColor,
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
                        width: MediaQuery.of(context).size.width*0.2,
                        child: Column(
                          children: [
                            Text(
                              '0',
                              style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28),
                            ),
                            Text(
                              'Following',
                              style: TextStyle(
                                  color: constantColors.whiteColor,
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
                        width: MediaQuery.of(context).size.width*0.2,
                        child: Column(
                          children: [
                            Text(
                              '0',
                              style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28),
                            ),
                            Text(
                              'Posts',
                              style: TextStyle(
                                  color: constantColors.whiteColor,
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
          color: constantColors.whiteColor,
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
                      color: constantColors.whiteColor),
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

  logOutDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: constantColors.darkColor,
            title: Text('Log out of Huflit Social ?',
                style: TextStyle(
                    color: constantColors.whiteColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold)),
            actions: [
              MaterialButton(
                  child: Text(
                    'No',
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        decoration: TextDecoration.underline,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        decorationColor: constantColors.whiteColor),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              MaterialButton(
                  color: constantColors.redColor,
                  child: Text(
                    'Yes',
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Provider.of<Authentication>(context, listen: false)
                        .logOutViaEmail()
                        .whenComplete(() => Navigator.pushReplacement(
                            context,
                            PageTransition(
                                child: LandingPage(),
                                type: PageTransitionType.bottomToTop)));
                  })
            ],
          );
        });
  }
}
