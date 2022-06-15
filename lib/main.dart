// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/constants/Constantcolors.dart';
import 'package:myapp/firebase_options.dart';
import 'package:myapp/screens/ChatRoom/ChatroomHelpers.dart';
import 'package:myapp/screens/CommentPage/commentHelpers.dart';
import 'package:myapp/screens/Feed/FeedHelpers.dart';
import 'package:myapp/screens/HomePage/HomepageHelpers.dart';
import 'package:myapp/screens/LandingPage/landingHelpers.dart';
import 'package:myapp/screens/LandingPage/landingServices.dart';
import 'package:myapp/screens/LandingPage/landingUtils.dart';
import 'package:myapp/screens/Messaging/GroupMessageHelpers.dart';
import 'package:myapp/screens/Profile/ProfileHelpers.dart';
import 'package:myapp/screens/SplashScreen/splashScreen.dart';
import 'package:myapp/services/Authentication.dart';
import 'package:myapp/services/FirebaseOperations.dart';
import 'package:myapp/utils/PostOptions.dart';
import 'package:myapp/utils/UploadPost.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ConstantColors constantColors = ConstantColors();
    return MultiProvider(
        child: MaterialApp(
          home: SplashScreen(),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              accentColor: constantColors.blueColor,
              fontFamily: 'Poppins',
              canvasColor: Colors.transparent),
        ),
        providers: [
          ChangeNotifierProvider(create: (_) => PostFunctions()),
          ChangeNotifierProvider(create: (_) => FeedHelpers()),
          ChangeNotifierProvider(create: (_) => UploadPost()),
          ChangeNotifierProvider(create: (_) => ProfileHelpers()),
          ChangeNotifierProvider(create: (_) => HomepageHelpers()),
          ChangeNotifierProvider(create: (_) => FirebaseOperations()),
          ChangeNotifierProvider(create: (_) => LandingServices()),
          ChangeNotifierProvider(create: (_) => Authentication()),
          ChangeNotifierProvider(create: (_) => LandingHelpers()),
          ChangeNotifierProvider(create: (_) => LandingUltis()),
          ChangeNotifierProvider(create: (_) => CommentHelpers()),
          ChangeNotifierProvider(create: (_) => ChatroomHeplers()),
          ChangeNotifierProvider(create: (_) => GroupMessageHelpers()),
        ]);
  }
}
