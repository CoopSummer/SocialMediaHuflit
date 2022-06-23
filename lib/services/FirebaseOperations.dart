import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/model/User.dart';
import 'package:myapp/services/Authentication.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:myapp/screens/LandingPage/landingUtils.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseOperations with ChangeNotifier {
  UploadTask? imageUploadTask;
  late String initUserEmail, initUserName, initUserImage = "";
  String get getInitUserName => initUserName;
  String get getInItUserEmail => initUserEmail;
  String get getInitUserImage => initUserImage;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

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
    SharedPreferences prefs = await _prefs;
    final List<dynamic> users = await Users.loadData();

    UserList userList = UserList.fromJson(users);

    return await FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .get()
        .then((doc) {
      print('Fetching user data ');
      initUserName = doc.get('username');
      initUserEmail = doc.get('useremail');
      initUserImage = doc.get('userimage');
      final user = Users(
        useremail: doc.get('useremail'),
        username: doc.get('username'),
        userimage: doc.get('userimage'),
        userpassword: doc.get('userpassword'),
      );
      if (userList.users.every((e) => e.useremail != user.useremail)) {
        userList.users.add(user);
      }
      final String encodedData = Users.encode(userList.users);
      prefs.setString('users', encodedData);

      notifyListeners();
    });
  }

  Future initGoogleUserData(BuildContext context) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
  }

  Future uploadPostData(String postId, dynamic data) async {
    return FirebaseFirestore.instance.collection('posts').doc(postId).set(data);
  }

  Future deleteUserData(String UserId) async {
    return FirebaseFirestore.instance.collection('users').doc(UserId).delete();
  }

  Future addAward(String postId, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('awards')
        .add(data);
  }

  Future submitChatroomData(String chatRoomName, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomName)
        .set(data);
  }

  Future getChatroomData(String chatRoomName) async {
    DocumentSnapshot _doc = await FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomName)
        .get();
    return _doc;
  }

  Future updateChatroomData(String chatRoomName, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomName)
        .update(data);
  }

  Future updateUserData(String useruid, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(useruid)
        .update(data);
  }

  Future followUser(
      String followingUid,
      String followingDocId,
      dynamic followingData,
      String followerUid,
      String followerDocId,
      dynamic followerData) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(followingUid)
        .collection('followers')
        .doc(followingDocId)
        .set(followingData)
        .whenComplete(() async {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(followerUid)
          .collection('following')
          .doc(followerDocId)
          .set(followerData);
    });
  }
}
