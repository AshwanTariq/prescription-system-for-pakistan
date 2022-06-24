import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rxpakistan/apihandler.dart';

import '../widgets/custom_widgets.dart';

class PatientHistory extends StatefulWidget {
   PatientHistory({Key? key,required this.username}) : super(key: key);

   final username;
  @override
  _PatientHistoryState createState() => _PatientHistoryState();
}

class _PatientHistoryState extends State<PatientHistory> {

  var api=ApiHandler();
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
      body: FutureBuilder<dynamic>(
          future: api.gethistory(
              "emr", "getHistory", widget.username),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                print(snapshot.error);
                return const Center(
                  child: Text("ERROR IN PROGRAM "),
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
