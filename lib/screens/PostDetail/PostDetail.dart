import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/constants/Constantcolors.dart';
import 'package:myapp/screens/Feed/FeedHelpers.dart';
import 'package:myapp/screens/PostDetail/PostDetailHelper.dart';
import 'package:provider/provider.dart';

class PostDetail extends StatelessWidget {
  ConstantColors constantColors = ConstantColors();
  String userUid;
  PostDetail(this.userUid);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.whiteCream,
      drawer: Drawer(),
      appBar: Provider.of<PostDetailHelpers>(context, listen: false).appBar(context),
      body: Provider.of<PostDetailHelpers>(context, listen: false).feedBody(context,this.userUid),
    );
  }
}
