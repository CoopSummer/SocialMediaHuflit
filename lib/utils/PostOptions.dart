import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myapp/constants/Constantcolors.dart';
import 'package:myapp/screens/AltProfile/alt_profile.dart';
import 'package:myapp/services/Authentication.dart';
import 'package:myapp/services/FirebaseOperations.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostFunctions with ChangeNotifier {
  TextEditingController commentController = TextEditingController();
  TextEditingController updatedCaptionController = TextEditingController();
  ConstantColors constantColors = ConstantColors();
  late String imageTimePosted;
  String get getImageTimePosted => imageTimePosted;
  showTimeAgo(dynamic timedata) {
    Timestamp time = timedata;
    DateTime dataTime = time.toDate();
    imageTimePosted = timeago.format(dataTime);
    print(imageTimePosted);
    notifyListeners();
  }

  showPostOptions(BuildContext context, String postId) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Container(
                                  child: Center(
                                      child: Row(
                                    children: [
                                      Container(
                                        width: 300.0,
                                        height: 50.0,
                                        child: TextField(
                                          decoration: InputDecoration(
                                              hintText: 'Add New Caption',
                                              hintStyle: TextStyle(
                                                  color:
                                                      constantColors.whiteColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.0)),
                                          controller: updatedCaptionController,
                                        ),
                                      ),
                                      FloatingActionButton(
                                        onPressed: () {
                                          Provider.of<FirebaseOperations>(
                                                  context,
                                                  listen: false)
                                              .updateCaption(postId, {
                                            'caption':
                                                updatedCaptionController.text
                                          });
                                        },
                                        backgroundColor:
                                            constantColors.redColor,
                                        child: Icon(
                                          FontAwesomeIcons.fileUpload,
                                          color: constantColors.whiteColor,
                                        ),
                                      )
                                    ],
                                  )),
                                );
                              });
                        },
                        child: Text(
                          'Edit Caption',
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                        ),
                      ),
                      MaterialButton(
                        color: constantColors.redColor,
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: constantColors.darkColor,
                                  title: Text(
                                    'Delete This Post ?',
                                    style: TextStyle(
                                        color: constantColors.whiteColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0),
                                  ),
                                  actions: [
                                    MaterialButton(
                                      color: constantColors.darkColor,
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'No',
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor:
                                                constantColors.whiteColor,
                                            color: constantColors.whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0),
                                      ),
                                    ),
                                    MaterialButton(
                                      color: constantColors.redColor,
                                      onPressed: () {
                                        Provider.of<FirebaseOperations>(context,
                                                listen: false)
                                            .deleteUserData(postId, 'posts')
                                            .whenComplete(() {
                                          Navigator.pop(context);
                                        });
                                      },
                                      child: Text(
                                        'Yes',
                                        style: TextStyle(
                                            color: constantColors.whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0),
                                      ),
                                    ),
                                  ],
                                );
                              });
                        },
                        child: Text(
                          'Delete Post',
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                        ),
                      ),
                    ],
                  ),
                )
              ]),
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: constantColors.blueColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0))),
            ),
          );
        });
  }

  Future addLike(BuildContext context, String PostId, String subDocId) async {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(PostId)
        .collection('likes')
        .doc(subDocId)
        .set({
      'likes': FieldValue.increment(1),
      'username': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserName,
      'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
      'userimage': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserImage,
      'useremail': Provider.of<FirebaseOperations>(context, listen: false)
          .getInItUserEmail,
      'time': Timestamp.now(),
    });
  }

  Future addComment(BuildContext context, String postId, String comment) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(comment)
        .set({
      'comment': comment,
      'username': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserName,
      'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
      'userimage': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserImage,
      'useremail': Provider.of<FirebaseOperations>(context, listen: false)
          .getInItUserEmail,
      'time': Timestamp.now(),
    });
  }

  showAwardsPresenter(BuildContext context, String postId) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(
                  thickness: 4.0,
                  color: constantColors.whiteColor,
                ),
              ),
              Container(
                width: 200.0,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: constantColors.whiteColor,
                    ),
                    borderRadius: BorderRadius.circular(5.0)),
                child: Center(
                  child: Text(
                    'Award Socialites',
                    style: TextStyle(
                        color: constantColors.blueColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .doc(postId)
                        .collection('awards')
                        .orderBy('time')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return new ListView(
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot documentSnapshot) {
                          return ListTile(
                            leading: GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                        child: AltProfile(
                                            userUid: documentSnapshot
                                                .get('useruid')),
                                        type: PageTransitionType.bottomToTop));
                              },
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    documentSnapshot.get('userimage')),
                                radius: 15.0,
                                backgroundColor: constantColors.darkColor,
                              ),
                            ),
                            trailing: Provider.of<Authentication>(context,
                                            listen: false)
                                        .getUserUid ==
                                    documentSnapshot.get('useruid')
                                ? Container(
                                    width: 0.0,
                                    height: 0.0,
                                  )
                                : MaterialButton(
                                    child: Text(
                                      'follow',
                                      style: TextStyle(
                                          color: constantColors.whiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                    onPressed: () {},
                                    color: constantColors.blueColor,
                                  ),
                            title: Text(
                              documentSnapshot.get('username'),
                              style: TextStyle(
                                  color: constantColors.blueColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0),
                            ),
                          );
                        }).toList());
                      }
                    },
                  ))
            ]),
            decoration: BoxDecoration(
                color: constantColors.blueColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                )),
          );
        });
  }

  showCommentsSheet(
      BuildContext context, DocumentSnapshot snapshot, String docId) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Divider(
                        thickness: 4.0,
                        color: constantColors.whiteColor,
                      ),
                    ),
                    Container(
                      width: 100.0,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: constantColors.whiteColor,
                          ),
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Center(
                        child: Text(
                          'Comments',
                          style: TextStyle(
                              color: constantColors.blueColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.53,
                      width: MediaQuery.of(context).size.width,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('posts')
                            .doc(docId)
                            .collection('comments')
                            .orderBy('time')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return ListView(
                                children: snapshot.data!.docs.map<Widget>(
                                    (DocumentSnapshot documentSnapshot) {
                              return Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.17,
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0, left: 8),
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.pushReplacement(
                                                      context,
                                                      PageTransition(
                                                          child: AltProfile(
                                                              userUid:
                                                                  documentSnapshot
                                                                      .get(
                                                                          'useruid')),
                                                          type:
                                                              PageTransitionType
                                                                  .bottomToTop));
                                                },
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      constantColors.darkColor,
                                                  radius: 15.0,
                                                  backgroundImage: NetworkImage(
                                                      documentSnapshot
                                                          .get('userimage')),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Container(
                                                  child: Text(
                                                documentSnapshot
                                                    .get('username'),
                                                style: TextStyle(
                                                    color: constantColors
                                                        .whiteColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.0),
                                              )),
                                            ),
                                            Container(
                                              child: Row(
                                                children: [
                                                  IconButton(
                                                      onPressed: () {},
                                                      icon: Icon(
                                                        FontAwesomeIcons
                                                            .arrowUp,
                                                        color: constantColors
                                                            .blueColor,
                                                        size: 16,
                                                      )),
                                                  Text(
                                                    '0',
                                                    style: TextStyle(
                                                        color: constantColors
                                                            .whiteColor,
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  IconButton(
                                                      onPressed: () {},
                                                      icon: Icon(
                                                        FontAwesomeIcons.reply,
                                                        color: constantColors
                                                            .yellowColor,
                                                        size: 12,
                                                      )),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {},
                                                icon: Icon(
                                                  Icons
                                                      .arrow_forward_ios_outlined,
                                                  color:
                                                      constantColors.blueColor,
                                                  size: 16.0,
                                                ),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.75,
                                                // height: MediaQuery.of(context).size.height,
                                                child: Text(
                                                  documentSnapshot
                                                      .get('comment'),
                                                  style: TextStyle(
                                                      color: constantColors
                                                          .whiteColor,
                                                      fontSize: 16),
                                                ),
                                              ),
                                              IconButton(
                                                  onPressed: () {},
                                                  icon: Icon(
                                                    FontAwesomeIcons.trashAlt,
                                                    color:
                                                        constantColors.redColor,
                                                    size: 16,
                                                  )),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          color: constantColors.darkColor
                                              .withOpacity(0.2),
                                        )
                                      ]));
                            }).toList());
                          }
                        },
                      ),
                    ),
                    Container(
                      width: 400,
                      height: 40.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 300.0,
                            height: 20.0,
                            child: TextField(
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                  hintText: 'Add comment ....',
                                  hintStyle: TextStyle(
                                      color: constantColors.whiteColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              controller: commentController,
                              style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          FloatingActionButton(
                            onPressed: () {
                              print('Adding comment ... ');
                              addComment(context, snapshot.get('caption'),
                                      commentController.text)
                                  .whenComplete(() {
                                commentController.clear();
                                notifyListeners();
                              });
                            },
                            child: Icon(
                              FontAwesomeIcons.comment,
                              color: constantColors.whiteColor,
                            ),
                            backgroundColor: constantColors.greenColor,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              decoration: BoxDecoration(
                  color: constantColors.blueGreyColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0))),
            ),
          );
        });
  }

  showLikes(BuildContext context, String PostId) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                Container(
                  width: 100.0,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: constantColors.whiteColor,
                      ),
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Center(
                    child: Text(
                      'Likes',
                      style: TextStyle(
                          color: constantColors.blueColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  height: 200,
                  width: 400,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .doc(PostId)
                        .collection('likes')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return new ListView(
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot documentSnapshot) {
                            return ListTile(
                              leading: GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      PageTransition(
                                          child: AltProfile(
                                              userUid: documentSnapshot
                                                  .get('useruid')),
                                          type:
                                              PageTransitionType.bottomToTop));
                                },
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      documentSnapshot.get('userimage')),
                                ),
                              ),
                              title: Text(
                                documentSnapshot.get('username'),
                                style: TextStyle(
                                    color: constantColors.blueColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              subtitle: Text(
                                documentSnapshot.get('useremail'),
                                style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                              trailing: Provider.of<Authentication>(context,
                                              listen: false)
                                          .getUserUid ==
                                      documentSnapshot.get('useruid')
                                  ? Container(
                                      width: 0.0,
                                      height: 0.0,
                                    )
                                  : MaterialButton(
                                      child: Text(
                                        'follow',
                                        style: TextStyle(
                                            color: constantColors.whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                      onPressed: () {},
                                      color: constantColors.blueColor,
                                    ),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                )
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                )),
          );
        });
  }

  showRewards(BuildContext context, String postId) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                )),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                Container(
                  width: 100.0,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: constantColors.whiteColor,
                      ),
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Center(
                    child: Text(
                      'Rewards',
                      style: TextStyle(
                          color: constantColors.blueColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('awards')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          return ListView(
                            scrollDirection: Axis.horizontal,
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot documentSnapshot) {
                              return GestureDetector(
                                onTap: () async {
                                  print(documentSnapshot.get('image'));
                                  await Provider.of<FirebaseOperations>(context,
                                          listen: false)
                                      .addAward(postId, {
                                    'username': Provider.of<FirebaseOperations>(
                                            context,
                                            listen: false)
                                        .getInitUserName,
                                    'userimage':
                                        Provider.of<FirebaseOperations>(context,
                                                listen: false)
                                            .getInitUserImage,
                                    'useruid': Provider.of<Authentication>(
                                            context,
                                            listen: false)
                                        .getUserUid,
                                    'time': Timestamp.now(),
                                    'award': documentSnapshot.get('image')
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    child: Image.network(
                                        documentSnapshot.get('image')),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
