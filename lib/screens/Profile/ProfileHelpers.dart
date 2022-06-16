import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:myapp/constants/Constantcolors.dart';
import 'package:myapp/screens/Feed/FeedHelpers.dart';
import 'package:myapp/screens/LandingPage/landingPage.dart';
import 'package:myapp/services/Authentication.dart';
import 'package:myapp/utils/PostOptions.dart';
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
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    snapshot.data.data()['username'],
                    style: TextStyle(
                        color: constantColors.darkGreyColor,
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
                                  color: constantColors.darkGreyColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28),
                            ),
                            Flexible(
                              child: Text(
                                'Followers',
                                style: TextStyle(
                                    color: constantColors.darkGreyColor,
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
                                  color: constantColors.darkGreyColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28),
                            ),
                            Text(
                              'Following',
                              style: TextStyle(
                                  color: constantColors.darkGreyColor,
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
                                  color: constantColors.darkGreyColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28),
                            ),
                            Text(
                              'Posts',
                              style: TextStyle(
                                  color: constantColors.darkGreyColor,
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
          color: constantColors.darkGreyColor,
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
                    color: constantColors.darkYellowColor, size: 16),
                Text(
                  "Recently added ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: constantColors.darkGreyColor),
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

  Widget footerProfile(BuildContext context, dynamic documentSnapshot) {
    // Provider.of
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: CustomScrollView(slivers: [
          SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: SizedBox(
                          height: 500,
                          width: 400,
                          child: Lottie.asset('assets/animations/loading.json'),
                        ),
                      );
                    } else {
                      return loadPosts(context, snapshot,
                          Provider.of<Authentication>(context).getUserUid);
                    }
                  },
                ),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(18),
                        topRight: Radius.circular(18))),
              ),
            ),
          ),
        ]),
        // Image.asset('assets/images/empty.png'),
        // height: MediaQuery.of(context).size.height * 0.5,
        // width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: constantColors.darkColor.withOpacity(0.1),
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
                    color: constantColors.darkGreyColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold)),
            actions: [
              MaterialButton(
                  child: Text(
                    'No',
                    style: TextStyle(
                        color: constantColors.darkGreyColor,
                        decoration: TextDecoration.underline,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        decorationColor: constantColors.darkGreyColor),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              MaterialButton(
                  color: constantColors.redColor,
                  child: Text(
                    'Yes',
                    style: TextStyle(
                        color: constantColors.darkGreyColor,
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

  Widget loadPosts(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot,
      String userUid) {
    return ListView(
        children: (snapshot.data as QuerySnapshot)
            .docs
            .map((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.get('useruid') == userUid) {
        return Container(
          constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height * 0.62),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    child: CircleAvatar(
                      backgroundColor: constantColors.blueGreyColor,
                      radius: 20.0,
                      backgroundImage:
                          NetworkImage(documentSnapshot.get('userimage')),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              documentSnapshot.get('username'),
                              style: TextStyle(
                                color: constantColors.blueColor,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                              child: RichText(
                            text: TextSpan(
                                style: TextStyle(
                                  color: constantColors.blueColor,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: '12 giờ trước',
                                      style: TextStyle(
                                          color: constantColors.darkGreyColor
                                              .withOpacity(0.8)))
                                ]),
                          )),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                child: Container(
                  child: Text(
                    documentSnapshot.get('caption'),
                    style: TextStyle(
                      color: constantColors.darkGreyColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.46,
                width: MediaQuery.of(context).size.width,
                child: CarouselSlider(
                  items: [...documentSnapshot.get('postimage')]
                      .map((e) => Image.network(
                            e,
                            scale: 2,
                            fit: BoxFit.contain,
                          ))
                      .toList(),
                  options: CarouselOptions(
                      autoPlay: false, enableInfiniteScroll: false),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 80.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onLongPress: () {
                            Provider.of<PostFunctions>(context, listen: false)
                                .showLikes(
                                    context, documentSnapshot.get('caption'));
                          },
                          onTap: () {
                            print('Adding like ...');
                            Provider.of<PostFunctions>(context, listen: false)
                                .addLike(
                                    context,
                                    documentSnapshot.get('caption'),
                                    Provider.of<Authentication>(context,
                                            listen: false)
                                        .getUserUid);
                          },
                          child: Icon(
                            FontAwesomeIcons.heart,
                            color: constantColors.redColor,
                            size: 22.0,
                          ),
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('posts')
                              .doc(documentSnapshot.get('caption'))
                              .collection('likes')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else {
                              return Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  snapshot.data!.docs.length.toString(),
                                  style: TextStyle(
                                    color: constantColors.darkGreyColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                              );
                            }
                          },
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: 80.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Provider.of<PostFunctions>(context, listen: false)
                                .showCommentsSheet(context, documentSnapshot,
                                    documentSnapshot.get('caption'));
                          },
                          child: Icon(
                            FontAwesomeIcons.comment,
                            color: constantColors.blueColor,
                            size: 22.0,
                          ),
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('posts')
                              .doc(documentSnapshot.get('caption'))
                              .collection('comments')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else {
                              return Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  snapshot.data!.docs.length.toString(),
                                  style: TextStyle(
                                    color: constantColors.darkGreyColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                              );
                            }
                          },
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: 80.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Provider.of<PostFunctions>(context, listen: false)
                                .showRewards(
                                    context, documentSnapshot.get('caption'));
                          },
                          child: Icon(
                            FontAwesomeIcons.award,
                            color: constantColors.darkYellowColor,
                            size: 22.0,
                          ),
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('posts')
                              .doc(documentSnapshot.get('caption'))
                              .collection('awards')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else {
                              return Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  snapshot.data!.docs.length.toString(),
                                  style: TextStyle(
                                    color: constantColors.darkGreyColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                              );
                            }
                          },
                        )
                      ],
                    ),
                  ),
                  Spacer(),
                  Provider.of<Authentication>(context, listen: false)
                              .getUserUid ==
                          documentSnapshot.get('useruid')
                      ? IconButton(
                          icon: Icon(
                            EvaIcons.moreVertical,
                            color: constantColors.whiteColor,
                          ),
                          onPressed: () {},
                        )
                      : Container(
                          width: 0.0,
                          height: 0.0,
                        )
                ],
              ),
            ],
          ),
        );
      } else {
        return Container();
      }
    }).toList());
  }
}
