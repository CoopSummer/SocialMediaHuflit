import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/constants/Constantcolors.dart';
import 'package:myapp/screens/Chatroom/Chatroom.dart';
import 'package:myapp/screens/Feed/Feed.dart';
import 'package:myapp/screens/Profile/Profile.dart';

class Homepage extends StatefulWidget {
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  ConstantColors constantColors = ConstantColors();
  final PageController homePageController = PageController();
  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      body: PageView(
        controller: homePageController,
        children: [Feed(), Chatroom(), Profile()],
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (page){
          setState(() {
            pageIndex=page;
          });
        },
      ),
      bottomNavigationBar:  ,
    );
  }
}
