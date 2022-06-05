import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:myapp/constants/Constantcolors.dart';
import 'package:myapp/screens/AltProfile/alt_profile.dart';
import 'package:myapp/services/Authentication.dart';
import 'package:myapp/utils/PostOptions.dart';
import 'package:myapp/utils/UploadPost.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class FeedHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      backgroundColor: constantColors.darkColor.withOpacity(0.6),
      centerTitle: true,
      actions: [
        IconButton(
            onPressed: () {
              Provider.of<UploadPost>(context, listen: false)
                  .selectPostImageType(context);
            },
            icon: Icon(Icons.camera_enhance_rounded))
      ],
      title: RichText(
          text: TextSpan(
              text: 'Social  ',
              style: TextStyle(
                color: constantColors.whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
              children: <TextSpan>[
            TextSpan(
              text: 'Feed',
              style: TextStyle(
                color: constantColors.darkYellowColor,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            )
          ])),
    );
  }

  Widget feedBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .orderBy('time', descending: true)
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
                return loadPosts(context, snapshot);
              }
            },
          ),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: constantColors.darkColor.withOpacity(0.6),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18), topRight: Radius.circular(18))),
        ),
      ),
    );
  }

  Widget loadPosts(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    return ListView(
        children: (snapshot.data! as QuerySnapshot)
            .docs
            .map((DocumentSnapshot documentSnapshot) {
      Provider.of<PostFunctions>(context, listen: false)
          .showTimeAgo(documentSnapshot.get('time'));
      return Container(
        height: MediaQuery.of(context).size.height * 0.62,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (documentSnapshot.get('useruid') !=
                        Provider.of<Authentication>(context, listen: false)
                            .getUserUid) {
                      Navigator.pushReplacement(
                          context,
                          PageTransition(
                              child: AltProfile(
                                userUid: documentSnapshot.get('useruid'),
                              ),
                              type: PageTransitionType.bottomToTop));
                    }
                  },
                  child: CircleAvatar(
                    backgroundColor: constantColors.blueGreyColor,
                    radius: 20.0,
                    backgroundImage:
                        NetworkImage(documentSnapshot.get('userimage')),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          documentSnapshot.get('caption'),
                          style: TextStyle(
                            color: constantColors.greenColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      Container(
                          child: RichText(
                        text: TextSpan(
                            text: documentSnapshot.get('username'),
                            style: TextStyle(
                              color: constantColors.blueColor,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                      ' , ${Provider.of<PostFunctions>(context, listen: false).getImageTimePosted.toString()}',
                                  style: TextStyle(
                                      color: constantColors.lightColor
                                          .withOpacity(0.8)))
                            ]),
                      )),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * .2,
                  height: MediaQuery.of(context).size.height * 0.05,
                  color: constantColors.blueColor,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .doc(documentSnapshot.get('caption'))
                        .collection('awards')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return new ListView(
                          scrollDirection: Axis.horizontal,
                          children: (snapshot.data! as QuerySnapshot)
                              .docs
                              .map((DocumentSnapshot documentSnapshot) {
                            return Container(
                              height: 30.0,
                              width: 30.0,
                              child:
                                  Image.network(documentSnapshot.get('award')),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                )
              ],
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.46,
              width: MediaQuery.of(context).size.width,
              child: FittedBox(
                child:
                    Image.network(documentSnapshot.get('postimage'), scale: 2),
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
                                  color: constantColors.whiteColor,
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
                                  color: constantColors.whiteColor,
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
                        onLongPress: () {
                          Provider.of<PostFunctions>(context, listen: false)
                              .showAwardsPresenter(
                                  context, documentSnapshot.get('caption'));
                        },
                        onTap: () {
                          Provider.of<PostFunctions>(context, listen: false)
                              .showRewards(
                                  context, documentSnapshot.get('caption'));
                        },
                        child: Icon(
                          FontAwesomeIcons.award,
                          color: constantColors.yellowColor,
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
                                  color: constantColors.whiteColor,
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
                        onPressed: () {
                          Provider.of<PostFunctions>(context, listen: false)
                              .showPostOptions(
                                  context, documentSnapshot.get('caption'));
                        },
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
    }).toList());
  }
}
