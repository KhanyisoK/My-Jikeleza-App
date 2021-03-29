import 'package:flutter/cupertino.dart';
import 'package:myjikelezaapp/models/address.dart';

class AppData extends ChangeNotifier{

  Address pickUpLocation, dropOffLocation;

  void updatePickUpLocationAddress(Address pickUpAddress){
    pickUpLocation = pickUpAddress;
    notifyListeners();
  }
  void updateDropOffLocation(Address dropOffAddress){
    dropOffLocation = dropOffAddress;
    notifyListeners();
  }
}