import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:myapp/constants/Constantcolors.dart';
import 'package:myapp/screens/DirectMessage/DirectMessage.dart';
import 'package:myapp/screens/Messaging/GroupMessage.dart';
import 'package:myapp/screens/Messaging/GroupMessageHelpers.dart';
import 'package:myapp/services/Authentication.dart';
import 'package:myapp/services/FirebaseOperations.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatroomHeplers with ChangeNotifier {
  bool isPublic = true;
  late String lastestMessageTime;
  String get getLastestMessageTime => lastestMessageTime;
  late String chatroomAvatarUrl = '';
  late String chatroomID;
  String get getChatroomAvatarUrl => chatroomAvatarUrl;
  ConstantColors constantColors = ConstantColors();
  final TextEditingController chatroomNameController = TextEditingController();

  showChatroomDetails(BuildContext context, DocumentSnapshot documentSnapshot) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12))),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150),
                  child: Divider(
                    color: constantColors.whiteColor,
                    thickness: 4,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: constantColors.blueColor,
                      ),
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Members',
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('chatrooms')
                        .doc(documentSnapshot.id)
                        .collection('members')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return ListView(
                            scrollDirection: Axis.horizontal,
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot documentSnapshot) {
                              return GestureDetector(
                                onTap: () {
                                  if (Provider.of<Authentication>(context,
                                              listen: false)
                                          .getUserUid !=
                                      documentSnapshot.get('useruid')) {
                                    // Navigator.pushReplacement(context, PageTransition(child: AltProfile(), type: PageTransitionType.leftToRight))
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: CircleAvatar(
                                    backgroundColor: constantColors.darkColor,
                                    radius: 25,
                                    backgroundImage: NetworkImage(
                                        documentSnapshot.get('userimage')),
                                  ),
                                ),
                              );
                            }).toList());
                      }
                    },
                  ),
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.width,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: constantColors.blueColor,
                      ),
                      borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    'Admin',
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: constantColors.transparent,
                        backgroundImage:
                            NetworkImage(documentSnapshot.get('userimage')),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              documentSnapshot.get('username'),
                              style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Provider.of<Authentication>(context, listen: false)
                                      .getUserUid ==
                                  documentSnapshot.get('useruid')
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: MaterialButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              backgroundColor:
                                                  constantColors.darkColor,
                                              title: Text(
                                                'Delete Chatroom?',
                                                style: TextStyle(
                                                    color: constantColors
                                                        .whiteColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                              actions: [
                                                MaterialButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    'No',
                                                    style: TextStyle(
                                                        color: constantColors
                                                            .whiteColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                        decorationColor:
                                                            constantColors
                                                                .whiteColor),
                                                  ),
                                                ),
                                                MaterialButton(
                                                  onPressed: () {
                                                    FirebaseFirestore.instance
                                                        .collection('chatrooms')
                                                        .doc(
                                                            documentSnapshot.id)
                                                        .delete()
                                                        .whenComplete(() =>
                                                            Navigator.pop(
                                                                context));
                                                  },
                                                  child: Text(
                                                    'Yes',
                                                    style: TextStyle(
                                                        color: constantColors
                                                            .whiteColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                        decorationColor:
                                                            constantColors
                                                                .whiteColor),
                                                  ),
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    color: constantColors.redColor,
                                    child: Text(
                                      'Delete room',
                                      style: TextStyle(
                                          color: constantColors.whiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                )
                              : Container()
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  showCreateChatroomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 150),
                      child: Divider(
                        color: constantColors.whiteColor,
                        thickness: 4,
                      ),
                    ),
                    Text('Select Chatroom Avatar',
                        style: TextStyle(
                            color: constantColors.greenColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14)),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.width,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('chatroomIcons')
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
                                return StatefulBuilder(
                                    builder: (context, setState) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        chatroomAvatarUrl =
                                            documentSnapshot.get('image');
                                      });
                                      notifyListeners();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 16),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: chatroomAvatarUrl ==
                                                        documentSnapshot
                                                            .get('image')
                                                    ? constantColors.blueColor
                                                    : constantColors
                                                        .transparent)),
                                        height: 10,
                                        width: 40,
                                        child: Image.network(
                                            documentSnapshot.get('image')),
                                      ),
                                    ),
                                  );
                                });
                              }).toList(),
                            );
                          }
                        },
                      ),
                    ),
                    StatefulBuilder(builder: (context, setState) {
                      return ListTile(
                        title: Text(
                          'Public',
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        leading: Switch(
                          value: isPublic,
                          activeColor: constantColors.whiteCream,
                          onChanged: (bool value) async {
                            setState(() {
                              isPublic = value;
                            });
                            notifyListeners();
                          },
                        ),
                      );
                    }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: constantColors.whiteCream,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: TextField(
                              controller: chatroomNameController,
                              style: TextStyle(
                                  color: constantColors.darkGreyColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Enter Chatroom ID",
                                  hintStyle: TextStyle(
                                      color: constantColors.darkGreyColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                            ),
                          ),
                        ),
                        FloatingActionButton(
                          onPressed: () async {
                            await Provider.of<FirebaseOperations>(context,
                                    listen: false)
                                .submitChatroomData(
                                    chatroomNameController.text, {
                              'isDirect': false,
                              'public': true,
                              'roomavatar': getChatroomAvatarUrl,
                              'time': Timestamp.now(),
                              'roomname': chatroomNameController.text,
                              'username': Provider.of<FirebaseOperations>(
                                      context,
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
                            });
                            Provider.of<FirebaseOperations>(context,
                                    listen: false)
                                .updateChatroomData(
                                    chatroomNameController.text, {
                              'public': isPublic,
                            });
                            FirebaseFirestore.instance
                                .collection('chatrooms')
                                .doc(chatroomNameController.text)
                                .collection('members')
                                .doc(Provider.of<Authentication>(context,
                                        listen: false)
                                    .getUserUid)
                                .set({
                              'joined': true,
                              'username': Provider.of<FirebaseOperations>(
                                      context,
                                      listen: false)
                                  .getInitUserName,
                              'userimage': Provider.of<FirebaseOperations>(
                                      context,
                                      listen: false)
                                  .getInitUserImage,
                              'useruid': Provider.of<Authentication>(context,
                                      listen: false)
                                  .getUserUid,
                              'time': Timestamp.now()
                            });
                            // Navigator.
                          },
                          backgroundColor: constantColors.blueGreyColor,
                          child: Icon(
                            FontAwesomeIcons.plus,
                            color: constantColors.yellowColor,
                          ),
                        )
                      ],
                    )
                  ],
                ),
                height: MediaQuery.of(context).size.height * 0.35,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: constantColors.darkGreyColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0)),
                )),
          );
        });
  }

  showChatrooms(BuildContext context) {
    String userUid =
        Provider.of<Authentication>(context, listen: false).getUserUid;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('chatrooms').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SizedBox(
              height: 200,
              width: 200,
              child: Lottie.asset('assets/animations/loading.json'),
            ),
          );
        } else {
          return ListView(
            children:
                snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
              // var check = checkIfJoined(context, documentSnapshot.id, userUid);
              return FutureBuilder<bool>(
                  future: checkIfJoined(context, documentSnapshot.id, userUid),
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    if (documentSnapshot.get('isDirect') == true) {
                      return showDirectMessage(context, documentSnapshot);
                    }
                    if (snapshot.data == true ||
                        documentSnapshot.get('public')) {
                      return showChatroom(context, documentSnapshot);
                    } else {
                      return Container();
                    }
                  });
            }).toList(),
          );
        }
      },
    );
  }

  showLastMessageTime(dynamic timeData) {
    Timestamp t = timeData;
    DateTime dateTime = t.toDate();
    lastestMessageTime = timeago.format(dateTime);
    // notifyListeners();
  }

  Widget showChatroom(BuildContext context, DocumentSnapshot documentSnapshot) {
    return ListTile(
        onTap: () {
          Navigator.pushReplacement(
              context,
              PageTransition(
                  child: GroupMessage(documentSnapshot),
                  type: PageTransitionType.leftToRight));
        },
        onLongPress: () {
          showChatroomDetails(context, documentSnapshot);
        },
        title: Text(
          documentSnapshot.get('roomname'),
          style: TextStyle(
              color: constantColors.darkColor,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
        trailing: Container(
          width: 50,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('chatrooms')
                .doc(documentSnapshot.id)
                .collection('messages')
                .orderBy('time', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.data?.docs.isEmpty == false) {
                showLastMessageTime(snapshot.data?.docs.first.get('time'));
                getLastestMessageTime;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return Text(getLastestMessageTime,
                      style: TextStyle(
                          color: constantColors.darkGreyColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold));
                }
              } else {
                return Container();
              }
            },
          ),
        ),
        subtitle: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('chatrooms')
              .doc(documentSnapshot.id)
              .collection('messages')
              .orderBy('time', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data?.docs.isEmpty == false) {
              if (snapshot.data?.docs.first.get('username') != null &&
                  snapshot.data?.docs.first.get('message') != null) {
                return Text(
                    '${snapshot.data!.docs.first.get('username')} : ${snapshot.data!.docs.first.get('message')}',
                    style: TextStyle(
                        color: constantColors.greenColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold));
              }
              if (snapshot.data!.docs.first.get('username') != null &&
                  snapshot.data!.docs.first.get('messages') != null) {
                return Text(
                    '${snapshot.data!.docs.first.get('username')} : ${snapshot.data!.docs.first.get('message')}',
                    style: TextStyle(
                        color: constantColors.greenColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold));
              }
              if (snapshot.data!.docs.first.get('username') != null &&
                  snapshot.data!.docs.first.get('sticker') != null) {
                return Text(
                    '${snapshot.data!.docs.first.get('username')} : Sticker',
                    style: TextStyle(
                        color: constantColors.greenColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold));
              }
            }
            return Text(
              'No available message',
              style: TextStyle(
                  color: constantColors.darkGreyColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            );
          },
        ),
        leading: CircleAvatar(
          backgroundColor: constantColors.transparent,
          backgroundImage: NetworkImage(documentSnapshot.get('roomavatar')),
        ));
  }

  createDirectMessage(BuildContext context, dynamic snapshot) async {
    String roomId = snapshot.data.data()['username'] +
        ' ' +
        Provider.of<FirebaseOperations>(context, listen: false).getInitUserName;
    Provider.of<FirebaseOperations>(context, listen: false)
        .submitChatroomData(roomId, {
      'isDirect': true,
      'public': false,
      'roomavatar': '',
      'time': Timestamp.now(),
      'roomname': roomId,
      'username': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserName,
      'userimage': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserImage,
      'useremail': Provider.of<FirebaseOperations>(context, listen: false)
          .getInItUserEmail,
      'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
    });
    // Provider.of<FirebaseOperations>(context, listen: false)
    //     .updateChatroomData(chatroomNameController.text, {
    //   'public': isPublic,
    // });
    FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(roomId)
        .collection('members')
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .set({
      'joined': true,
      'username': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserName,
      'userimage': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserImage,
      'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
      'time': Timestamp.now()
    });
    FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(roomId)
        .collection('members')
        .doc(snapshot.data.data()['useruid'])
        .set({
      'joined': true,
      'username': snapshot.data.data()['username'],
      'userimage': snapshot.data.data()['userimage'],
      'useruid': snapshot.data.data()['useruid'],
      'time': Timestamp.now()
    });

    var data = await Provider.of<FirebaseOperations>(context, listen: false)
        .getChatroomData(roomId);

    Navigator.pushReplacement(
        context,
        PageTransition(
            child: DirectMessage(data), type: PageTransitionType.leftToRight));
  }

  Widget showDirectMessage(
      BuildContext context, DocumentSnapshot documentSnapshot) {
    String userName =
        Provider.of<FirebaseOperations>(context, listen: false).getInitUserName;
    String userImage = Provider.of<FirebaseOperations>(context, listen: false)
        .getInitUserImage;
    var data;
    return ListTile(
        onTap: () {
          Navigator.pushReplacement(
              context,
              PageTransition(
                  child: DirectMessage(documentSnapshot),
                  type: PageTransitionType.leftToRight));
        },
        title: Container(
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('chatrooms')
                    .doc(documentSnapshot.id)
                    .collection('members')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    data = snapshot.data!.docs.firstWhere(((element) =>
                        element.get('useruid') !=
                        Provider.of<Authentication>(context, listen: false)
                            .getUserUid));
                    return Text(
                      data.get('username'),
                      style: TextStyle(
                          color: constantColors.darkColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    );
                  }
                })),
        trailing: Container(
          width: 50,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('chatrooms')
                .doc(documentSnapshot.id)
                .collection('messages')
                .orderBy('time', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.data?.docs.isEmpty == false) {
                showLastMessageTime(snapshot.data?.docs.first.get('time'));
                getLastestMessageTime;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return Text(getLastestMessageTime,
                      style: TextStyle(
                          color: constantColors.darkGreyColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold));
                }
              } else {
                return Container();
              }
            },
          ),
        ),
        subtitle: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('chatrooms')
              .doc(documentSnapshot.id)
              .collection('messages')
              .orderBy('time', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data?.docs.isEmpty == false) {
              if (snapshot.data?.docs.first.get('username') != null &&
                  snapshot.data?.docs.first.get('message') != null) {
                return Text(
                    '${snapshot.data!.docs.first.get('username')} : ${snapshot.data!.docs.first.get('message')}',
                    style: TextStyle(
                        color: constantColors.greenColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold));
              }
              if (snapshot.data!.docs.first.get('username') != null &&
                  snapshot.data!.docs.first.get('messages') != null) {
                return Text(
                    '${snapshot.data!.docs.first.get('username')} : ${snapshot.data!.docs.first.get('message')}',
                    style: TextStyle(
                        color: constantColors.greenColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold));
              }
              if (snapshot.data!.docs.first.get('username') != null &&
                  snapshot.data!.docs.first.get('sticker') != null) {
                return Text(
                    '${snapshot.data!.docs.first.get('username')} : Sticker',
                    style: TextStyle(
                        color: constantColors.greenColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold));
              }
            }
            return Text(
              'No available message',
              style: TextStyle(
                  color: constantColors.darkGreyColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            );
          },
        ),
        leading: Container(
            width: 40,
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('chatrooms')
                    .doc(documentSnapshot.id)
                    .collection('members')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    data = snapshot.data!.docs.firstWhere(((element) =>
                        element.get('useruid') !=
                        Provider.of<Authentication>(context, listen: false)
                            .getUserUid));
                    return CircleAvatar(
                      backgroundColor: constantColors.transparent,
                      backgroundImage: NetworkImage(data.get('userimage')),
                    );
                  }
                })));
  }

  Future<bool> checkIfJoined(BuildContext context, String chatRoomName,
      String chatRoomAdminUid) async {
    return await FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomName)
        .collection('members')
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .get()
        .then((value) {
      if (!value.data().toString().contains('joined')) {
        return false;
      }
      if (value.get('joined') != null) {
        return true;
      }
      return false;
    });
  }

  directMessageRoomName(List<dynamic> roomNames, String userName) {
    var data = roomNames.firstWhere((element) => element != userName);
    return data;
  }

  directMessageAvatar(String avatar, String userAvatar) {
    // print(avatar);
    var list = avatar.split(' ');
    var data = list.firstWhere((element) => element != userAvatar);
    return data;
  }
}

        // title: Text(
        //   directMessageRoomName(documentSnapshot.get('roomname'), userName),
        //   style: TextStyle(
        //       color: constantColors.darkColor,
        //       fontSize: 16,
        //       fontWeight: FontWeight.bold),
        // ),
        // CircleAvatar(
        //   backgroundColor: constantColors.transparent,
        //   backgroundImage: NetworkImage(directMessageAvatar(
        //       documentSnapshot.get('roomavatar'), userImage)),
        // ));