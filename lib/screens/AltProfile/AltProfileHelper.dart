import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:myapp/constants/Constantcolors.dart';
import 'package:myapp/screens/AltProfile/AltProfile.dart';
import 'package:myapp/screens/ChatRoom/ChatroomHelpers.dart';
import 'package:myapp/screens/HomePage/Homepage.dart';
import 'package:myapp/screens/PostDetail/PostDetail.dart';
import 'package:myapp/services/Authentication.dart';
import 'package:myapp/services/FirebaseOperations.dart';
import 'package:myapp/utils/PostOptions.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class AltProfileHelper with ChangeNotifier {
  var postCounting;
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
      height: MediaQuery.of(context).size.height * 0.4,
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
                          GestureDetector(
                            onTap: () {
                              checkFollowerSheet(context, snapshot);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15)),
                              height: 70,
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: Column(
                                children: [
                                  StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(snapshot.data.data()['useruid'])
                                          .collection('followers')
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        } else {
                                          return Text(
                                            snapshot.data!.docs.length
                                                .toString(),
                                            style: TextStyle(
                                                color: constantColors.darkColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 28),
                                          );
                                        }
                                      }),
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
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15)),
                            height: 70,
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: Column(
                              children: [
                                StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(snapshot.data.data()['useruid'])
                                        .collection('following')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      } else {
                                        return Text(
                                          snapshot.data!.docs.length.toString(),
                                          style: TextStyle(
                                              color: constantColors.darkColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 28),
                                        );
                                      }
                                    }),
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
                                  postCounting.toString(),
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
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(
                style: ButtonStyle(
                    side: MaterialStateProperty.all(BorderSide(
                        width: 1.5,
                        color: constantColors.lightGreyColor,
                        style: BorderStyle.solid))),
                onPressed: () {
                  Provider.of<FirebaseOperations>(context, listen: false)
                      .followUser(
                          userUid,
                          Provider.of<Authentication>(context, listen: false)
                              .getUserUid,
                          {
                            'username': Provider.of<FirebaseOperations>(context,
                                    listen: false)
                                .getInitUserName,
                            'userimage': Provider.of<FirebaseOperations>(
                                    context,
                                    listen: false)
                                .getInitUserImage,
                            'useremail': Provider.of<FirebaseOperations>(
                                    context,
                                    listen: false)
                                .getInItUserEmail,
                            'useruid': Provider.of<Authentication>(context,
                                    listen: false)
                                .getUserUid,
                            'time': Timestamp.now()
                          },
                          Provider.of<Authentication>(context, listen: false)
                              .getUserUid,
                          userUid,
                          {
                            'username': snapshot.data.data()['username'],
                            'userimage': snapshot.data.data()['userimage'],
                            'useremail': snapshot.data.data()['useremail'],
                            'useruid': snapshot.data.data()['useruid'],
                            'time': Timestamp.now()
                          })
                      .whenComplete(() {
                    followedNotification(
                        context, snapshot.data.data()['username']);
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 50, right: 50),
                  child: Text(
                    'Follow',
                    style: TextStyle(
                        color: constantColors.darkGreyColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              OutlinedButton(
                  style: ButtonStyle(
                      side: MaterialStateProperty.all(BorderSide(
                          width: 1.5,
                          color: constantColors.lightGreyColor,
                          style: BorderStyle.solid))),
                  onPressed: () {
                    Provider.of<ChatroomHeplers>(context, listen: false)
                        .createDirectMessage(context, snapshot);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 50, right: 50),
                    child: Text(
                      'Message',
                      style: TextStyle(
                          color: constantColors.darkGreyColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ))
            ],
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
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(snapshot.data.data()['useruid'])
                        .collection('following')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return ListView(
                          scrollDirection: Axis.horizontal,
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot documentSnapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  documentSnapshot.get('userimage'),
                                  height: 60,
                                  width: 60,
                                ),
                              );
                            }
                          }).toList(),
                        );
                      }
                    }),
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(documentSnapshot.data.data()['useruid'])
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
              return GridView(
                children: snapshot.data!.docs
                    .map((DocumentSnapshot documentSnapshot) {
                  return GestureDetector(
                    onTap: () {
                      showPostDetails(
                          context, documentSnapshot.get('useruid'));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        width: MediaQuery.of(context).size.width,
                        child: FittedBox(
                            child: Image.network(
                                documentSnapshot.get('postimage')[0])),
                      ),
                    ),
                  );
                }).toList(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
              );
            }
          },
        ),
        height: MediaQuery.of(context).size.height * 0.45,
        width: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            color: constantColors.darkColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(5.0)),
      ),
    );
    // return Padding(
    //   padding: const EdgeInsets.all(8.0),
    //   child: Container(
    //     child: CustomScrollView(slivers: [
    //       SliverFillRemaining(
    //         child: Padding(
    //           padding: const EdgeInsets.only(top: 8.0),
    //           child: Container(
    //             child: StreamBuilder<QuerySnapshot>(
    //               stream: FirebaseFirestore.instance
    //                   .collection('posts')
    //                   .orderBy('time', descending: true)
    //                   .snapshots(),
    //               builder: (context, snapshot) {
    //                 if (snapshot.connectionState == ConnectionState.waiting) {
    //                   return Center(
    //                     child: SizedBox(
    //                       height: 500,
    //                       width: 400,
    //                       child: Lottie.asset('assets/animations/loading.json'),
    //                     ),
    //                   );
    //                 } else {
    //                   return loadPosts(context, snapshot,
    //                       documentSnapshot.data.data()['useruid']);
    //                 }
    //               },
    //             ),
    //             height: MediaQuery.of(context).size.height,
    //             width: MediaQuery.of(context).size.width,
    //             decoration: const BoxDecoration(
    //                 borderRadius: BorderRadius.only(
    //                     topLeft: Radius.circular(18),
    //                     topRight: Radius.circular(18))),
    //           ),
    //         ),
    //       ),
    //     ]),
    //     decoration: BoxDecoration(
    //         color: constantColors.darkColor.withOpacity(0.1),
    //         borderRadius: BorderRadius.circular(5.0)),
    //   ),
    // );
  }

  Widget loadPosts(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot,
      String userUid) {
    postCounting = snapshot.data!.docs.length;
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
              FutureBuilder<dynamic>(
                  future: getUserImage(documentSnapshot.get('useruid')),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return Row(
                        children: [
                          GestureDetector(
                            child: CircleAvatar(
                              backgroundColor: constantColors.transparent,
                              radius: 20.0,
                              backgroundImage:
                                  NetworkImage(snapshot.data['userimage']),
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
                                      snapshot.data['username'],
                                      style: TextStyle(
                                        color: constantColors.blueColor,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  FutureBuilder(
                                      future: Provider.of<PostFunctions>(
                                              context,
                                              listen: false)
                                          .showTimeAgo(
                                              documentSnapshot.get('time')),
                                      builder: (context, snapshot) {
                                        return Container(
                                            child: RichText(
                                          text: TextSpan(
                                              style: TextStyle(
                                                color: constantColors.blueColor,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text: snapshot.data
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: constantColors
                                                            .darkGreyColor
                                                            .withOpacity(0.8)))
                                              ]),
                                        ));
                                      }),
                                ],
                              ),
                            ),
                          )
                        ],
                      );
                    }
                  }),
              // Padding(
              //   padding: const EdgeInsets.only(left: 8.0, top: 8.0),
              //   child: Container(
              //     child: Text(
              //       documentSnapshot.get('caption'),
              //       style: TextStyle(
              //         color: constantColors.darkGreyColor,
              //         fontWeight: FontWeight.bold,
              //         fontSize: 16.0,
              //       ),
              //     ),
              //   ),
              // ),
              // Container(
              //   height: MediaQuery.of(context).size.height * 0.46,
              //   width: MediaQuery.of(context).size.width,
              //   child: CarouselSlider(
              //     items: [...documentSnapshot.get('postimage')]
              //         .map((e) => Image.network(
              //               e,
              //               scale: 2,
              //               fit: BoxFit.contain,
              //             ))
              //         .toList(),
              //     options: CarouselOptions(
              //         autoPlay: false, enableInfiniteScroll: false),
              //   ),
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     Container(
              //       width: 80.0,
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.start,
              //         children: [
              //           GestureDetector(
              //             onLongPress: () {
              //               Provider.of<PostFunctions>(context, listen: false)
              //                   .showLikes(
              //                       context, documentSnapshot.get('caption'));
              //             },
              //             onTap: () {
              //               print('Adding like ...');
              //               Provider.of<PostFunctions>(context, listen: false)
              //                   .addLike(
              //                       context,
              //                       documentSnapshot.get('caption'),
              //                       Provider.of<Authentication>(context,
              //                               listen: false)
              //                           .getUserUid);
              //             },
              //             child: Icon(
              //               FontAwesomeIcons.heart,
              //               color: constantColors.redColor,
              //               size: 22.0,
              //             ),
              //           ),
              //           StreamBuilder<QuerySnapshot>(
              //             stream: FirebaseFirestore.instance
              //                 .collection('posts')
              //                 .doc(documentSnapshot.get('caption'))
              //                 .collection('likes')
              //                 .snapshots(),
              //             builder: (context, snapshot) {
              //               if (snapshot.connectionState ==
              //                   ConnectionState.waiting) {
              //                 return Center(child: CircularProgressIndicator());
              //               } else {
              //                 return Padding(
              //                   padding: const EdgeInsets.only(left: 8.0),
              //                   child: Text(
              //                     snapshot.data!.docs.length.toString(),
              //                     style: TextStyle(
              //                       color: constantColors.darkGreyColor,
              //                       fontWeight: FontWeight.bold,
              //                       fontSize: 18.0,
              //                     ),
              //                   ),
              //                 );
              //               }
              //             },
              //           )
              //         ],
              //       ),
              //     ),
              //     Container(
              //       width: 80.0,
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.start,
              //         children: [
              //           GestureDetector(
              //             onTap: () {
              //               Provider.of<PostFunctions>(context, listen: false)
              //                   .showCommentsSheet(context, documentSnapshot,
              //                       documentSnapshot.get('caption'));
              //             },
              //             child: Icon(
              //               FontAwesomeIcons.comment,
              //               color: constantColors.blueColor,
              //               size: 22.0,
              //             ),
              //           ),
              //           StreamBuilder<QuerySnapshot>(
              //             stream: FirebaseFirestore.instance
              //                 .collection('posts')
              //                 .doc(documentSnapshot.get('caption'))
              //                 .collection('comments')
              //                 .snapshots(),
              //             builder: (context, snapshot) {
              //               if (snapshot.connectionState ==
              //                   ConnectionState.waiting) {
              //                 return Center(child: CircularProgressIndicator());
              //               } else {
              //                 return Padding(
              //                   padding: const EdgeInsets.only(left: 8.0),
              //                   child: Text(
              //                     snapshot.data!.docs.length.toString(),
              //                     style: TextStyle(
              //                       color: constantColors.darkGreyColor,
              //                       fontWeight: FontWeight.bold,
              //                       fontSize: 18.0,
              //                     ),
              //                   ),
              //                 );
              //               }
              //             },
              //           )
              //         ],
              //       ),
              //     ),
              //     Container(
              //       width: 80.0,
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.start,
              //         children: [
              //           GestureDetector(
              //             onTap: () {
              //               Provider.of<PostFunctions>(context, listen: false)
              //                   .showRewards(
              //                       context, documentSnapshot.get('caption'));
              //             },
              //             child: Icon(
              //               FontAwesomeIcons.award,
              //               color: constantColors.darkYellowColor,
              //               size: 22.0,
              //             ),
              //           ),
              //           StreamBuilder<QuerySnapshot>(
              //             stream: FirebaseFirestore.instance
              //                 .collection('posts')
              //                 .doc(documentSnapshot.get('caption'))
              //                 .collection('awards')
              //                 .snapshots(),
              //             builder: (context, snapshot) {
              //               if (snapshot.connectionState ==
              //                   ConnectionState.waiting) {
              //                 return Center(child: CircularProgressIndicator());
              //               } else {
              //                 return Padding(
              //                   padding: const EdgeInsets.only(left: 8.0),
              //                   child: Text(
              //                     snapshot.data!.docs.length.toString(),
              //                     style: TextStyle(
              //                       color: constantColors.darkGreyColor,
              //                       fontWeight: FontWeight.bold,
              //                       fontSize: 18.0,
              //                     ),
              //                   ),
              //                 );
              //               }
              //             },
              //           )
              //         ],
              //       ),
              //     ),
              //     Spacer(),
              //     Provider.of<Authentication>(context, listen: false)
              //                 .getUserUid ==
              //             documentSnapshot.get('useruid')
              //         ? IconButton(
              //             icon: Icon(
              //               EvaIcons.moreVertical,
              //               color: constantColors.whiteColor,
              //             ),
              //             onPressed: () {},
              //           )
              //         : Container(
              //             width: 0.0,
              //             height: 0.0,
              //           )
              //   ],
              // ),
            ],
          ),
        );
      } else {
        postCounting -= 1;
        return Container();
      }
    }).toList());
  }

  getUserImage(String userUid) async {
    CollectionReference collectionReference =
        (FirebaseFirestore.instance.collection('users'));
    var data = await collectionReference.get();
    try {
      var user = data.docs.firstWhere((e) => e.get('useruid') == userUid);
      return {
        'useruid': user.get('useruid'),
        'username': user.get('username'),
        'userimage': user.get('userimage')
      };
    } catch (error) {
      return error;
    }
  }

  followedNotification(BuildContext context, String name) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
                color: constantColors.darkColor,
                borderRadius: BorderRadius.circular(12.0)),
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 150.0),
                      child: Divider(
                        thickness: 4.0,
                        color: constantColors.whiteColor,
                      ),
                    ),
                    Text(
                      'Followed $name',
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    )
                  ]),
            ),
          );
        });
  }

  checkFollowerSheet(BuildContext context, dynamic snapshot) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.circular(12.0)),
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(snapshot.data.data()['useruid'])
                    .collection('followers')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return ListView(
                      children: snapshot.data!.docs
                          .map((DocumentSnapshot documentSnapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return ListTile(
                            onTap: () {
                              if (documentSnapshot.get('useruid') !=
                                  Provider.of<Authentication>(context,
                                          listen: false)
                                      .getUserUid) {
                                Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                        child: AltProfile(
                                            userUid: documentSnapshot
                                                .get('useruid')),
                                        type: PageTransitionType.bottomToTop));
                              }
                            },
                            trailing: documentSnapshot.get('useruid') ==
                                    Provider.of<Authentication>(context,
                                            listen: false)
                                        .getUserUid
                                ? Container(
                                    width: 0,
                                    height: 0,
                                  )
                                : MaterialButton(
                                    color: constantColors.whiteCream,
                                    child: Text(
                                      'unfollow',
                                      style: TextStyle(
                                          color: constantColors.darkGreyColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: () {},
                                  ),
                            leading: CircleAvatar(
                              backgroundColor: constantColors.transparent,
                              backgroundImage: NetworkImage(
                                  documentSnapshot.get('userimage')),
                            ),
                            title: Text(documentSnapshot.get('username'),
                                style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                            subtitle: Text(
                              documentSnapshot.get('useremail'),
                              style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                          );
                        }
                      }).toList(),
                    );
                  }
                }),
          );
        });
  }

  showPostDetails(BuildContext context, String userUid) {
    Navigator.pushReplacement(
        context,
        PageTransition(
            child: PostDetail(userUid), type: PageTransitionType.bottomToTop));
  }
}
