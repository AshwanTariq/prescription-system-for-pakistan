import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:rxpakistan/apihandler.dart';
import 'package:rxpakistan/doctor/create_prescripton.dart';
import 'package:rxpakistan/patinet/patient_model_file.dart';
import 'dart:convert' as convert;

import '../widgets/custom_widgets.dart';

class DocHomePage extends StatefulWidget {
  const DocHomePage({Key? key}) : super(key: key);

  @override
  State<DocHomePage> createState() => _DocHomePageState();
}

class _DocHomePageState extends State<DocHomePage> {
  /*void postData() async
  {

    var dio=Dio();
    var response = await dio.post("http://192.168.100.23/task1/api/user/adddrug",data: convert.jsonEncode(Drug(
        Did: 12,
        DName: "Welchol",
        DExpDate: "2023-18-3",DStatus: 1,DType: "Tablet")),onSendProgress: (a,b){
      print("Send Progress $a and $b");

    },onReceiveProgress: (a,b){
      print("Recive Progress $a and $b");
    });
    print(response.data.toString());
  }*/

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  var docName = "ali";
  var rxid = 0;
  PatientData patientdetails = PatientData(
      username: "",
      password: "",
      Name: "",
      gender: "",
      disease: "",
      lat: 0.0,
      long: 0.0);
  var apiHandler = ApiHandler();
  double lat = 0.0, long = 0.0;

  void _doSomething() async {
    await apiHandler
        .getPrescriptionCount("emr", "getprescriptioncount")
        .then((value) {
      rxid = value;
      rxid++;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Prescription(
            rxid: rxid,
            show: true,
            Docname: docName,
            Patientdetails: patientdetails,
          ),
        ),
      );
    });

    _btnController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Patients", style: TextStyle(fontSize: 20)),
        actions: [
          SizedBox(
            width: 60,
            height: 30,
            child: RoundedLoadingButton(
              elevation: 0,
              width: 50,
              child: const Icon(
                Icons.add,
                size: 20,
              ),
              controller: _btnController,
              onPressed: _doSomething,
            ),
          ),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.account_box_rounded,
                size: 35,
              )),
        ],
      ),
      body: FutureBuilder<dynamic>(
          future: apiHandler.getRecentPatients(
              "emr", "getRecentPatients", docName.toString()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text("ERROR IN PROGRAM"),
                );
              }
              if (snapshot.hasData) {
                List<dynamic> list = snapshot.data;

                return Container(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      setState(() {

                      });
                    },
                    child: ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        if (list[index] != null) {
                          String Alldisease = list[index]["disease"].toString();
                          lat = list[index]["lat"];
                          long = list[index]["long"];
                          return MyListtile(
                            RxDetails: null,
                            title:
                                "${list[index]["Name"].toString()} • ${list[index]["Gender"].toString() == "F" ? "Female" : "Male"}",
                            subtitle: Alldisease.replaceAll("?", ","),
                            rxid: rxid,
                            Docname: docName,
                            long: list[index]["lat"],
                            lat: list[index]["long"], flag: true,

                          );
                        } else {
                          return const Text("");
                        }
                      },
                    ),
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }
            return Center(child: Text('LAST RETURN EXECUTED'));
          }),
    );
  }
}

class Drug {
  int Did;
  String DName;
  int DStatus;
  String DType;
  String DExpDate;
  Drug(
      {required this.Did,
      required this.DName,
      required this.DStatus,
      required this.DExpDate,
      required this.DType});
  Map toJson() => {
        'Did': Did,
        'DName': DName,
        'DStatus': DStatus,
        'DExpDate': DExpDate,
        'DType': DType,
      };
}
