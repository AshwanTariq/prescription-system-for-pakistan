import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rxpakistan/apihandler.dart';

import '../widgets/custom_widgets.dart';

class PateintDashBoard extends StatefulWidget {
  PateintDashBoard({Key? key,required this.username}) : super(key: key);

  final username;
  @override
  State<PateintDashBoard> createState() => _PateintDashBoardState();
}

class _PateintDashBoardState extends State<PateintDashBoard> {
  var _api = ApiHandler();

  Decoration _listTileDecoration() {
    return const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(20)),
      boxShadow: [
        BoxShadow(
          color: Colors.black45,
          spreadRadius: 2,
          blurRadius: 6,
          offset: Offset(2, 6),
        )
      ],
    );
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: FutureBuilder<dynamic>(
        future: _api.getDashboardData("emr", "getDiseases", widget.username),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text("ERROR IN DATA"),
              );
            }
            if (snapshot.hasData) {
              String value = snapshot.data;
              List<String> data = value.split("?");
              return Padding(
                padding: const EdgeInsets.all(14.0),
                child: Container(
                    decoration: _boxDecoration(),
                    child: ListView.builder(
                        itemCount: data.length-1,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Material(
                              elevation: 2,
                                child: ListTile(
                              title: Center(
                                  child: Text(
                                data[index],
                                style: Theme.of(context).textTheme.headline6,
                              )),
                            )),
                          );
                        })),
              );
            }
          }
          return  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Mywidgets.getLottie(path: "assets/animations/doctor.json"),
              SizedBox(height: 1,),
              Text("NO DISEASES",style: Theme.of(context).textTheme.bodyLarge,),
              SizedBox(height: 3,),
              Text("You can add your DISEASES",style: Theme.of(context).textTheme.caption,),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: FaIcon(FontAwesomeIcons.add),
        onPressed: () { 

      },
        
      ),
    );
  }
}
