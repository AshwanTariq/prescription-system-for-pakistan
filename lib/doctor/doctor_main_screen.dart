import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:rxpakistan/apihandler.dart';
import 'package:rxpakistan/doctor/create_prescripton.dart';
import 'package:rxpakistan/patinet/patient_model_file.dart';
import 'dart:convert' as convert;

import '../widgets/custom_widgets.dart';

class DocHomePage extends StatefulWidget {
  DocHomePage({Key? key, required this.docName}) : super(key: key);

  var docName;
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

  String sorting = "Sort";
  List<String> sortingbylist = ["date", "name"];
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  var rxid = 0;
  PatientData patientdetails = PatientData(
      username: "",
      password: "",
      Name: "",
      gender: "",
      disease: "",
      lat: 0.0,
      long: 0.0,
      role: 1);
  var apiHandler = ApiHandler();

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
            Docname: widget.docName,
            Patientdetails: patientdetails,
          ),
        ),
      ).whenComplete(() => _btnController.reset());
    });

    _btnController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Mywidgets.getDrawer(context, widget.docName),
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.all(8.0),
          child: Image.asset(
            "assets/images/logo.png",
          ),
        ),
        title: const Text("Patients", style: TextStyle(fontSize: 20)),
        actions: [
          /*DropdownButton<String>(
            icon: FaIcon(FontAwesomeIcons.sort,color: Colors.white,),
            items: sortingbylist.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              sorting = value!;
              setState(() {});
              print(sorting);
              print(value);
            },
          ),*/
          SizedBox(
            width: 5,
          ),
          Builder(builder: (context) {
            return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const FaIcon(
                  FontAwesomeIcons.bars,
                  size: 25,
                ));
          }),
        ],
      ),
      floatingActionButton: SizedBox(
        width: 150,
        height: 60,
        child: RoundedLoadingButton(
          color: Colors.red,
          elevation: 0,
          width: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Create Rx"),
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.add,
                size: 20,
              ),
            ],
          ),
          controller: _btnController,
          onPressed: _doSomething,
        ),
      ),
      body: FutureBuilder<dynamic>(
          future: apiHandler.getRecentPatients(
              "emr", "getRecentPatients", widget.docName.toString()),
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
                    onRefresh: () async => setState(() {}),
                    child: ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        print(list.length);
                        if (list.isNotEmpty) {
                          if (list[index] != null) {
                            String Alldisease =
                                list[index]["disease"].toString();

                            return MyListtile(
                              RxDetails: null,
                              title:
                                  "${list[index]["Name"].toString()} • ${list[index]["Gender"].toString() == "F" ? "Female" : "Male"}",
                              subtitle: Alldisease.replaceAll("?", ","),
                              rxid: rxid,
                              Docname: widget.docName,
                              long: list[index]["long"],
                              lat: list[index]["lat"],
                              flag: true,
                            );
                          } else {
                            return const Text("");
                          }
                        } else {
                          return Center(
                              child: Text("CREATE YOUR FIRST PREXCRIPTION"));
                        }
                      },
                    ),
                  ),
                );
              } else {
                return Center(child: Text("NO DATA FOUND"));
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
