import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rxpakistan/widgets/custom_widgets.dart';

class AllDrugsInPharmacy extends StatelessWidget {
  AllDrugsInPharmacy({Key? key, required this.data}) : super(key: key);

  List<dynamic> data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Drugs In Rx"),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            if (data.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  elevation: 5,
                  shadowColor: Colors.indigo,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: ListTile(
                    leading: const FaIcon(
                      FontAwesomeIcons.pills,
                      size: 30,
                    ),
                    title: Text(
                        "${data[index]["drugs"]} • ${data[index]["company"]}"),
                    subtitle:
                        Text("${data[index]["type"]}} • ${data[index]["Note"]} "),
                    trailing: Text("[${data[index]["method"]}]"),
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
