import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rxpakistan/admin/details_listview_drugs.dart';
import 'package:rxpakistan/admin/pharmacies_details.dart';
import 'package:rxpakistan/apihandler.dart';

import 'doctor_details.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  

  
  Decoration _boxDecoration() {
    return BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).primaryColor,
              blurRadius: 20,
              spreadRadius: 1,
              offset: Offset(5, 5)),
        ]);
  }

  Widget _drugContainer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: _boxDecoration(),
        width: MediaQuery.of(context).size.width,
        height: 200,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Drugs Detail",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: _customRow("Ban Drugs",const FaIcon(FontAwesomeIcons.ban,color: Colors.red,),0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50, left: 8),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: _customRow("UnBan Drugs",const FaIcon(FontAwesomeIcons.unlock,color: Colors.green,),1),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _customRow(String title,Widget icon,int key) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
       icon,
        const SizedBox(
          width: 10,
        ),
        Text(
          "$title  ",
          style: Theme.of(context).textTheme.headline5,
        ),

        Expanded(
          flex: 6,
          child: IconButton(
              onPressed: () {
                if(key==20){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AllPharmacies()));
                }
                if(key==10){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AllDoctors()));
                }

                if(key==1 || key==0){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>GenericList(status: key)));
                }

              },
              icon: FaIcon(FontAwesomeIcons.angleRight)),
        )
      ],
    );
  }

  Widget _details() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: _boxDecoration(),
        width: MediaQuery.of(context).size.width,
        height: 300,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [
              _customRow("Doctors Details",const FaIcon(FontAwesomeIcons.userDoctor,color: Colors.lightBlue,),10),
              _customRow("Pharmacies Details",const FaIcon(FontAwesomeIcons.prescription,color: Colors.blue,),20),

            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ADMIN DASHBOARD"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _drugContainer(),
            _details(),
          ],
        ),
      ),
    );
  }
}
