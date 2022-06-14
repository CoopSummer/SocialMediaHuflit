import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myapp/constants/Constantcolors.dart';
import 'package:myapp/screens/CommentPage/commentHelpers.dart';
import 'package:provider/provider.dart';

class CommentPage extends StatelessWidget {
  BuildContext context;
  DocumentSnapshot snapshot;
  String docId;
  ConstantColors constantColors = ConstantColors();
  TextEditingController commentController = TextEditingController();

  CommentPage(this.context, this.snapshot, this.docId);

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
                          children: snapshot.data!.docs
                              .map<Widget>((DocumentSnapshot documentSnapshot) {
                        return Container(
                            constraints: BoxConstraints(
                              minHeight: MediaQuery.of(context).size.height * 0.17,
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
                                                onPressed: () {},
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
                                              0.75,
                                          // height: MediaQuery.of(context).size.height,
                                          child: Text(
                                            documentSnapshot.get('comment'),
                                            style: TextStyle(
                                                color: constantColors
                                                    .darkGreyColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              FontAwesomeIcons.trashAlt,
                                              color: constantColors.redColor,
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
                          print('Adding comment ... ');
                          await Provider.of<CommentHelpers>(context,
                                  listen: false)
                              .addComment(context, snapshot.get('caption'),
                                  commentController.text)
                              .whenComplete(() {
                            commentController.clear();
                          });
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
