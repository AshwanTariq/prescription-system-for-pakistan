import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:rxpakistan/apihandler.dart';
import 'package:rxpakistan/doctor/create_prescripton.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'dart:math' as math;

import '../doctor/doctor_model_file.dart';

class NearPlaces extends StatefulWidget {
   NearPlaces({Key? key, required this.lat, required this.long,required this.rxfinal})
      : super(key: key);

  final double lat;
  final double long;
 PrescriptionData rxfinal;

  @override
  _NearPlacesState createState() => _NearPlacesState();
}

class _NearPlacesState extends State<NearPlaces> {
  String word = 'Park';
  late double lat;
  late double long;

  bool loadingFlag = true;
  bool isSheetOpen = false;
  late PanelController panelController = PanelController();
  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));

  final Set<Marker> markers = new Set();

  late GoogleMapController mapController;
  TextEditingController textEditingController = TextEditingController();

  var api = ApiHandler();
  var _btnController=RoundedLoadingButtonController();


  //final places = GoogleMapsPlaces(apiKey: "AIzaSyCyLKdngx3JW6-27_282lKIWzmW9m46i_8");



  String _name(dynamic user) {
    return user["Name"];
  }

  String _address(dynamic user) {
    return user["address"];
  }
  Widget _rating(dynamic user) {
    double value= user["rating"] as double;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        RatingBarIndicator(
          rating: value,
          itemBuilder: (context, index) => const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          itemCount: 5,
          itemSize: 16.0,
          direction: Axis.horizontal,
        ),
        SizedBox(width: 2,),
        Text("$value")
      ],
    );
   
  }
  double getDistanceInKm(dynamic user){
     double sLat=user["lat"] as double;
     double sLong=user["long"] as double;
    final double distance = Geolocator.distanceBetween(lat,long,
        sLat, sLong);
    print(distance.toString());

   return distance * 0.001; //distance in meters
  }




  @override
  void initState() {
    // TODO: implement initState
    lat = widget.lat;
    long = widget.long;
    print('Lat is $lat and long is $long');




    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nearest Pharmacies"),
        leading: InkWell(
          splashColor: Colors.amber,
          onTap: () {
            if(panelController.isPanelOpen){
              panelController.close();
            }
            setState(() {});
            mapController.animateCamera(
                CameraUpdate.newLatLngZoom(
                    LatLng(lat, long), 5));

          },
          child: const Icon(
            FontAwesomeIcons.locationDot, // add custom icons also
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialLocation,
            markers: markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapToolbarEnabled: true,
            mapType: MapType.normal,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
          ),

          SlidingUpPanel(
            maxHeight: 390.0,
            slideDirection: SlideDirection.UP,
            controller: panelController,
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            panelSnapping: true,
            borderRadius: BorderRadius.only(topRight: Radius.circular(30),topLeft: Radius.circular(30)),
            panel: Container(
              child: FutureBuilder<dynamic>(
                future: api.getAllPharmacy("pharmacy", "getallpharmacy",(value){
                  loadingFlag=value;
                }, (value){
                  isSheetOpen=value;
                }),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  print("Loading falg $loadingFlag");
                  if (snapshot.hasData && loadingFlag) {
                    print(_address(snapshot.data[0]));
                    return ListView.builder(
                        padding: EdgeInsets.all(8),
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          markers.add(Marker( //add first marker
                            markerId: MarkerId(
                                snapshot.data[index]["username"]),
                            position: LatLng(snapshot
                                .data[index]["lat"],
                                snapshot
                                    .data[index]["long"]),
                            //position of marker
                            infoWindow: InfoWindow( //popup info
                              title: _name(snapshot.data[index]),
                              snippet: _address(snapshot.data[index]),
                            ),
                            icon: BitmapDescriptor
                                .defaultMarker, //Icon for Marker
                          ));
                          double dis= getDistanceInKm(snapshot.data[index]).floorToDouble();

                          return Card(
                            elevation: 6,
                            child: Column(
                              children: <Widget>[

                                ///MISSING IF CONDITION HERE FOR NEAREST PHARMACY


                                ListTile(
                                  leading: SizedBox(
                                    width:40,
                                    height: 40,
                                    child: RoundedLoadingButton(controller: _btnController, onPressed: ()async {
                                      print("Sending prescription");
                                      widget.rxfinal.PharmacyUName=snapshot.data[index]["username"];
                                      await ApiHandler().postrx("emr", "setrx", widget.rxfinal).then((value) {
                                        if(value){
                                          _btnController.success();
                                          Future.delayed(Duration(seconds: 2));
                                          //_btnController.reset();
                                          //Future.delayed(Duration(seconds: 2));
                                          //Navigator.pop(context);
                                        }else{
                                          _btnController.error();
                                          //Future.delayed(Duration(seconds: 2));
                                          //_btnController.reset();
                                        }
                                      }).catchError((error){
                                        _btnController.error();
                                      });
                                    }, child: Icon(FontAwesomeIcons.paperPlane),),
                                  ),
                                  title: Text("${_name(snapshot.data[index])} • ${(dis-5000).abs()}km"),
                                  subtitle: Text(_address(snapshot.data[index]),),
                                  trailing: _rating(snapshot.data[index]),
                                  onTap: () {
                                    panelController.close();
                                    double lat = snapshot
                                        .data[index]["lat"];
                                    double long = snapshot
                                        .data[index]["long"];
                                    mapController.animateCamera(
                                        CameraUpdate.newLatLngZoom(
                                            LatLng(lat, long), 16));
                                  },

                                )
                              ],
                            ),
                          );

                        });
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ),
          /*Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: ClipOval(
                child: Material(
                  color: Colors.orange, // button color
                  child: InkWell(
                    splashColor: Colors.white, // inkwell color
                    child: SizedBox(
                      width: 56,
                      height: 56,
                      child: Icon(LineIcons.alternateArrowCircleUp),
                    ),
                    onTap:(){
                      panelController.isAttached&&panelController.isPanelOpen?panelController.close():panelController.open();
                    }
                  ),
                ),
              ),
            ),
          ),*/
        ],
      ),
    );
  }
}