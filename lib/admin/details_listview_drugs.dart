import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rxpakistan/apihandler.dart';

class GenericList extends StatefulWidget {
  GenericList({Key? key, required this.status}) : super(key: key);

  int status;
  @override
  _GenericListState createState() => _GenericListState();
}

class _GenericListState extends State<GenericList> {
  var _apiAdmin = ApiHandler();
  late int _drugStatus;
  @override
  void initState() {
    // TODO: implement initState
    _drugStatus = widget.status;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Drugs"),
      ),
      body: FutureBuilder<dynamic>(
        future:
            _apiAdmin.getDrugsStatus("admin", "getDrugsOnStatus", _drugStatus),
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
                        shadowColor: Colors.indigo,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        child: ListTile(
                          leading: const FaIcon(
                            FontAwesomeIcons.pills,
                            size: 30,
                          ),
                          title: Text("${data[index]["DName"]}"),
                          subtitle: Text("Exp :: ${data[index]["ExpDate"]}"),
                          trailing: _drugStatus == 0
                              ? ElevatedButton(
                                  onPressed: () {
                                    _apiAdmin
                                        .updateDrugsStatus(
                                            "admin",
                                            "chnageDrugStatus",
                                            1,
                                            data[index]["Did"])
                                        .whenComplete(() => AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.INFO,
                                      animType: AnimType.BOTTOMSLIDE,
                                      btnOkOnPress: () {Navigator.pop(context);},
                                      title: '${data[index]["DName"]} UnBan',
                                    ).show());
                                    print("UNBAN");
                                  },
                                  child: Text("UnBan"),
                                )
                              : ElevatedButton(
                                  onPressed: () {

                                    _apiAdmin.updateDrugsStatus(
                                            "admin",
                                            "changeDrugStatus",
                                            0,
                                            data[index]["Did"])
                                        .whenComplete(() => AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.INFO,
                                      animType: AnimType.BOTTOMSLIDE,
                                      btnOkOnPress: () {Navigator.pop(context);},
                                      title: '${data[index]["DName"]} Ban',
                                    ).show());
                                    print("BAN");

                                  },
                                  child: Text("Ban"),
                                ),
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
