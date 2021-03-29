import 'package:flutter/material.dart';
import 'package:myjikelezaapp/helper/helperFunction.dart';
import 'package:myjikelezaapp/services/auth.dart';
import 'package:myjikelezaapp/services/database.dart';
import 'package:myjikelezaapp/widgetStyles/widgetStyles.dart';

import 'mainScreen.dart';

class RegistrationScreen extends StatefulWidget {
  final Function toggle;
  static const String idScreen = "register";

  RegistrationScreen(this.toggle);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  AuthMethods authMethods = new AuthMethods();
  TextEditingController userNameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneNumberController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
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
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(height: 5.0),
                                  Image(
                                    image: AssetImage("images/logo.png"),
                                    width: 390.0,
                                    height: 250.0,
                                    alignment: Alignment.center,
                                  ),
                                  SizedBox(height: 5.0),
                                  Text("Register As Rider",
                                      style: simpleLabelStyle()),
                                  TextFormField(
                                      keyboardType: TextInputType.text,
                                      validator: (val) {
                                        return val.isEmpty || val.length < 4
                                            ? "Name Must Have 4 Characters or More"
                                            : null;
                                      },
                                      controller: userNameController,
                                      style: simpleTextStyle(),
                                      decoration:
                                          textFieldInputDecoration("username")),
                                  TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (val) {
                                        return RegExp(
                                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                .hasMatch(val)
                                            ? null
                                            : "Please Enter Valid Email";
                                      },
                                      controller: emailController,
                                      style: simpleTextStyle(),
                                      decoration:
                                          textFieldInputDecoration("email")),
                                  TextFormField(
                                      keyboardType: TextInputType.phone,
                                      validator: (val) {
                                        return val.isEmpty || val.length < 10
                                            ? "Please Enter Valid Number"
                                            : null;
                                      },
                                      controller: phoneNumberController,
                                      style: simpleTextStyle(),
                                      decoration: textFieldInputDecoration(
                                          "phone number")),
                                  TextFormField(
                                      obscureText: true,
                                      validator: (val) {
                                        return val.length > 6
                                            ? null
                                            : "Please Enter Password must be 6+ characters";
                                      },
                                      controller: passwordController,
                                      style: simpleTextStyle(),
                                      decoration:
                                          textFieldInputDecoration("password")),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Text(
                                "Forgot Password",
                                style: simpleTextStyle(),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              registerNewUser();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.symmetric(vertical: 20),
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(30)),
                              child: Text(
                                "Register",
                                style: simpleButtonTextStyle(),
                              ),
                            ),
                          ),
                          /*Container(
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
                  ),*/
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Already have a account? ",
                                    style: dontHaveAccountButtonTextStyle()),
                                GestureDetector(
                                  onTap: () {
                                    widget.toggle();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    child: Text("Login now",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 17,
                                            decoration:
                                                TextDecoration.underline)),
                                  ),
                                )
                              ]),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  registerNewUser() {
    if (formKey.currentState.validate()) {
      Map<String, String> userInfoMap = {
        "name": userNameController.text,
        "email": emailController.text,
        "phone": phoneNumberController.text,
      };

      HelperFunctions.saveUserEmailSharedPreference(emailController.text);
      HelperFunctions.saveUserNameSharedPreference(userNameController.text);

      setState(() {
        isLoading = true;
      });

      authMethods
          .signUpWithEmailAndPassword(
              emailController.text, passwordController.text, userInfoMap)
          .then((val) {
        databaseMethods.uploadUserInfo(userInfoMap);
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainScreen()));
      });
    }
  }
}
