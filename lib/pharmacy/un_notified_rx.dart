import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:rxpakistan/widgets/custom_widgets.dart';

import '../apihandler.dart';
import 'drugs_details_in_pharmacy.dart';

class UnNotifiedScreen extends StatefulWidget {
   UnNotifiedScreen({Key? key,required this.notifications}) : super(key: key);

   List<dynamic> notifications;

  @override
  State<UnNotifiedScreen> createState() => _UnNotifiedScreenState();
}

class _UnNotifiedScreenState extends State<UnNotifiedScreen> {
   dynamic temp;

   var _controller=RoundedLoadingButtonController();

   var api=ApiHandler();

   String _gettime(String date)
   {
     return "${DateTime.parse(date).hour} : ${DateTime.parse(date).minute} ${DateTime.parse(date).timeZoneName}";
   }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: Mywidgets.getAppBar("Notifications"),
      body: ListView.builder(
          itemCount: widget.notifications.length,
          itemBuilder: (context, index) {




            if (widget.notifications.isNotEmpty) {



              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  elevation: 5,
                  shadowColor: Colors.indigo,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: ListTile(
                    leading: const FaIcon(
                      FontAwesomeIcons.prescription,
                      size: 30,
                      color: Colors.green,
                    ),
                    title: Text(
                        "${widget.notifications[index]["PatientUName"]} "),
                    subtitle:
                    Text("Deliver by DR ${widget.notifications[index]["DocUName"]} at ${ _gettime(widget.notifications[index]["rxDate"].toString())}"),
                    trailing: SizedBox(
                      width: 60,
                      height: 60,
                      child: RoundedLoadingButton(onPressed: () async{

                     await api.setRxRecived("emr", "setRxRecived", widget.notifications[index]["rxid"]);

                        temp=widget.notifications[index]["RxHaveDrugs"];
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>AllDrugsInPharmacy(data: temp,))).whenComplete((){setState(() {

                        });});


                      }, controller: _controller,
                      child: Icon(FontAwesomeIcons.eye)),
                    ),
                  ),
                ),
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Mywidgets.getLottie(
                      path: "assets/animations/pharmacist.json"),
                  SizedBox(
                    height: 10,
                  ),
                  Text("No Drugs")
                ],
              );
            }
          }),
    );
  }
}
