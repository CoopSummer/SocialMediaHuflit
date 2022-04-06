import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/services/Authentication.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:myapp/screens/LandingPage/landingUtils.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class FirebaseOperations with ChangeNotifier {
  UploadTask? imageUploadTask;
  late String initUserEmail, initUserName, initUserImage = "";
  String get getInitUserName => initUserName;
  String get getInItUserEmail => initUserEmail;
  String get getInitUserImage => initUserImage;
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

  Future initUserData(BuildContext context) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .get()
        .then((doc) {
      print('Fetching user data ');
      initUserName = doc.get('username');
      initUserEmail = doc.get('useremail');
      initUserImage = doc.get('userimage');
      print(initUserEmail);
      print(initUserImage);
      print(initUserName);
      notifyListeners();
    });
  }

  // Future initGoogleUserData(BuildContext context) async {
  //   final FirebaseAuth auth = FirebaseAuth.instance;
  //   final User? user = auth.currentUser;
  // }

  Future uploadPostData(String postId, dynamic data) async {
    return FirebaseFirestore.instance.collection('posts').doc(postId).set(data);
  }

  Future deleteUserData(String UserId) async {
    return FirebaseFirestore.instance.collection('users').doc(UserId).delete();
  }

  Future addAward(String postId, dynamic data) async{
    return FirebaseFirestore.instance.collection('posts').doc(postId).collection('awards').add(data);
  }
}
