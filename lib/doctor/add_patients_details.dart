import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../apihandler.dart';
import '../patinet/patient_model_file.dart';
import '../widgets/custom_widgets.dart';

class PatientsMiniEMR extends StatefulWidget {
  const PatientsMiniEMR({Key? key}) : super(key: key);

  @override
  _PatientsMiniEMRState createState() => _PatientsMiniEMRState();
}

class _PatientsMiniEMRState extends State<PatientsMiniEMR> {
  final RoundedLoadingButtonController _btnPatient =
      RoundedLoadingButtonController();

  String _verticalGroupValue = "Female";

  List<String> allDisease = [];
  List<String> _status = ["Female", "Male", "Other"];
  final conName = TextEditingController();
  var UserName;
  List<String> diseasel1 = [
    "Diabetes",
    "Depression",
    "Anxiety",
    "Hemorrhoid",
    "Yeast infection",
  ];
  List<String> diseasel2 = [
    'Lupus',
    "Shingles",
    "Psoriasis",
    "Schizophrenia",
    "Lyme disease"
  ];
  List<String> diseasel3 = [
    "HPV",
    "Herpes",
    "Pneumonia",
    "Fibromyalgia",
    "Scabies"
  ];
  List<String> diseasel4 = [
    "Chlamydia",
    "Endometriosis",
    "Strep throat",
    "Diverticulitis",
    "Bronchitis"
  ];
  double lat=33.6007,lng=73.0679;

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

    if(conName.text.isEmpty || lat ==0.0||lng==0.0) {
        _btnPatient.error();
        Future.delayed(Duration(seconds: 3), () {
          _btnPatient.reset();
      });
    }else{

      UserName=genrateUsername(conName.text);
      var Patient = PatientData(
        long:lng,
        password: 123,
        lat: lat,
        username: UserName,
        Name: conName.text,
        gender: getGender(_verticalGroupValue),
        disease: allDisease.join(""), role: 1,
      );
      bool chk = await ApiHandler().postPatient("emr", "setPatinet", Patient);
      if (chk) {
        _btnPatient.success();
        print("LAT IN PATIENT ${Patient.lat} \nLONG IN PATIENT  ${Patient.long}");
        Navigator.pop(context,Patient);
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
        title: Text("Patient EMR"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 50,
          ),
          FaIcon(
            FontAwesomeIcons.userInjured,
            size: 120,
          ),
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              controller: conName,
              decoration: const InputDecoration(
                prefixIcon: Icon(FontAwesomeIcons.user),
                hintText: "Patient's Name",
              ),
            ),
          ),
          SizedBox(
            height: 20,
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
                textStyle: const TextStyle(fontSize: 15,),
                itemBuilder: (item) => RadioButtonBuilder(
                  item,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 40,
          ),
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: diseasel1.length,
                itemBuilder: (context, index) {
                  return CustomDiseaseBox(
                    isSelected: (value) {
                      allDisease.add(value);
                      print(value);
                    },
                    data: diseasel1[index],
                  );
                }),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: diseasel2.length,
                itemBuilder: (context, index) {
                  return CustomDiseaseBox(
                    isSelected: (value) {
                      allDisease.add(value);
                      print(value);
                    },
                    data: diseasel2[index],
                  );
                }),
          ),
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: diseasel3.length,
                itemBuilder: (context, index) {
                  return CustomDiseaseBox(
                    isSelected: (value) {
                      allDisease.add(value);
                      print(value);
                    },
                    data: diseasel3[index],
                  );
                }),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: diseasel4.length,
                itemBuilder: (context, index) {
                  return CustomDiseaseBox(
                    isSelected: (value) {
                      allDisease.add(value);
                      print(value);
                    },
                    data: diseasel4[index],
                  );
                }),
          ),
          SizedBox(
            height: 60,
          ),
          ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CustomGoogleMaps(
              getlatlong: (latit, long) {
                lat=latit;
                lng=long;
                print("LATITTUDE AND LOGITUDE is  $lat , $lng");
              },
            );
          }));},child: Text("GET ADDRESS"),),
          SizedBox(
            height: 10,
          ),
          RoundedLoadingButton(
            child: Text("Add"),
            controller: _btnPatient,
            onPressed: _doSomething,
          ),
        ],
      ),
    );
  }
}
