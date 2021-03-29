import 'package:flutter/material.dart';

class LoadingSpinner extends StatelessWidget {

  String message;
  LoadingSpinner({this.message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.yellow,
      child: Container(
        margin: EdgeInsets.all(15.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            children: [
              SizedBox(height: 6.0),
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black),),
              SizedBox(width: 26),
              Flexible(
                child: Text(message, overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.black),),
              )
            ],
          ),
        ),
      ),
    );
  }
}
