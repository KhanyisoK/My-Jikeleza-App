import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:myjikelezaapp/models/user.dart';

import '../main.dart';

class AuthMethods {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Users _userFromFirebaseUser(User user) {
    return user !=null ? Users(userId: user.uid) : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword
        (email: email, password: password);

      User firebaseUser = result.user;
      userRef.child(firebaseUser.uid).once().then((DataSnapshot snaps) {
        if(snaps.value != null){
          print("Success Login: ${snaps.value}");
          return _userFromFirebaseUser(firebaseUser);
        }
        else{
          print("Failed Login: ${snaps.value}");
          return null;
        }
      });

    }
    catch(e){
      print("error user login: ${e.toString()}");
    }
  }

  Future signUpWithEmailAndPassword(String email, String password, userMap) async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword
        (email: email, password: password);

      User firebaseUser = result.user;
      userRef.child(firebaseUser.uid).set(userMap);
      return _userFromFirebaseUser(firebaseUser);
    }
    catch(e){
      print(e.toString());
    }
  }


  Future resetPassword(String email) async {
    try{
      return await _auth.sendPasswordResetEmail(email: email);
    }
    catch(e){
      print(e.toString());
    }
  }

  Future signOut() async {
    try{
      return await _auth.signOut();
    }
    catch(e){
      print(e.toString());
    }
  }
}