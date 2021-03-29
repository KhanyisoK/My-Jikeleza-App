import 'package:flutter/material.dart';
import 'package:myjikelezaapp/DataHandler/appData.dart';
import 'package:myjikelezaapp/configMaps.dart';
import 'package:myjikelezaapp/models/address.dart';
import 'package:myjikelezaapp/models/placePredictions.dart';
import 'package:myjikelezaapp/services/request_services.dart';
import 'package:myjikelezaapp/widgetStyles/divider.dart';
import 'package:myjikelezaapp/widgetStyles/loadingSpinner.dart';
import 'package:myjikelezaapp/widgetStyles/widgetStyles.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController pickUpTextController = new TextEditingController();
  TextEditingController dropOffTextController = new TextEditingController();
  List<PlacePredictions> placePredictionList = [];

  @override
  Widget build(BuildContext context) {
    String placeAddress =
        Provider.of<AppData>(context).pickUpLocation.placeName ?? "";
    pickUpTextController.text = placeAddress;

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 215,
            decoration: searchScreenBoxDecStyle(),
            child: Padding(
              padding:
                  EdgeInsets.only(left: 25, right: 25, top: 25.0, bottom: 20),
              child: Column(
                children: [
                  SizedBox(height: 5.0),
                  Stack(
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back)),
                      Center(
                        child: Text("Search Destination",
                            style: TextStyle(
                                fontSize: 18.0, fontFamily: "Brand-Bold")),
                      )
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Image.asset("images/pickicon.png",
                          height: 16.0, width: 16.0),
                      SizedBox(width: 18.0),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: TextField(
                              controller: pickUpTextController,
                              decoration:
                                  pickUpLocationStyle("PickUp Location"),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: [
                      Image.asset("images/desticon.png",
                          height: 16.0, width: 16.0),
                      SizedBox(width: 18.0),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: TextField(
                              onChanged: (val) {
                                findPlace(val);
                              },
                              controller: dropOffTextController,
                              decoration: pickUpLocationStyle("Where to?"),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 10.0),
          (placePredictionList.length > 0)
              ? Flexible(
                child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    child: ListView.separated(
                      padding: EdgeInsets.all(0.0),
                      itemBuilder: (context, index) {
                        return PredictionTile(
                          placePredictions: placePredictionList[index],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          DividerWidget(),
                      itemCount: placePredictionList.length,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                    ),
                  ),
              )
              : Container()
        ],
      ),
    );
  }

  void findPlace(String placeName) async {
    if (placeName.length > 1) {
      String autoCompleteUrl =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=1234567890&components=country:za";

      var res = await RequestServices.getRequest(autoCompleteUrl);

      if (res == "failed") {
        return;
      } else {
        if (res["status"] == "OK") {
          var predictions = res["predictions"];

          var placeList = (predictions as List)
              .map((e) => PlacePredictions.fromJson(e))
              .toList();
          setState(() {
            placePredictionList = placeList;
          });
        }
      }
    }
  }
}

class PredictionTile extends StatelessWidget {
  final PlacePredictions placePredictions;

  PredictionTile({Key key, this.placePredictions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0.0),
      onPressed: () {
        getPlaceAddressDetails(placePredictions.place_id, context);
      },
      child: Container(
          child: Column(
        children: [
          SizedBox(height: 10.0),
          Row(
            children: [
              Icon(Icons.add_location),
              SizedBox(width: 14.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.0),
                    Text(placePredictions.main_text,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16.0)),
                    SizedBox(height: 2.0),
                    Text(placePredictions.secondary_text,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12.0, color: Colors.grey)),
                    SizedBox(height: 8.0),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 10.0),
        ],
      )),
    );
  }

  void getPlaceAddressDetails(String placeId, context) async{

    showDialog(context: context, builder: (BuildContext context) =>
    LoadingSpinner(message: "Setting Destination, please wait...",));

    String placeDetailsUrl = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";

    var res = await RequestServices.getRequest(placeDetailsUrl);

    Navigator.pop(context);

    if(res == "failed"){
      return;
    }
    if(res["status"] == "OK"){
      Address address = Address();
      address.placeName = res["result"]["name"];
      address.placeId = placeId;
      address.latitude = res["result"]["geometry"]["location"]["lat"];
      address.longitude = res["result"]["geometry"]["location"]["lng"];

      Provider.of<AppData>(context, listen: false).updateDropOffLocation(address);
      print("DropOff Lok:: ${address.placeName}");

      Navigator.pop(context, "obtainDirection");
    }
  }
}
