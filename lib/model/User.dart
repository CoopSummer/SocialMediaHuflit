import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Users {
  late String? userimage, useremail, username, userpassword;
  Users(
      {this.userimage,
      this.useremail,
      this.username,
      // this.useruid,
      this.userpassword});
  factory Users.fromJson(Map<String, dynamic> jsonData) {
    return Users(
      // useruid: jsonData['useruid'],
      userimage: jsonData['userimage'],
      useremail: jsonData['useremail'],
      userpassword: jsonData['userpassword'],
      username: jsonData['username'],
    );
  }
  static Map<String, dynamic> toMap(Users user) => {
        'userimage': user.userimage,
        'useremail': user.useremail,
        'username': user.username,
        // 'useruid': user.useruid,
        'userpassword': user.userpassword,
      };

  static String encode(List<dynamic> users) => json.encode(
        users.map<Map<String, dynamic>>((user) => Users.toMap(user)).toList(),
      );

  static List<Users> decode(String users) =>
      (json.decode(users) as List<dynamic>)
          .map<Users>((item) => Users.fromJson(item))
          .toList();

  static Future<dynamic> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.reload();
    final String jsonString = prefs.getString('users') ?? '[]';
    // final List<dynamic> jsonResponse = json.decode(jsonString) ?? json.decode('[]');
    final List<dynamic> jsonResponse = json.decode(jsonString);
    return jsonResponse;
  }
}

class UserList{
  List<Users> users;
  UserList({
    required this.users 
  });

  factory UserList.fromJson(List<dynamic> parsedJson){
    List<Users> users = parsedJson.map((e) => Users.fromJson(e)).toList();
    return UserList(users: users);
  }
}