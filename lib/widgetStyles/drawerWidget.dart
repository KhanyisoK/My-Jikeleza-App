import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: 260.0,
      child: Drawer(
        child: ListView(
          children: [
            Container(
              height: 165.0,
              child: DrawerHeader(
                decoration: BoxDecoration(color: Colors.white),
                child: Row(
                  children: [
                    Image.asset("images/user_icon.png",
                      height: 65.0, width: 65.0,),
                    SizedBox(width: 16.0,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Profile Name", style: TextStyle(fontSize: 16.0, fontFamily: "Brand-Bold"),),
                        SizedBox(height: 6.0),
                        Text("Visit Profile"),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Divider(),
            SizedBox(height: 12),
            //Drawer Body Controller
            ListTile(
              leading: Icon(Icons.history),
              title: Text("History", style: TextStyle(fontSize: 15.0),),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Visit Profile", style: TextStyle(fontSize: 15.0),),
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text("About", style: TextStyle(fontSize: 15.0),),
            ),
          ],
        ),
      ),
    );
  }
}
