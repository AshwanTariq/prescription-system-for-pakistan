import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rxpakistan/apihandler.dart';
import 'package:rxpakistan/widgets/custom_widgets.dart';


class SearchDrugs extends StatefulWidget {
  SearchDrugs({Key? key, required this.con,required this.disease}) : super(key: key);

  TextEditingController con;
  String disease;


  @override
  State<SearchDrugs> createState() => _SearchDrugsState();
}

class _SearchDrugsState extends State<SearchDrugs> {
  List<dynamic> _list = [];

  List<dynamic> searchresult = [];
  bool loadingFlag = true;
  late bool _isSearching;
  String _searchText = "";
  bool flagContraindication=false;

  var api = ApiHandler();

  _SearchListExampleState() {
    widget.con.addListener(() {
      if (widget.con.text.isEmpty) {
        if (this.mounted) {
          setState(() {
            _isSearching = false;
            _searchText = "";
          });
        }
      } else {
        if (this.mounted) {
          setState(() {
            _isSearching = true;
            _searchText = widget.con.text;
          });
        }
      }
    });
  }

  //Future<bool> _chkSelectdDrug(String value) async =>value==null?false:true;
  bool chkDrugToDiseaseContra(String allDiseaseUser,String allDiseaseContra)
  {
    bool flag=false;
    List<String> Udis=allDiseaseUser.split("?");
    List<String> Cdis=allDiseaseContra.split("?");
    Udis.forEach((userDIS) {
      Cdis.forEach((contraDIS) {

        if(userDIS==contraDIS) {
          print("DRUG TO DISEASE CONTRAINDICATION");
          flag=true;

        }

      });

    });
    return flag;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _isSearching = false;
    //_handleSearchStart();
    _SearchListExampleState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Color.fromARGB(255, 11, 147, 28),
        title: TextField(
          textCapitalization: TextCapitalization.sentences,
          controller: widget.con,
          style: const TextStyle(
            color: Colors.white,
          ),
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search, color: Colors.white),
              hintText: "Search Drug ...",
              hintStyle: TextStyle(color: Colors.white)),
          onChanged: searchOperation,
        ),
      ),
      body: Container(
        child: FutureBuilder(
          future: api.getAllDrugs("emr", "getAllDrugs"),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData && loadingFlag) {
              _list = snapshot.data;
              //print(_lounchdate(snapshot.data[0]));
              return searchresult.length != 0 || widget.con.text.isNotEmpty
                  // ignore: unnecessary_new
                  ? new ListView.builder(
                      shrinkWrap: true,
                      itemCount: searchresult.length,
                      itemBuilder: (BuildContext context, int index) {
                        //String id = searchresult[index]["satid"].toString();
                        String drgname =
                            searchresult[index]["DName"].toString();
                        String ldate =
                            searchresult[index]["ExpDate"].toString();

                        if(!chkDrugToDiseaseContra(widget.disease,searchresult[index]["ConDisease"].toString())) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 3,
                              shadowColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                title: Text(drgname.toString()),
                                subtitle: Text('EXP Date :: $ldate'),
                                trailing: IconButton(
                                    onPressed: () {
                                      widget.con.text = drgname;

                                      //Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                      FontAwesomeIcons.add,
                                      color: Colors.green,
                                    )),
                              ),
                            ),
                          );
                        }else{
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
                            child: Card(
                              elevation: 6,
                              shadowColor: Colors.redAccent,
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18)),
                                title: Text("${drgname.toString()} CONTRAINDICATED"),
                                subtitle: Text('EXP Date :: $ldate'),
                                trailing: const Icon(
                                  FontAwesomeIcons.x,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          );
                        }

                      },
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(8),
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        //_list.add(snapshot.data[index]);
                        if(!chkDrugToDiseaseContra(widget.disease,snapshot.data[index]["ConDisease"].toString())) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 3,
                              shadowColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20)),
                                    title: Text(
                                        snapshot.data[index]["DName"].toString()),
                                    subtitle: Text(
                                        'EXP Date :: ${snapshot.data[index]["ExpDate"]}'),
                                    trailing: IconButton(
                                        onPressed: () {
                                          widget.con.text = snapshot.data[index]
                                          ["DName"]
                                              .toString();


                                          //Navigator.pop(context);
                                        },
                                        icon: const Icon(
                                          FontAwesomeIcons.add,
                                          color: Colors.green,
                                        )),
                                  )
                                ],
                              ),
                            ),
                          );
                        }else{
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
                            child: Card(
                              elevation: 6,
                              shadowColor: Colors.redAccent,
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18)),
                                title: Text("${snapshot.data[index]["DName"].toString()} CONTRAINDICATED"),
                                subtitle: Text(
                                    'EXP Date :: ${snapshot.data[index]["ExpDate"]}'),
                                trailing: const Icon(

                                  FontAwesomeIcons.x,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          );
                        }

                      });
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  void searchOperation(String searchText) {
    searchresult.clear();
    if (_isSearching != null) {
      for (int i = 0; i < _list.length; i++) {
        if (_list[i]["DName"].contains(searchText)) {
          print('value of _list[i] ${_list[i]}');
          searchresult.add(_list[i]);
        }
      }
    }
  }
}
/*FutureBuilder(
future: api.getAllDrugs("emr", "getAllDrugs"),
builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot)
{
if(snapshot.connectionState==ConnectionState.waiting) {
return Center(child: CircularProgressIndicator(),);
}
if(snapshot.connectionState==ConnectionState.done){
if(snapshot.hasData){

List<dynamic> listDrugsDetails=snapshot.data;

return ListView.builder(
itemCount: listDrugsDetails.length,
itemBuilder: (context, index) {



return Padding(
padding: const EdgeInsets.all(8.0),
child: Material(
elevation: 5,
shadowColor: Colors.indigo,
borderRadius: BorderRadius.all(Radius.circular(10)),
child: ListTile(
leading: FaIcon(FontAwesomeIcons.pills,size: 25,),
title: Text("${listDrugsDetails[index]["DName"].toString()}"),
subtitle: Text("EXP :: ${listDrugsDetails[index]["ExpDate"].toString()}"),
),
),
);
});
}
else{
return Text('WE Dont HAVE dATA');
}

}
return Text("LAST STATEMENT EXECUTED");
},

),*/
