import 'package:flutter/cupertino.dart';

class LandingHelpers with ChangeNotifier{
  Widget bodyImage(BuildContext context){
    return Container(
      height: MediaQuery.of(context).size.height*0.65,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/login.png'))
      ),
    );
  }
}