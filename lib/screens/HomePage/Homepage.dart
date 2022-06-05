import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/constants/Constantcolors.dart';
import 'package:myapp/screens/ChatRoom/ChatRoom.dart';
import 'package:myapp/screens/Feed/Feed.dart';
import 'package:myapp/screens/HomePage/HomepageHelpers.dart';
import 'package:myapp/screens/Profile/Profile.dart';
import 'package:myapp/services/FirebaseOperations.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    // final User? user = auth.currentUser;
    Provider.of<FirebaseOperations>(context, listen: false)
        .initUserData(context)
        .whenComplete(() => setState((){}));
    super.initState();
  }

  ConstantColors constantColors = ConstantColors();
  final PageController homePageController = PageController();
  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.whiteCream,
      body: PageView(
        controller: homePageController,
        children: [Feed(), ChatRoom(), Profile()],
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (page) {
          setState(() {
            pageIndex = page;
          });
        },
      ),
      bottomNavigationBar: Provider.of<HomepageHelpers>(context, listen: false)
          .bottomNavBar(context, pageIndex, homePageController),
    );
  }
}
