import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rxpakistan/apihandler.dart';
import 'package:rxpakistan/pharmacy/un_notified_rx.dart';
import 'package:rxpakistan/widgets/custom_widgets.dart';

class AllPrescription extends StatefulWidget {
  AllPrescription({Key? key, required this.pharmacyUname}) : super(key: key);

  var pharmacyUname;
  @override
  State<AllPrescription> createState() => _AllPrescriptionState();
}

class _AllPrescriptionState extends State<AllPrescription> {
  var api = ApiHandler();

  double value = 0;
  List<dynamic> unnotified = [];

  String _getRefils(dynamic value) =>
      value == "-1" ? "UNLIMITED REFILS" : "$value Refils";
  static const DATE_FORMAT = 'dd/MM/yyyy';
  String formattedDate(DateTime dateTime) {
    print('dateTime ($dateTime)');
    return DateFormat(DATE_FORMAT).format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Mywidgets.getDrawer(context, widget.pharmacyUname),
      appBar: AppBar(
        title: Text("Prescription"),
        leading: Padding(
          padding: EdgeInsets.all(8.0),
          child: Image.asset(
            "assets/images/logo.png",
          ),
        ),
        actions: [

          FutureBuilder<dynamic>(
              future: api.getPrescriptionForPharmacy(
                  "emr", "getPrescriptionForPharmacy", widget.pharmacyUname),
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
                    int count = 0;
                    List<dynamic> countUnNotified = snapshot.data;
                    for (int index = 0;
                        index < countUnNotified.length;
                        index++) {
                      if (countUnNotified[index]["rxStatus"] == 0) {
                        count++;
                      }
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Badge(
                          position: BadgePosition.topStart(),
                          badgeContent: Text("${count}"),
                          child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UnNotifiedScreen(
                                              notifications: unnotified,
                                            )));
                              },
                              icon: Icon(FontAwesomeIcons.bell))),
                    );
                  } else {
                    return Text("No data");
                  }
                } else {
                  return Mywidgets.getLottie(
                      path: "assets/animations/pharmacist.json");
                }
              }),
          Builder(
              builder: (context) {
                return IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    icon: FaIcon(FontAwesomeIcons.bars));
              }
          ),
        ],
      ),
      body: FutureBuilder<dynamic>(
          future: api.getPrescriptionForPharmacy(
              "emr", "getPrescriptionForPharmacy", widget.pharmacyUname),
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
                List<dynamic> allData = snapshot.data;

                return Container(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      setState(() {});
                    },
                    child: ListView.builder(
                      itemCount: allData.length,
                      itemBuilder: (context, index) {
                        if (allData[index] != null) {
                          //allData[index]["disease"].toString();
                          if (allData[index]["rxStatus"].toString() == "1") {
                            return MyListtile(
                              title:
                                  "${allData[index]["PatientUName"].toString()} • ${_getRefils(allData[index]["rxRefil"].toString())}",
                              subtitle:
                                  "Doctor :: ${allData[index]["DocUName"].toString()} • ${formattedDate(DateTime.parse(allData[index]["rxDate"].toString()))}",
                              rxid: allData[index]["rxid"],
                              Docname: allData[index]["DocUName"].toString(),
                              long: 0.0,
                              lat: 0.0,
                              flag: false,
                              RxDetails: allData[index]["RxHaveDrugs"],
                            );
                          } else {
                            unnotified.add(allData[index]);
                            return Text("");
                          }
                        } else {
                          return const Text("");
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
