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

class GroupMessageHelpers with ChangeNotifier {
  bool MemberJoined = false;
  bool get getMemberJoined => MemberJoined;
  ConstantColors constantColors = ConstantColors();
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
      String adminUserUid) {
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
                  return Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.125,
                        child: Stack(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 60.0, top: 20),
                              child: Row(
                                children: [
                                  Container(
                                    constraints: BoxConstraints(
                                        maxHeight:
                                            MediaQuery.of(context).size.height *
                                                0.1,
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.8),
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
                                          Text(
                                            documentSnapshot.get('message'),
                                            style: TextStyle(
                                                color:
                                                    constantColors.whiteColor,
                                                fontSize: 14),
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
                                        child: Row(
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
                                                onPressed: () {},
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
      print('Initial state => $MemberJoined');
      if (value.get('joined') != null) {
        MemberJoined = value.get('joined');
        print('Final state => $MemberJoined');
        notifyListeners();
      }
      if (Provider.of<Authentication>(context, listen: false).getUserUid ==
          chatRoomAdminUid) {
        MemberJoined = true;
        notifyListeners();
      }
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
                  color: constantColors.whiteColor,
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
                      color: constantColors.whiteColor,
                      decoration: TextDecoration.underline,
                      decorationColor: constantColors.whiteColor,
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
                      color: constantColors.whiteColor,
                      decoration: TextDecoration.underline,
                      decorationColor: constantColors.whiteColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        });
  }
}
