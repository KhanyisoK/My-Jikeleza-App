import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

TextStyle simpleLabelStyle(){
  return TextStyle(color: Colors.black87 ,fontSize: 24,
  fontFamily: "Brand Bold");
}

TextStyle simpleTextStyle(){
  return TextStyle(color: Colors.black87 ,fontSize: 14,
      fontFamily: "Brand Bold");
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
    labelText: hintText,
    labelStyle: TextStyle(
      fontSize: 18.0
    ),
    hintText: hintText ,
    hintStyle: TextStyle(
      color: Colors.grey,
      fontSize: 10.0
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.green),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.black),
    ),
  );
}

BoxDecoration parentContainerStyle(){
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.only(
        topLeft: Radius.circular(18),
        topRight: Radius.circular(18)),
    boxShadow: [
      BoxShadow(
        color: Colors.black,
        blurRadius: 16.0,
        spreadRadius: 0.5,
        offset: Offset(0.7, 0.7),
      ),
    ],
  );
}

BoxDecoration childContainerStyle(){
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(5.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black54,
        blurRadius: 6.0,
        spreadRadius: 0.5,
        offset: Offset(0.7, 0.7),
      ),
    ],
  );
}

//hamburger Button for drawer
BoxDecoration hamburgerButtonForDrawerStyle(){
  return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black,
          blurRadius: 6.0,
          spreadRadius: 0.5,
          offset: Offset(0.7, 0.7),
        )
      ]
  );
}

//Search Box Decoration from SearchScreen
BoxDecoration searchScreenBoxDecStyle(){
  return BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black,
          blurRadius: 6.0,
          spreadRadius: 0.5,
          offset: Offset(0.7, 0.7),
        )
      ]
  );
}

//pick up location input decoration in Search Screen
InputDecoration pickUpLocationStyle(String hintText){
  return InputDecoration(
      hintText: hintText,
      fillColor: Colors.grey[400],
      filled: true,
      border: InputBorder.none,
      isDense: true,
      contentPadding: EdgeInsets.only(left: 11.0,
      top: 8.0, bottom: 8.0));
}

TextStyle simpleButtonTextStyle(){
  return TextStyle(color: Colors.white,fontSize: 18);
}

TextStyle dontHaveAccountButtonTextStyle(){
  return TextStyle(color: Colors.black,fontSize: 18);
}

displayToastMessageGreen(String message){

  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0
  );
}

displayToastMessageOrange(String message){

  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.orange,
      textColor: Colors.white,
      fontSize: 16.0
  );
}

displayToastMessageRed(String message){

  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
  );
}