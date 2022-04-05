import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myapp/screens/HomePage/Homepage.dart';
import 'package:page_transition/page_transition.dart';

class Authentication with ChangeNotifier{
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  late String userUid;
  String get getUserUid => userUid;
  
  Future logIntoAccount(BuildContext context,String email, String password) async{
    print(email);
    UserCredential userCredential = await firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    User? user = userCredential.user;
    userUid = user!.uid;
    if(userUid!=""){
      Navigator.pushReplacement(
        context, 
        PageTransition(child: Homepage(), type: PageTransitionType.leftToRight));
    }
    print(userUid);
    print(email);
    print(password);
    notifyListeners();
  }

  Future logOutViaEmail(){
    return firebaseAuth.signOut();
  }

  Future createAccount(String email, String password) async{
    UserCredential userCredential = await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    User? user = userCredential.user;
    userUid = user!.uid;
    print(userUid);
    notifyListeners();
  }

  Future signInWithGoogle() async{
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;
    final AuthCredential authCredential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken
    );
    final UserCredential userCredential = await firebaseAuth.signInWithCredential(authCredential);
    final User? user = userCredential.user;
    assert(user?.uid !=null);
    userUid = user!.uid;
    print('Goolge user id => $userUid');
    notifyListeners();
  }

  Future signOutGoogle() async{
    return googleSignIn.signOut();
  }
}