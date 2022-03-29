import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:myapp/constants/Constantcolors.dart';
import 'package:myapp/services/Authentication.dart';
import 'package:myapp/utils/UploadPost.dart';
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
            stream: FirebaseFirestore.instance.collection('posts').snapshots(),
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
                                  text: ', 12 giờ trước',
                                  style: TextStyle(
                                      color: constantColors.lightColor
                                          .withOpacity(0.8)))
                            ]),
                      )),
                    ],
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
                        child: Icon(
                          FontAwesomeIcons.heart,
                          color: constantColors.redColor,
                          size: 22.0,
                        ),
                      ),
                      Text(
                        '0',
                        style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
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
                        child: Icon(
                          FontAwesomeIcons.comment,
                          color: constantColors.blueColor,
                          size: 22.0,
                        ),
                      ),
                      Text(
                        '0',
                        style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
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
                        child: Icon(
                          FontAwesomeIcons.award,
                          color: constantColors.yellowColor,
                          size: 22.0,
                        ),
                      ),
                      Text(
                        '0',
                        style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
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
    }).toList());
  }
}
