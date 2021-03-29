import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myjikelezaapp/DataHandler/appData.dart';
import 'package:myjikelezaapp/configMaps.dart';
import 'package:myjikelezaapp/models/address.dart';
import 'package:myjikelezaapp/models/directionDetails.dart';
import 'package:myjikelezaapp/models/user.dart';
import 'package:myjikelezaapp/models/users.dart';
import 'package:myjikelezaapp/services/request_services.dart';
import 'package:provider/provider.dart';

class AssistantMethods {

  static Future<String> searchCoordinateAddress(Position position, context) async {
    String placeAddress = "";
    String st1, st2, st3, st4;
    String url  = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyCM_Kd_Kw_9ynHuvtOgYn0M_WBsKdiRWIk";

    var response = await RequestServices.getRequest(url);

    if(response != "failed"){
      /*placeAddress = response["results"][0]["formatted_address"];*/
      st1 = placeAddress = response["results"][0]["address_components"][0]["long_name"];
      st2 = placeAddress = response["results"][0]["address_components"][1]["long_name"];
      st3 = placeAddress = response["results"][0]["address_components"][2]["long_name"];
      st4 = placeAddress = response["results"][0]["address_components"][3]["long_name"];

      placeAddress = st1 + ", " + st2 + ", " + st3 + ", " + st4;

      Address userPickUpAddress = new Address();
      userPickUpAddress.longitude = position.longitude;
      userPickUpAddress.latitude = position.latitude;
      userPickUpAddress.placeName = placeAddress;

      Provider.of<AppData>(context, listen: false).updatePickUpLocationAddress(userPickUpAddress);
    }

    return placeAddress;
  }

  static Future<DirectionDetails> obtainPlaceDirectionDetails(LatLng initialPosition, LatLng finalPosition) async {
    String placeDirectionUrl =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=$mapKey";

    var res = await RequestServices.getRequest(placeDirectionUrl);

    if(res == "failed"){
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails();

    directionDetails.encodedPoints = res["routes"][0]["overview_polyline"]["points"];

    directionDetails.distanceText = res["routes"][0]["legs"][0]["distance"]["text"];
    directionDetails.distanceValue = res["routes"][0]["legs"][0]["distance"]["value"];

    directionDetails.durationText = res["routes"][0]["legs"][0]["duration"]["text"];
    directionDetails.durationValue = res["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetails;
  }

  static int calculateFares(DirectionDetails directionDetails) {

    //in terms USD
    double timeTraveledFare = (directionDetails.durationValue / 60) * 0.2;
    double distanceTraveledFare = (directionDetails.distanceValue / 1000) * 0.20;
    double totalFareAmount = timeTraveledFare + distanceTraveledFare;

    //$1 = 14.88
    double totalLocalAmount = totalFareAmount * 14.88;
    return totalLocalAmount.truncate();
  }

  static void getCurrentOnlineUserInfo() async {
    firebaseUser = await FirebaseAuth.instance.currentUser;
    String userId = firebaseUser.uid;
    DatabaseReference reference = FirebaseDatabase.instance.reference().
    child("users").child(userId);

    reference.once().then((DataSnapshot dataSnapshot) {
      if(dataSnapshot.value != null) {
        /*userCurrentInfo = ;*/
      }
    });
  }
}