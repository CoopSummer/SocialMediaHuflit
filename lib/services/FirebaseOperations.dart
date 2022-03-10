import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/services/Authentication.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:myapp/screens/LandingPage/landingUtils.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class FirebaseOperations with ChangeNotifier {
  UploadTask? imageUploadTask;
  Future uploadUserAvatar(BuildContext context) async {
    Reference imageReference = FirebaseStorage.instance.ref().child(
        'userProfileAvatar/${Provider.of<LandingUltis>(context, listen: false).getUserAvatar.path}/${TimeOfDay.now()}');
    imageUploadTask = imageReference.putFile(
        Provider.of<LandingUltis>(context, listen: false).getUserAvatar);
    await imageUploadTask?.whenComplete(() {
      print('Image Uploaded');
    });
    imageReference.getDownloadURL().then((url) {
      Provider.of<LandingUltis>(context, listen: false).userAvatarURL =
          url.toString();
      print(
          'the user profile avatar url => ${Provider.of<LandingUltis>(context, listen: false).userAvatarURL = url.toString()}');
      notifyListeners();
    });
  }

  Future createUserCollection(BuildContext context, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .set(data);
  }
}
