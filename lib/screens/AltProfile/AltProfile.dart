import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/constants/Constantcolors.dart';
import 'package:myapp/screens/AltProfile/AltProfileHelper.dart';
import 'package:provider/provider.dart';

class AltProfile extends StatelessWidget {
  late final String userUid;
  final ConstantColors constantColors = ConstantColors();
  AltProfile({required this.userUid});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar:
          Provider.of<AltProfileHelper>(context, listen: false).appBar(context),
      body: SingleChildScrollView(
          child: Container(
        child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(userUid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                return Column(
                  children: [
                    Provider.of<AltProfileHelper>(context, listen: false)
                        .headerProfile(context, snapshot, userUid),
                    Provider.of<AltProfileHelper>(context, listen: false)
                        .divider(),
                    Provider.of<AltProfileHelper>(context, listen: false)
                        .middleProfile(context, snapshot),
                    Expanded(
                      child: Provider.of<AltProfileHelper>(context, listen: false)
                          .footerProfile(context, snapshot),
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                );
              }
            }),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,

      )),
      backgroundColor: constantColors.whiteCream,
    );
  }
}
