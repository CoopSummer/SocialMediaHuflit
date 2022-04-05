import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myapp/constants/Constantcolors.dart';
import 'package:myapp/services/Authentication.dart';
import 'package:myapp/services/FirebaseOperations.dart';
import 'package:provider/provider.dart';

class PostFunctions with ChangeNotifier {
  TextEditingController commentController = TextEditingController();
  ConstantColors constantColors = ConstantColors();
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

  showCommentsSheet(
      BuildContext context, DocumentSnapshot snapshot, String docId) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                Container(
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
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .doc(docId)
                        .collection('comments')
                        .orderBy('time')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return ListView(
                            children: snapshot.data!.docs.map<Widget>(
                                (DocumentSnapshot documentSnapshot) {
                          return Container(
                              height: MediaQuery.of(context).size.height * 0.11,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        GestureDetector(
                                          child: CircleAvatar(
                                            backgroundColor:
                                                constantColors.darkColor,
                                            radius: 15.0,
                                            backgroundImage: NetworkImage(
                                                documentSnapshot
                                                    .get('userimage')),
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Container(
                                              child: Row(
                                                children: [
                                                  Text(
                                                    documentSnapshot
                                                        .get('username'),
                                                    style: TextStyle(
                                                        color: constantColors
                                                            .whiteColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12.0),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        Container(
                                          child: Row(
                                            children: [
                                              IconButton(
                                                  onPressed: () {},
                                                  icon: Icon(
                                                      FontAwesomeIcons.arrowUp,
                                                      color: constantColors
                                                          .blueColor)),
                                              Text(
                                                '0',
                                                style: TextStyle(
                                                    color: constantColors
                                                        .whiteColor,
                                                    fontSize: 12.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              IconButton(
                                                  onPressed: () {},
                                                  icon: Icon(
                                                      FontAwesomeIcons.reply,
                                                      color: constantColors
                                                          .yellowColor)),
                                              IconButton(
                                                  onPressed: () {},
                                                  icon: Icon(
                                                      FontAwesomeIcons.trashAlt,
                                                      color: constantColors
                                                          .redColor)),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.arrow_forward_ios_outlined,
                                              color: constantColors.blueColor,
                                              size: 12.0,
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            // height: MediaQuery.of(context).size.height,
                                            child: Text(
                                              documentSnapshot.get('comment'),
                                              style: TextStyle(
                                                  color:
                                                      constantColors.whiteColor,
                                                  fontSize: 16),
                                            ),
                                          )
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
                  color: constantColors.redColor,
                  width: 400,
                  height: 20.0,
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
                          addComment(context, snapshot.get('caption'), commentController.text);
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
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0))),
          );
        });
  }
}
