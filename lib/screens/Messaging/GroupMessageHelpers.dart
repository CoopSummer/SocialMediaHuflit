import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myapp/constants/Constantcolors.dart';
import 'package:myapp/screens/HomePage/Homepage.dart';
import 'package:myapp/services/Authentication.dart';
import 'package:myapp/services/FirebaseOperations.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class GroupMessageHelpers with ChangeNotifier {
  bool toggle = false;
  bool MemberJoined = false;
  late String lastMessageTime;
  String get getLastMessageTime => lastMessageTime;
  bool get getMemberJoined => MemberJoined;
  ConstantColors constantColors = ConstantColors();
  final TextEditingController userEmailController = TextEditingController();

  leaveTheRoom(BuildContext context, String chatRoomName) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: constantColors.darkColor,
            title: Text(
              'Leave $chatRoomName',
              style: TextStyle(
                  color: constantColors.whiteColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
            actions: [
              MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'No',
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: constantColors.whiteColor,
                        fontSize: 14),
                  )),
              MaterialButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('chatrooms')
                        .doc(chatRoomName)
                        .collection('members')
                        .doc(Provider.of<Authentication>(context, listen: false)
                            .getUserUid)
                        .delete()
                        .whenComplete(() => Navigator.pushReplacement(
                            context,
                            PageTransition(
                                child: Homepage(),
                                type: PageTransitionType.leftToRight)));
                  },
                  child: Text(
                    'Yes',
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: constantColors.whiteColor,
                        fontSize: 14),
                  ))
            ],
          );
        });
  }

  addToRoom(BuildContext context, String chatRoomName) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: constantColors.darkGreyColor,
            title: Text(
              'Add to $chatRoomName',
              style: TextStyle(
                  color: constantColors.whiteColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
            content: Container(
              decoration: BoxDecoration(
                  color: constantColors.whiteCream,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TextField(
                  onChanged: (value) async {
                    var data = await searchUser(context, value, chatRoomName);
                    // print(data);
                  },
                  controller: userEmailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                      color: constantColors.darkGreyColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter User Email",
                      hintStyle: TextStyle(
                          color: constantColors.darkGreyColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                ),
              ),
            ),
            actions: [
              MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'No',
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: constantColors.whiteColor,
                        fontSize: 14),
                  )),
              MaterialButton(
                  disabledTextColor: constantColors.transparent,
                  disabledColor: constantColors.redColor,
                  onPressed: () async {
                    var data = await searchUser(
                        context, userEmailController.text, chatRoomName);
                    if (data.toString().contains('useruid')) {
                      FirebaseFirestore.instance
                          .collection('chatrooms')
                          .doc(chatRoomName)
                          .collection('members')
                          .doc(data['useruid'])
                          .set({
                        'joined': true,
                        'username': data['userimage'],
                        'userimage': data['userimage'],
                        'useruid': data['useruid'],
                        'time': Timestamp.now()
                      }).whenComplete(() {
                        userEmailController.clear();
                        Navigator.pop(context);
                      });
                    } else {}
                  },
                  child: Text(
                    'Yes',
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: constantColors.whiteColor,
                        fontSize: 14),
                  ))
            ],
          );
        });
  }

  sendMessage(BuildContext context, DocumentSnapshot documentSnapshot,
      TextEditingController messageController) {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(documentSnapshot.id)
        .collection('messages')
        .add({
      'message': messageController.text,
      'time': Timestamp.now(),
      'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
      'username': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserName,
      'userimage': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserImage,
    });
  }

  showMessages(BuildContext context, DocumentSnapshot documentSnapshot,
      String adminUserUid, String chatRoomName) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chatrooms')
            .doc(documentSnapshot.id)
            .collection('messages')
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (builder, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(
                reverse: true,
                children: snapshot.data!.docs
                    .map((DocumentSnapshot documentSnapshot) {
                  showLastMessageTime(documentSnapshot.get('time'));
                  return Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        constraints: BoxConstraints(
                          minHeight: documentSnapshot.get('message') != null
                              ? MediaQuery.of(context).size.height * 0.1
                              : MediaQuery.of(context).size.height * 0.2,
                        ),
                        child: Stack(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 60.0, top: 20),
                              child: Row(
                                children: [
                                  Container(
                                    constraints: BoxConstraints(
                                        minHeight:
                                            documentSnapshot.get('message') !=
                                                    null
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.1
                                                : MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.4,
                                        maxWidth: documentSnapshot
                                                    .get('message') !=
                                                null
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8
                                            : MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Provider.of<Authentication>(
                                                        context,
                                                        listen: false)
                                                    .getUserUid ==
                                                documentSnapshot.id
                                            ? constantColors.blueGreyColor
                                                .withOpacity(0.8)
                                            : constantColors.blueGreyColor),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 18.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 150,
                                            child: Row(
                                              children: [
                                                Text(
                                                    documentSnapshot
                                                        .get('username'),
                                                    style: TextStyle(
                                                      color: constantColors
                                                          .greenColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                    )),
                                                Provider.of<Authentication>(
                                                                context,
                                                                listen: false)
                                                            .getUserUid ==
                                                        adminUserUid
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 8.0),
                                                        child: Icon(
                                                          FontAwesomeIcons
                                                              .chessKing,
                                                          color: constantColors
                                                              .yellowColor,
                                                          size: 12,
                                                        ),
                                                      )
                                                    : Container()
                                              ],
                                            ),
                                          ),
                                          documentSnapshot.get('message') !=
                                                  null
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0),
                                                  child: Text(
                                                    documentSnapshot
                                                        .get('message'),
                                                    style: TextStyle(
                                                        color: constantColors
                                                            .whiteColor,
                                                        fontSize: 14),
                                                  ),
                                                )
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0),
                                                  child: Container(
                                                    height: 90,
                                                    width: 100,
                                                    child: Image.network(
                                                        documentSnapshot
                                                            .get('sticker')),
                                                  ),
                                                ),
                                          Container(
                                            width: 100,
                                            child: Text(getLastMessageTime,
                                                style: TextStyle(
                                                    color: constantColors
                                                        .whiteColor,
                                                    fontSize: 10)),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                                child: Provider.of<Authentication>(context,
                                                listen: false)
                                            .getUserUid ==
                                        documentSnapshot.get('useruid')
                                    ? Container(
                                        child: Column(
                                          children: [
                                            IconButton(
                                                onPressed: () {},
                                                icon: Icon(
                                                  Icons.edit,
                                                  color:
                                                      constantColors.blueColor,
                                                  size: 16,
                                                )),
                                            IconButton(
                                                onPressed: () {
                                                  FirebaseFirestore.instance
                                                      .collection('chatrooms')
                                                      .doc(chatRoomName)
                                                      .collection('messages')
                                                      .doc(documentSnapshot.id)
                                                      .delete();
                                                  print(chatRoomName);
                                                },
                                                icon: Icon(
                                                  FontAwesomeIcons.trashAlt,
                                                  color:
                                                      constantColors.redColor,
                                                  size: 16,
                                                ))
                                          ],
                                        ),
                                      )
                                    : Container()),
                            Positioned(
                                left: 40,
                                child: Provider.of<Authentication>(context,
                                                listen: false)
                                            .getUserUid ==
                                        documentSnapshot.get('useruid')
                                    ? Container()
                                    : CircleAvatar(
                                        backgroundColor:
                                            constantColors.darkColor,
                                        backgroundImage: NetworkImage(
                                            documentSnapshot.get('userimage')),
                                      ))
                          ],
                        )),
                  );
                }).toList());
          }
        });
  }

  Future checkIfJoined(BuildContext context, String chatRoomName,
      String chatRoomAdminUid) async {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomName)
        .collection('members')
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .get()
        .then((value) {
      MemberJoined = false;
      if (!value.data().toString().contains('joined')) {
        MemberJoined = false;
      } else if (value.get('joined') != null) {
        MemberJoined = value.get('joined');
      } else {
        MemberJoined = false;
      }

      notifyListeners();
    });
  }

  askToJoin(BuildContext context, String roomName) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Join $roomName?',
              style: TextStyle(
                  color: constantColors.darkGreyColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          child: Homepage(),
                          type: PageTransitionType.leftToRight));
                },
                child: Text(
                  'No',
                  style: TextStyle(
                      color: constantColors.darkGreyColor,
                      decoration: TextDecoration.underline,
                      decorationColor: constantColors.darkGreyColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              MaterialButton(
                onPressed: () async {
                  FirebaseFirestore.instance
                      .collection('chatrooms')
                      .doc(roomName)
                      .collection('members')
                      .doc(Provider.of<Authentication>(context, listen: false)
                          .getUserUid)
                      .set({
                    'joined': true,
                    'username':
                        Provider.of<FirebaseOperations>(context, listen: false)
                            .getInitUserName,
                    'userimage':
                        Provider.of<FirebaseOperations>(context, listen: false)
                            .getInitUserImage,
                    'useruid':
                        Provider.of<Authentication>(context, listen: false)
                            .getUserUid,
                    'time': Timestamp.now()
                  }).whenComplete(() => Navigator.pop(context));
                },
                child: Text(
                  'Yes',
                  style: TextStyle(
                      color: constantColors.darkGreyColor,
                      decoration: TextDecoration.underline,
                      decorationColor: constantColors.darkGreyColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        });
  }

  showSticker(BuildContext context, String chatRoomId) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return AnimatedContainer(
            duration: Duration(seconds: 1),
            curve: Curves.easeIn,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 105),
                  child: Divider(
                    thickness: 4,
                    color: constantColors.whiteColor,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border:
                                Border.all(color: constantColors.blueColor)),
                        height: 30,
                        width: 30,
                        child: Image.asset('assets/icons/sunflower.png'),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('stickers')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return GridView(
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot documentSnapshot) {
                              return GestureDetector(
                                onTap: () {
                                  sendSticker(
                                      context,
                                      documentSnapshot.get('image'),
                                      chatRoomId);
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  child: Image.network(
                                      documentSnapshot.get('image')),
                                ),
                              );
                            }).toList(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3));
                      }
                    },
                  ),
                ),
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.darkColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12))),
          );
        });
  }

  sendSticker(
      BuildContext context, String stickerImgUrl, String chatRoomId) async {
    await FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages')
        .add({
      'sticker': stickerImgUrl,
      'username': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserName,
      'userimage': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserImage,
      'time': Timestamp.now()
    });
  }

  showLastMessageTime(dynamic timeData) {
    Timestamp time = timeData;
    DateTime dateTime = time.toDate();
    lastMessageTime = timeago.format(dateTime);
    // notifyListeners();
  }

  searchUser(BuildContext context, String userEmail, String chatRoomId) async {
    CollectionReference collectionReference =
        (FirebaseFirestore.instance.collection('users'));
    var data = await collectionReference.get();
    try {
      var user = data.docs.firstWhere((e) => e.get('useremail') == userEmail);
      return {
        'useruid': user.get('useruid'),
        'username': user.get('username'),
        'userimage': user.get('userimage')
      };
    } catch (error) {
      return error;
    }
    // try {
    //   var user = data.docs.map((e) {
    //     if (e.get('useremail').toString().contains(userEmail)) {
    //       print(e.get('useruid'));
    //       return e;
    //     }
    //   });
    //   return user.map((e) => {
    //         'useruid': e?.get('useruid'),
    //         'username': e?.get('username'),
    //         'userimage': e?.get('userimage')
    //       });
    // } catch (error) {
    //   return error;
    // }
  }
}
