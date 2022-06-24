import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:lottie/lottie.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../apihandler.dart';
import '../patinet/patient_model_file.dart';
import '../widgets/custom_widgets.dart';

class PharmacySignUpPage extends StatefulWidget {
  const PharmacySignUpPage({Key? key}) : super(key: key);

  @override
  _PharmacySignUpPageState createState() => _PharmacySignUpPageState();
}

class _PharmacySignUpPageState extends State<PharmacySignUpPage> {
  final RoundedLoadingButtonController _btnPatient =
  RoundedLoadingButtonController();



  List<String> allDisease = [];
  List<String> _status = ["Female", "Male", "Other"];
  final conName = TextEditingController();
  final conAddress = TextEditingController();
  final conPassword = TextEditingController();
  final conUsername = TextEditingController();
  var UserName;

  double lat = 0.0, lng = 0.0;

  String genrateUsername(String value) {
    int temp = Random().nextInt(200);
    String userName = value.toLowerCase();
    return "$userName$temp";
  }



  void _doSomething() async {


    if (conName.text.isEmpty || lat == 0.0 || lng == 0.0) {
      _btnPatient.error();
      Future.delayed(Duration(seconds: 3), () {
        _btnPatient.reset();
      });
    } else {
      UserName = conUsername.text;
      var Pharmacy = PharmacyData(username: conUsername.text, password: conPassword.text, Name: conName.text, role: 3, address: conAddress.text, lat: lat, long: lng, rating: 5.0);
      bool chk = await ApiHandler().postPharmacy("Pharmacy", "setPharmacy", Pharmacy);
      if (chk) {
        _btnPatient.success();

      } else {
        _btnPatient.error();
        Future.delayed(Duration(seconds: 3), () {
          _btnPatient.reset();
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Pharmacy Signup"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Lottie.asset("assets/animations/pharmacist.json",width: 200,height: 200),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                controller: conUsername,
                decoration: const InputDecoration(
                  prefixIcon: Icon(FontAwesomeIcons.userLock),
                  hintText: "username",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                controller: conName,
                decoration: const InputDecoration(
                  prefixIcon: Icon(FontAwesomeIcons.hospital),
                  hintText: "Pharmacy Full Name",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                controller: conAddress,
                decoration: const InputDecoration(
                  prefixIcon: Icon(FontAwesomeIcons.addressCard),
                  hintText: "Full Address",
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                controller: conPassword,
                decoration: const InputDecoration(
                  prefixIcon: Icon(FontAwesomeIcons.lock),
                  hintText: "Password",
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return CustomGoogleMaps(
                    getlatlong: (latit, long) {
                      lat = latit;
                      lng = long;
                      print("LATITTUDE AND LOGITUDE is  $lat , $lng");
                    },
                  );
                }));
              },
              child: Text("PICK PHARMACY ADDRESS"),
            ),
            SizedBox(
              height: 10,
            ),
            RoundedLoadingButton(
              child: Text("Signup"),
              controller: _btnPatient,
              onPressed: _doSomething,
            ),
          ],
        ),
      ),
    );
  }
}


class PharmacyData {
  var username, password, Name;
  int role;
  String address;
  double lat, long,rating;

  PharmacyData(
      { required this.username,
        required this.password,
        required this.Name,
        required this.role,
        required this.address,
        required this.lat,
        required this.long,
        required this.rating,
       });
  Map toJson() => {
    'username': username,
    'password': password,
    'Name': Name,
    'role': role,
    'lat': lat,
    'long': long,
    'address': address,
    'rating':rating
  };
}
