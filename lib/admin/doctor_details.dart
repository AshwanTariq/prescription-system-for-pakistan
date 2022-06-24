import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rxpakistan/apihandler.dart';

class AllDoctors extends StatefulWidget {
  const AllDoctors({Key? key}) : super(key: key);

  @override
  _AllDoctorsState createState() => _AllDoctorsState();
}

class _AllDoctorsState extends State<AllDoctors> {
  var _apiAdmin=ApiHandler();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("DOCTORS"),),
      body: FutureBuilder<dynamic>(
        future:
        _apiAdmin.getAllDoctors("admin", "getalldoctors"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              print(snapshot.error);
              return Center(child: Text("ERROR "));
            }
            if (snapshot.hasData) {
              print("DATA RECIVED IN HAS DATA");
              print(snapshot.data);
              List<dynamic> data = snapshot.data;

              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                        elevation: 5,
                        shadowColor: Colors.limeAccent,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        child: ListTile(
                          leading: const FaIcon(
                            FontAwesomeIcons.userDoctor,
                            size: 30,
                          ),
                          title: Text("${data[index]["DName"]}"),
                          subtitle: Text("${data[index]["DSpeciality"]}"),

                        ),
                      ),
                    );
                  });
            } else {
              return const Center(
                child: Text("NO DATA"),
              );
            }
          }
          return Center(
            child: Text("LAST CALL RETURN"),
          );
        },
      ),
    );
  }
}
