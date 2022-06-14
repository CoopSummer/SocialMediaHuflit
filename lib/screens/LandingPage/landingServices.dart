import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/constants/Constantcolors.dart';
import 'package:myapp/model/User.dart';
import 'package:myapp/screens/HomePage/Homepage.dart';
import 'package:myapp/screens/LandingPage/landingUtils.dart';
import 'package:myapp/services/Authentication.dart';
import 'package:myapp/services/FirebaseOperations.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingServices with ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  ConstantColors constantColors = ConstantColors();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late UserList userList;

  Future<void> loadData() async {
    // SharedPreferences prefs = await _prefs;
    final users = Users.loadData();
    userList = UserList.fromJson(await users);
    print('Loop');
  }

  Future<void> deleteUser(String useremail) async {
    SharedPreferences prefs = await _prefs;
    userList.users.removeWhere((e) => e.useremail == useremail);
    final String encodedData = Users.encode(userList.users);
    await prefs.setString('users', encodedData);
    prefs.reload();
  }

  showUserAvatar(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.30,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                CircleAvatar(
                    radius: 80.0,
                    backgroundColor: constantColors.transparent,
                    backgroundImage: FileImage(
                        Provider.of<LandingUltis>(context, listen: false)
                            .userAvatar)),
                Expanded(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MaterialButton(
                            child: Text('Reselect',
                                style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    decorationColor:
                                        constantColors.whiteColor)),
                            onPressed: () {
                              Provider.of<LandingUltis>(context, listen: false)
                                  .pickUserAvatar(context, ImageSource.gallery);
                            }),
                        MaterialButton(
                            color: constantColors.blueColor,
                            child: Text('Confirm Image',
                                style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                )),
                            onPressed: () {
                              Provider.of<FirebaseOperations>(context,
                                      listen: false)
                                  .uploadUserAvatar(context)
                                  .whenComplete(() {
                                signInSheet(context);
                              });
                            })
                      ],
                    ),
                  ),
                )
              ],
            ),
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.circular(15.0),
            ),
          );
        });
  }

  Widget passwordLessSignIn(BuildContext context) {
    loadData();
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.40,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              return StatefulBuilder(builder: ((context, setState) {
                return ListView(
                  children: userList.users.map((documentSnapshot) {
                    return ListTile(
                      trailing: Container(
                        width: 120.0,
                        height: 50.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Provider.of<Authentication>(context,
                                          listen: false)
                                      .logIntoAccount(
                                          context,
                                          documentSnapshot.useremail ?? '',
                                          documentSnapshot.userpassword ?? '')
                                      .whenComplete(() =>
                                          Navigator.pushReplacement(
                                              context,
                                              PageTransition(
                                                  child: Homepage(),
                                                  type: PageTransitionType
                                                      .leftToRight)));
                                },
                                icon: Icon(
                                  FontAwesomeIcons.check,
                                  color: constantColors.blueColor,
                                )),
                            IconButton(
                                onPressed: () {
                                  // Provider.of<FirebaseOperations>(context,
                                  //         listen: false)
                                  //     .deleteUserData(
                                  //         documentSnapshot.get('userid'));
                                  deleteUser(documentSnapshot.useremail ?? '')
                                  .whenComplete(() => setState(() {
                                  },));
                                },
                                icon: Icon(
                                  FontAwesomeIcons.trashAlt,
                                  color: constantColors.redColor,
                                ))
                          ],
                        ),
                      ),
                      leading: CircleAvatar(
                        backgroundColor: constantColors.darkColor,
                        backgroundImage:
                            NetworkImage(documentSnapshot.userimage ?? ''),
                      ),
                      subtitle: Text(documentSnapshot.useremail ?? '',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: constantColors.whiteColor,
                              fontSize: 12)),
                      title: Text(documentSnapshot.username ?? '',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: constantColors.greenColor)),
                    );
                  }).toList(),
                );
              }));
            }
          },
        ));
  }

  loginSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      thickness: 4.0,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'Enter email',
                        hintStyle: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: userPasswordController,
                      decoration: InputDecoration(
                        hintText: 'Enter password',
                        hintStyle: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ),
                  Expanded(
                    child: FloatingActionButton(
                        backgroundColor: constantColors.blueColor,
                        child: Icon(
                          FontAwesomeIcons.check,
                          color: constantColors.whiteColor,
                        ),
                        onPressed: () {
                          if (emailController.text.isNotEmpty) {
                            Provider.of<Authentication>(context, listen: false)
                                .logIntoAccount(context, emailController.text,
                                    userPasswordController.text);
                            // Provider.of<FirebaseOperations>(context,
                            //         listen: false)
                            //     .initUserData(context);
                          } else {
                            warningText(context, 'Fill all the data ');
                          }
                        }),
                  )
                ],
              ),
              decoration: BoxDecoration(
                  color: constantColors.blueGreyColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12))),
            ),
          );
        });
  }

  signInSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: constantColors.blueGreyColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12))),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                CircleAvatar(
                  backgroundImage: FileImage(
                      Provider.of<LandingUltis>(context, listen: false)
                          .getUserAvatar),
                  backgroundColor: constantColors.redColor,
                  radius: 80.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
                    controller: userNameController,
                    decoration: InputDecoration(
                      hintText: 'Enter name',
                      hintStyle: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'Enter email',
                      hintStyle: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
                    controller: userPasswordController,
                    decoration: InputDecoration(
                      hintText: 'Enter password',
                      hintStyle: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                  ),
                ),
                Expanded(
                  child: FloatingActionButton(
                      backgroundColor: constantColors.redColor,
                      child: Icon(
                        FontAwesomeIcons.check,
                        color: constantColors.whiteColor,
                      ),
                      onPressed: () {
                        if (emailController.text.isNotEmpty) {
                          Provider.of<Authentication>(context, listen: false)
                              .createAccount(emailController.text,
                                  userPasswordController.text)
                              .whenComplete(() {
                            print('creating collection...');
                            Provider.of<FirebaseOperations>(context,
                                    listen: false)
                                .createUserCollection(context, {
                              'userpassword': userPasswordController.text,
                              'useruid': Provider.of<Authentication>(context,
                                      listen: false)
                                  .getUserUid,
                              'useremail': emailController.text,
                              'username': userNameController.text,
                              'userimage': Provider.of<LandingUltis>(context,
                                      listen: false)
                                  .getUserAvatarURL
                            });
                          });
                        } else {
                          warningText(context, 'Fill all the data ');
                        }
                      }),
                )
              ]),
            ),
          );
        });
  }

  warningText(BuildContext context, String warning) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              color: constantColors.darkColor,
              borderRadius: BorderRadius.circular(15),
            ),
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(warning,
                  style: TextStyle(
                      color: constantColors.whiteColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ),
          );
        });
  }
}