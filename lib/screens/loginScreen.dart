import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myjikelezaapp/services/auth.dart';
import 'package:myjikelezaapp/services/database.dart';
import 'package:myjikelezaapp/widgetStyles/loadingSpinner.dart';
import 'package:myjikelezaapp/widgetStyles/widgetStyles.dart';

import '../main.dart';
import 'mainScreen.dart';

class LoginScreen extends StatefulWidget {
  final Function toggle;
  static const String idScreen = "login";

  LoginScreen(this.toggle);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  QuerySnapshot snapshotUserInfo;
  final formKey = GlobalKey<FormState>();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  AuthMethods authMethods = new AuthMethods();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: ListView(
        shrinkWrap: true,
        children: [
          Container(
            height: MediaQuery.of(context).size.height - 50,
            alignment: Alignment.center,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        SizedBox(height: 5.0),
                        Image(
                          image: AssetImage("images/logo.png"),
                          width: 390.0,
                          height: 250.0,
                          alignment: Alignment.center,
                        ),
                        SizedBox(height: 10.0),
                        Text("Login As Rider", style: simpleLabelStyle()),
                        SizedBox(height: 5.0),
                        TextFormField(
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val)
                                  ? null
                                  : "Please Enter Valid Email";
                            },
                            controller: emailController,
                            style: simpleTextStyle(),
                            decoration: textFieldInputDecoration("email")),
                        TextFormField(
                            obscureText: true,
                            validator: (val) {
                              return val.length > 6
                                  ? null
                                  : "Please Enter Password must be 6+ characters";
                            },
                            controller: passwordController,
                            style: simpleTextStyle(),
                            decoration: textFieldInputDecoration("password")),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        "Forgot Password",
                        style: simpleTextStyle(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  GestureDetector(
                    onTap: () {
                      signIn(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(30)),
                      child: Text(
                        "Sign In",
                        style: simpleButtonTextStyle(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(30)),
                    child: Text(
                      "Sign In with Google",
                      style: TextStyle(color: Colors.black87, fontSize: 17),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Don't have a account? ",
                        style: dontHaveAccountButtonTextStyle(),
                      ),
                      GestureDetector(
                        onTap: () {
                          widget.toggle();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            "Register now",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  signIn(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return LoadingSpinner(
            message: "Logging In...",
          );
        });

    if (formKey.currentState.validate()) {
      final User firebaseUser = (await _firebaseAuth
              .signInWithEmailAndPassword(
                  email: emailController.text,
                  password: passwordController.text)
              .catchError((errorMsg) {
        Navigator.pop(context);
        displayToastMessageRed("${errorMsg.toString()}");
      }))
          .user;

      /*HelperFunctions.saveUserEmailSharedPreference(emailController.text);
    HelperFunctions.saveUserNameSharedPreference(userNameController.text);*/

      setState(() {
        isLoading = true;
      });

      if (firebaseUser != null) {
        userRef.child(firebaseUser.uid).once().then((DataSnapshot snap) {
          if (snap.value != null) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => MainScreen()));
            displayToastMessageGreen("Welcome Back");
          } else {
            Navigator.pop(context);
            _firebaseAuth.signOut();
            displayToastMessageOrange("No Record Found!");
          }
        });
      } else {
        Navigator.pop(context);
        displayToastMessageRed("Error Occured, Can Not Login!");
      }
    }
  }
}
