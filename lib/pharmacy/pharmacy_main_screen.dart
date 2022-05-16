import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rxpakistan/apihandler.dart';
import 'package:rxpakistan/widgets/custom_widgets.dart';

class AllPrescription extends StatefulWidget {
   AllPrescription({Key? key,required this.pharmacyUname}) : super(key: key);

   var pharmacyUname;
  @override
  State<AllPrescription> createState() => _AllPrescriptionState();
}

class _AllPrescriptionState extends State<AllPrescription> {
   var api=ApiHandler();


   String _getRefils(dynamic value)=> value == "-1" ? "UNLIMITED REFILS" : "$value Refils";
   static const DATE_FORMAT = 'dd/MM/yyyy';
   String formattedDate(DateTime dateTime) {
     print('dateTime ($dateTime)');
     return DateFormat(DATE_FORMAT).format(dateTime);
   }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Mywidgets.getAppBar("Prescription"),
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
                      setState(() {

                      });
                    },
                    child: ListView.builder(
                      itemCount: allData.length,
                      itemBuilder: (context, index) {
                        if (allData[index] != null) {
                          //String Alldisease = allData[index]["disease"].toString();

                          return MyListtile(
                            title:"${allData[index]["PatientUName"].toString() } • ${_getRefils(allData[index]["rxRefil"].toString())}" ,
                            subtitle: "Doctor :: ${allData[index]["DocUName"].toString()} • ${formattedDate(DateTime.parse(allData[index]["rxDate"].toString())) }",
                            rxid:allData[index]["rxid"],
                            Docname: allData[index]["DocUName"].toString(),
                            long: 0.0,
                            lat: 0.0, flag: false, RxDetails: allData[index]["RxHaveDrugs"],
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
