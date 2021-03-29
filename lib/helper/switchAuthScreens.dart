import 'package:flutter/material.dart';
import 'package:myjikelezaapp/screens/loginScreen.dart';
import 'package:myjikelezaapp/screens/registrationScreen.dart';

class SwitchAuthScreens extends StatefulWidget {
  static const String idScreen = "authScreen";
  @override
  _SwitchAuthScreensState createState() => _SwitchAuthScreensState();
}

class _SwitchAuthScreensState extends State<SwitchAuthScreens> {
  bool showSignIn = true;

  void toggleView(){
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn){
      return LoginScreen(toggleView);
    } else {
      return RegistrationScreen(toggleView);
    }
  }
}
