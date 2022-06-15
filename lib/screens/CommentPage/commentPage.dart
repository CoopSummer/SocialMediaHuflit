import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myapp/constants/Constantcolors.dart';
import 'package:myapp/screens/CommentPage/commentHelpers.dart';
import 'package:myapp/services/Authentication.dart';
import 'package:myapp/services/FirebaseOperations.dart';
import 'package:myapp/utils/PostOptions.dart';
import 'package:provider/provider.dart';

class CommentPage extends StatefulWidget {
  BuildContext context;
  DocumentSnapshot snapshot;
  String docId;

  CommentPage(this.context, this.snapshot, this.docId);

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  late String commentBeReply;
  bool replyMode = false;
  var height = 0.0;

  ConstantColors constantColors = ConstantColors();

  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.whiteCream,
      appBar: AppBar(
        title: Text('Comments'),
        backgroundColor: constantColors.blueGreyColor.withOpacity(0.4),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .doc(widget.docId)
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
                          children: snapshot.data!.docs
                              .map<Widget>((DocumentSnapshot documentSnapshot) {
                        return Container(
                            constraints: BoxConstraints(
                              minHeight:
                                  MediaQuery.of(context).size.height * 0.17,
                            ),
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0, left: 8),
                                        child: GestureDetector(
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
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Container(
                                            child: Text(
                                          documentSnapshot.get('username'),
                                          style: TextStyle(
                                              color:
                                                  constantColors.darkGreyColor,
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
                                                  FontAwesomeIcons.arrowUp,
                                                  color:
                                                      constantColors.blueColor,
                                                  size: 16,
                                                )),
                                            Text(
                                              '0',
                                              style: TextStyle(
                                                  color: constantColors
                                                      .darkGreyColor,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            IconButton(
                                                onPressed: () async {
                                                  replyMode = true;
                                                  commentBeReply =
                                                      documentSnapshot
                                                          .get('comment');
                                                  commentController.text =
                                                      'Reply to ${documentSnapshot.get('username')} ';
                                                },
                                                icon: Icon(
                                                  FontAwesomeIcons.reply,
                                                  color: constantColors
                                                      .yellowColor,
                                                  size: 16,
                                                )),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            color: constantColors.blueColor,
                                            size: 16.0,
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.725,
                                          child: Text(
                                            documentSnapshot.get('comment'),
                                            style: TextStyle(
                                                color: constantColors
                                                    .darkGreyColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Provider.of<FirebaseOperations>(context,
                                                        listen: false)
                                                    .getInItUserEmail ==
                                                documentSnapshot
                                                    .get('useremail')
                                            ? IconButton(
                                                onPressed: () {
                                                  Provider.of<CommentHelpers>(
                                                          context,
                                                          listen: false)
                                                      .deleteComment(
                                                          context,
                                                          widget.docId,
                                                          documentSnapshot
                                                              .get('comment'));
                                                },
                                                icon: Icon(
                                                  FontAwesomeIcons.trashAlt,
                                                  color:
                                                      constantColors.redColor,
                                                  size: 16,
                                                ))
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('posts')
                                          .doc(widget.docId)
                                          .collection('comments')
                                          .doc(documentSnapshot.get('comment'))
                                          .collection('reply')
                                          .orderBy('time', descending: false)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        } else {
                                          if (snapshot.data!.docs.length > 0) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 50.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        height == 0
                                                            ? height = snapshot
                                                                    .data!
                                                                    .docs
                                                                    .length *
                                                                60.0
                                                            : height = 0;
                                                      });
                                                    },
                                                    child: Text(
                                                        height == 0
                                                            ? 'Số lượng reply ${snapshot.data!.docs.length}'
                                                            : 'Ẩn reply',
                                                        style: TextStyle(
                                                            color: constantColors
                                                                .darkGreyColor,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
                                                  Container(
                                                    height: height,
                                                    constraints:
                                                        const BoxConstraints(
                                                            minHeight: 0),
                                                    child: ListView(
                                                      children: snapshot
                                                          .data!.docs
                                                          .map((DocumentSnapshot
                                                              documentSnapshot) {
                                                        return Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 8.0,
                                                                      left: 8),
                                                                  child:
                                                                      GestureDetector(
                                                                    child:
                                                                        CircleAvatar(
                                                                      backgroundColor:
                                                                          constantColors
                                                                              .darkColor,
                                                                      radius:
                                                                          15.0,
                                                                      backgroundImage:
                                                                          NetworkImage(
                                                                              documentSnapshot.get('userimage')),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          8.0),
                                                                  child:
                                                                      Container(
                                                                          child:
                                                                              Text(
                                                                    documentSnapshot
                                                                        .get(
                                                                            'username'),
                                                                    style: TextStyle(
                                                                        color: constantColors
                                                                            .darkGreyColor,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            18.0),
                                                                  )),
                                                                ),
                                                              ],
                                                            ),
                                                            Text(documentSnapshot
                                                                .get('reply')),
                                                          ],
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          } else {
                                            return Container();
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                  Divider(
                                    color: constantColors.darkColor
                                        .withOpacity(0.2),
                                  ),
                                ]));
                      }).toList());
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  width: 400,
                  height: 40.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 300.0,
                        height: 20.0,
                        child: TextField(
                          autofocus: true,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                              hintText: 'Add comment ....',
                              hintStyle: TextStyle(
                                  color: constantColors.darkGreyColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                          controller: commentController,
                          style: TextStyle(
                              color: constantColors.darkGreyColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      FloatingActionButton(
                        onPressed: () async {
                          
                          if (replyMode) {
                            await Provider.of<CommentHelpers>(context,
                                    listen: false)
                                .addReply(
                                    context,
                                    widget.snapshot.get('caption'),
                                    commentBeReply,
                                    commentController.text)
                                .whenComplete(() {
                              replyMode = false;
                              commentController.clear();
                            });
                          } else {
                            await Provider.of<CommentHelpers>(context,
                                    listen: false)
                                .addComment(
                                    context,
                                    widget.snapshot.get('caption'),
                                    commentController.text)
                                .whenComplete(() {
                              commentController.clear();
                            });
                          }
                        },
                        child: Icon(
                          FontAwesomeIcons.comment,
                          color: constantColors.darkGreyColor,
                        ),
                        backgroundColor: constantColors.whiteCream,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
