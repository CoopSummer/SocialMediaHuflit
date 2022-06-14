import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myapp/constants/Constantcolors.dart';
import 'package:myapp/screens/ChatRoom/ChatroomHelpers.dart';
import 'package:myapp/services/Authentication.dart';
import 'package:provider/provider.dart';

class ChatRoom extends StatelessWidget {
  ConstantColors constantColors = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: constantColors.darkGreyColor,
        child: Icon(FontAwesomeIcons.plus, color: constantColors.whiteColor,),
        onPressed: (){
          Provider.of<ChatroomHeplers>(context, listen: false).showCreateChatroomSheet(context);
        },
      ),
      appBar: AppBar(
        backgroundColor: constantColors.darkColor.withOpacity(0.4),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(EvaIcons.moreVertical))
        ],
        leading: IconButton(
            onPressed: () {},
            icon: Icon(
              FontAwesomeIcons.plus,
              color: constantColors.whiteColor,
            )),
        title: RichText(
            text: TextSpan(
                text: 'Chat',
                style: TextStyle(
                  color: constantColors.whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
                children: <TextSpan>[
              TextSpan(
                text: 'Box',
                style: TextStyle(
                  color: constantColors.blueColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              )
            ])),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Provider.of<ChatroomHeplers>(context,listen: false).showChatrooms(context),
      ),
    );
  }
}
