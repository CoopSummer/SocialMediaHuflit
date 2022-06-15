import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myapp/constants/Constantcolors.dart';
import 'package:myapp/screens/HomePage/Homepage.dart';
import 'package:myapp/screens/Messaging/GroupMessageHelpers.dart';
import 'package:myapp/services/Authentication.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class GroupMessage extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;

  GroupMessage(this.documentSnapshot);

  @override
  State<GroupMessage> createState() => _GroupMessageState();
}

class _GroupMessageState extends State<GroupMessage> {
  ConstantColors constantColors = ConstantColors();

  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    Provider.of<GroupMessageHelpers>(context, listen: false)
        .checkIfJoined(context, widget.documentSnapshot.id,
            widget.documentSnapshot.get('useruid'))
        .whenComplete(() async {
      if (Provider.of<GroupMessageHelpers>(context, listen: false)
              .getMemberJoined ==
          false) {
        Timer(
            Duration(microseconds: 10),
            () => Provider.of<GroupMessageHelpers>(context, listen: false)
                .askToJoin(context, widget.documentSnapshot.id));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.documentSnapshot.get('public'));
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
            context,
            PageTransition(
                child: Homepage(), type: PageTransitionType.leftToRight));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            !widget.documentSnapshot.get('public')
                ? IconButton(
                    onPressed: () {
                      Provider.of<GroupMessageHelpers>(context, listen: false)
                          .addToRoom(context, widget.documentSnapshot.id);
                    },
                    icon: Icon(FontAwesomeIcons.userPlus,
                        color: constantColors.redColor))
                : Container(),
            IconButton(
                onPressed: () {
                  Provider.of<GroupMessageHelpers>(context, listen: false)
                      .leaveTheRoom(context, widget.documentSnapshot.id);
                },
                icon: Icon(EvaIcons.logOutOutline,
                    color: constantColors.redColor)),
            Provider.of<Authentication>(context, listen: false).getUserUid ==
                    widget.documentSnapshot.get('useruid')
                ? IconButton(
                    onPressed: () {},
                    icon: Icon(EvaIcons.moreVertical,
                        color: constantColors.whiteColor))
                : Container()
          ],
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: constantColors.whiteColor,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      child: Homepage(), type: PageTransitionType.leftToRight));
            },
          ),
          title: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: CircleAvatar(
                      backgroundColor: constantColors.transparent,
                      backgroundImage: NetworkImage(
                          widget.documentSnapshot.get('roomavatar')),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.documentSnapshot.get('roomname'),
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('chatrooms')
                              .doc(widget.documentSnapshot.id)
                              .collection('members')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else {
                              return Text(
                                '${snapshot.data!.docs.length} members',
                                style: TextStyle(
                                    color: constantColors.greenColor
                                        .withOpacity(0.5),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              );
                            }
                          })
                    ],
                  ),
                ],
              )),
          backgroundColor: constantColors.darkColor.withOpacity(0.6),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                AnimatedContainer(
                  child: Provider.of<GroupMessageHelpers>(context).showMessages(
                      context,
                      widget.documentSnapshot,
                      widget.documentSnapshot.get('useruid'),
                      widget.documentSnapshot.id),
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: MediaQuery.of(context).size.width,
                  duration: Duration(seconds: 1),
                  curve: Curves.bounceIn,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                    color: constantColors.whiteCream,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Provider.of<GroupMessageHelpers>(context,
                                    listen: false)
                                .showSticker(
                                    context, widget.documentSnapshot.id);
                          },
                          child: CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/icons/sunflower.png'),
                            radius: 18,
                            backgroundColor: constantColors.transparent,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color:
                                  constantColors.darkGreyColor.withOpacity(0.8),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16))),
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: TextField(
                              controller: messageController,
                              style: TextStyle(
                                color: constantColors.whiteColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Drop a hi ...',
                                  hintStyle: TextStyle(
                                      color: constantColors.whiteColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                        FloatingActionButton(
                            // backgroundColor: constantColors.greenColor,
                            onPressed: () {
                              if (messageController.text.isNotEmpty) {
                                Provider.of<GroupMessageHelpers>(context,
                                        listen: false)
                                    .sendMessage(
                                        context,
                                        widget.documentSnapshot,
                                        messageController);
                              }
                            },
                            child: Icon(
                              Icons.send_sharp,
                              color: constantColors.whiteColor,
                            ))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        backgroundColor: constantColors.whiteCream,
      ),
    );
  }
}
