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

class DoctorSignUpPage extends StatefulWidget {
  const DoctorSignUpPage({Key? key}) : super(key: key);

  @override
  _DoctorSignUpPageState createState() => _DoctorSignUpPageState();
}

class _DoctorSignUpPageState extends State<DoctorSignUpPage> {
  final RoundedLoadingButtonController _btnPatient =
      RoundedLoadingButtonController();

  String _verticalGroupValue = "Female";
  List<String> _status = ["Female", "Male", "Other"];
  final conName = TextEditingController();
  final conPassword = TextEditingController();
  final conClinic = TextEditingController();
  final conUsername = TextEditingController();
  var UserName;

  double lat = 33.6007, lng = 73.0679;

  String genrateUsername(String value) {
    int temp = Random().nextInt(200);
    String userName = value.toLowerCase();
    return "$userName$temp";
  }

  String getGender(String value) {
    if (value == "Female") {
      return "F";
    } else {
      if (value == "Male") {
        return "M";
      }
      return "Other";
    }
  }

  void _doSomething() async {
    //List<String> list=await apiHandler.getAllDrugs("emr", "getAllDrugs");

    if (conName.text.isEmpty || lat == 0.0 || lng == 0.0) {
      _btnPatient.error();
      Future.delayed(Duration(seconds: 3), () {
        _btnPatient.reset();
      });
    } else {
      UserName = conUsername.text;

      var Doctor = DoctorData(
        password: conPassword.text,
        username: UserName,
        Name: conName.text,
         spec: specialily, clinics: [], role: 2,
      );
      Doctor.clinics.add(ClinicData(CName: conClinic.text, DusernameFK: UserName, Lat: lat, Long: lng));
      bool chk = await ApiHandler().postDoctor("clinic", "setDoctor", Doctor);  // CHANGING CONTOLLER AND  ACTION
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

  String specialily = "Specialily";
  List<String> specialilylist = [
    "Lungs",
    "Cardiologists",
    "Geriatric Medicine Specialists",
    "ENT",
    "Cardiologists",
    "Ophthalmologists",
    "Gastroenterologists",
    "Oncologists",
    "Endocrinologists",
    "Gastroenterologists",
    "Arthritis",
    "Cardiologists",
    "Allergy ",
    "Dermatologists",
    "Physiatrists"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Doctor Signup"),
        leading: Lottie.asset("assets/animations/doctor.json"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

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
                prefixIcon: Icon(FontAwesomeIcons.userDoctor),
                hintText: "Doctor Full Name",
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
          DropdownButton<String>(
            hint: Text(specialily),
            icon: FaIcon(FontAwesomeIcons.skull),
            items: specialilylist.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              specialily = value!;
              setState(() {});
              print(specialily);
              print(value);
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RadioGroup<String>.builder(
                direction: Axis.horizontal,
                groupValue: _verticalGroupValue,
                horizontalAlignment: MainAxisAlignment.spaceAround,
                onChanged: (value) => setState(() {
                  print(value);
                  _verticalGroupValue = value!;
                }),
                items: _status,
                textStyle: const TextStyle(
                  fontSize: 15,
                ),
                itemBuilder: (item) => RadioButtonBuilder(
                  item,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 40,
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
            child: Text("PICK CLINIC ADDRESS"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              controller: conClinic,
              decoration: const InputDecoration(
                prefixIcon: Icon(FontAwesomeIcons.lock),
                hintText: "Clinic Name",
              ),
            ),
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
    );
  }
}

class ClinicData {
  String DusernameFK;
  String CName;
  double Lat;
  double Long;
  ClinicData(
      {required this.CName,
      required this.DusernameFK,
      required this.Lat,
      required this.Long});
  Map toJson() =>
      {"CName": CName, "DusernameFK": DusernameFK, "Lat": Lat, "Long": Long};
}

class DoctorData {
  var username, password, Name;
  int role;
  String spec;
  List<ClinicData> clinics;
  DoctorData(
      {required this.username,
      required this.password,
      required this.Name,
      required this.role,
      required this.spec,
      required this.clinics});
  Map toJson() => {
        'DUsername': username,
        'DPassword': password,
        'DName': Name,
    'DSpeciality':spec,
        'role': role,
        'Clinic': clinics,
      };
}
