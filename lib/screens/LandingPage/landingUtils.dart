import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/constants/Constantcolors.dart';
import 'package:myapp/screens/LandingPage/landingServices.dart';
import 'package:myapp/services/FirebaseOperations.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class LandingUltis with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();

  final picker = ImagePicker();
  late File userAvatar;
  File get getUserAvatar => userAvatar;
  late String userAvatarURL;
  String get getUserAvatarURL => userAvatarURL;

  Future pickUserAvatar(BuildContext context, ImageSource source) async {
    final pickedUserAvatar = await picker.getImage(source: source);
    pickedUserAvatar == null
        ? print('Select Image')
        : userAvatar = File(pickedUserAvatar.path);
    print(userAvatar.path);

    userAvatar != null
        ? Provider.of<LandingServices>(context, listen: false)
            .showUserAvatar(context)
        : print('Image upload error');
    notifyListeners();
  }

  Future selectAvatarOptionsSheet(BuildContext context) async {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 150.0),
                child: Divider(
                  thickness: 4.0,
                  color: constantColors.whiteColor,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                      color: constantColors.blueColor,
                      child: Text('Gallery',
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0)),
                      onPressed: () {
                        pickUserAvatar(context, ImageSource.gallery)
                            .whenComplete(() {
                          Navigator.pop(context);
                          Provider.of<LandingServices>(context, listen: false)
                              .showUserAvatar(context);
                        });
                      }),
                  MaterialButton(
                      color: constantColors.blueColor,
                      child: Text('Camera',
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0)),
                      onPressed: () {
                        pickUserAvatar(context, ImageSource.camera)
                            .whenComplete(() {
                          Navigator.pop(context);
                          Provider.of<LandingServices>(context, listen: false)
                              .showUserAvatar(context);
                        });
                      }),
                ],
              )
            ]),
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.1,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.circular(12.0)),
          );
        });
  }
}
