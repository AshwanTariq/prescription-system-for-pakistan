import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:rxpakistan/apihandler.dart';
import 'package:rxpakistan/doctor/drugs_detail_screen.dart';
import 'package:rxpakistan/doctor/search_drugs.dart';
import 'package:rxpakistan/main.dart';
import 'package:rxpakistan/patinet/patient_model_file.dart';
import 'package:rxpakistan/pharmacy/nearest_pharmacy.dart';
import 'package:substring_highlight/substring_highlight.dart';
import 'package:badges/badges.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widgets/custom_widgets.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';

import 'add_patients_details.dart';
import 'doctor_model_file.dart';

class Prescription extends StatefulWidget {
  Prescription({
    Key? key,
    required this.show,
    required this.Patientdetails,
    required this.Docname,
    required this.rxid,
  }) : super(key: key);

  bool show;
  PatientData Patientdetails;
  var Docname;
  var rxid;
  @override
  _PrescriptionState createState() => _PrescriptionState();
}

class _PrescriptionState extends State<Prescription> {
  //var drugsctrl = TextEditingController();
  var searchDrugs = TextEditingController();
  final _btnController = RoundedLoadingButtonController();
  final _btnControllerFordugs = RoundedLoadingButtonController();

  String description = '';
  TextEditingController controllerForNote = TextEditingController();

  var api = ApiHandler();
  List<Drugs> AllDrugs = [];
  String? company = "Company";
  String? type = "Type";
  int Breakfast = 0;
  int Lunch = 0;
  int Dinner = 0;
  var refilCon = TextEditingController();
  late bool showButton;
  late PatientData PatientDetails;

  List<String> autoCompleteTypes = <String>[
    "Capsule",
    "Injection",
    "Tablet",
    "Flajal",
    "Careem",
    "Tube",
    "Drops",
    "Soup"
  ];
  List<String> companylist = <String>[
    'Zanic',
    'Pfizer',
    'Med Spahe',
    'Bed Care',
    'GlaxoSmithKline',
    'Ferozsons',
    'Searle',
    'Abbot',
    'Hilton'
  ];

  DateTime getdate() {
    var now = DateTime.now();
    /*var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);*/
    return now;
  }

  bool chkDrugToDrugContra(List<String> alldrugsUser, String allDrugsContra) {
    bool flag = false;
    List<String> Udis = alldrugsUser;
    List<String> Cdis = allDrugsContra.split("?");
    Udis.forEach((userDIS) {
      Cdis.forEach((contraDIS) {
        if (userDIS == contraDIS) {
          print("DRUG TO DISEASE CONTRAINDICATION");
          flag = true;
        }
      });
    });
    return flag;
  }

  @override
  void initState() {
    super.initState();
    PatientDetails = widget.Patientdetails;
    showButton = widget.show;
    controllerForNote.addListener(() {
      print(controllerForNote.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Badge(
          animationType: BadgeAnimationType.scale,
          badgeContent: Text(AllDrugs.length.toString()),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AllDrugsScreen(drgs: AllDrugs)));
            },
            child: FaIcon(FontAwesomeIcons.pills),
          )),
      appBar: AppBar(
        title: Text("Create Prescription", style: TextStyle(fontSize: 18)),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchDrugs(
                                con: searchDrugs,
                                disease: PatientDetails.disease,
                              ),
                            ),
                          );
                        },
                        child: Text("Select Drug")),
                    showButton
                        ? ElevatedButton(
                            onPressed: () async {
                              PatientDetails = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PatientsMiniEMR(),
                                ),
                              );
                              print(
                                  "LAT IN PATIENT IN RX${PatientDetails.lat} \nLONG IN PATIENT  IN RX${PatientDetails.long}");

                              setState(() {
                                showButton = false;
                              });
                            },
                            child: Text("ADD PATIENT DETAILS"),
                          )
                        : Text(
                            "For ${PatientDetails.username}",
                            style: TextStyle(fontSize: 25),
                          )
                  ],
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DropdownButton<String>(
                  hint: Text(company!),
                  icon: FaIcon(FontAwesomeIcons.building),
                  items: companylist.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    company = value;
                    setState(() {});
                    print(company);
                    print(value);
                  },
                ),
                DropdownButton<String>(
                  hint: Text(type!),
                  icon: FaIcon(FontAwesomeIcons.capsules),
                  items: autoCompleteTypes.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    type = value;
                    setState(() {});
                    print(type);
                    print(value);
                  },
                ),
              ],
            ),
            Incrementor(
              time: "Breakfast Dosage",
              onchangedCallback: (value) {
                Breakfast = value;
                print(value);
              },
            ),
            Incrementor(
              time: "Lunch Dosage",
              onchangedCallback: (value) {
                Lunch = value;
                print(value);
              },
            ),
            Incrementor(
              time: "Dinner Dosage",
              onchangedCallback: (value) {
                Dinner = value;
                print(value);
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MarkdownTextInput(
                (String value) => setState(() => description = value),
                description,
                label: 'Enter any kind of extra note here.',
                maxLines: 6,
                actions: const [
                  MarkdownType.bold,
                  MarkdownType.italic,
                  MarkdownType.title,
                  MarkdownType.blockquote
                ],
                controller: controllerForNote,
              ),
            ),
            RefilWidget(
              con: refilCon,
            ),
            TextButton(
              onPressed: () {
                var oneDrug = Drugs(
                    rxidFK: widget.rxid,
                    name: searchDrugs.text.isEmpty
                        ? "NO DRG"
                        : searchDrugs.text,
                    type: type == "Type" ? "Any Type" : type,
                    company: company == "Company"
                        ? "Any Company"
                        : company,
                    method: "B$Breakfast/L$Lunch/D$Dinner",
                    note: controllerForNote.text.isEmpty
                        ? "No Note"
                        : controllerForNote.text);

                AllDrugs.add(oneDrug);
                searchDrugs.text = "";
                type = "Type";
                company = "Company";
                Breakfast = 0;
                Lunch = 0;
                Dinner = 0;
                controllerForNote.text = "";


                setState(() {});


              },

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  FaIcon(
                    FontAwesomeIcons.plus,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Add Drug'),
                ],
              ),),

            RoundedLoadingButton(
              width: 240,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  FaIcon(
                    FontAwesomeIcons.prescription,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Show Near Pharmacies'),
                ],
              ),
              controller: _btnController,
              onPressed: () {
                if (AllDrugs.isNotEmpty) {
                  print(refilCon.text);

                  print(searchDrugs.text);
                  var rx = PrescriptionData(
                      RxHaveDrugs: AllDrugs,
                      rxid: widget.rxid,
                      rxDate: DateTime.now().toString(),
                      DocUName: widget.Docname,
                      PharmacyUName: "",
                      PatientUName: PatientDetails.username,
                      rxStatus: 0,
                      rxRefil: int.parse(
                          refilCon.text.isEmpty ? "-1" : refilCon.text));
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NearPlaces(
                                lat: PatientDetails.lat,
                                long: PatientDetails.long,
                                rxfinal: rx,
                              )));
                } else {
                  _btnController.error();
                  Future.delayed(Duration(seconds: 2));
                  _btnController.reset();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration getInputDecoration(String hint, Widget icon) {
    return InputDecoration(
      icon: icon,
      labelText: hint,
    );
  }
}





/*
List<dynamic> temp = snapshot.data;
List<String> drugs = [];
for (int index = 0; index < AllDrugs.length; index++) {
drugs.add(AllDrugs[index].name);
if (chkDrugToDrugContra(drugs,
temp[index]["ConDrugs"].toString()) &&
AllDrugs.isNotEmpty) {
Mywidgets.ShowContraindication(context);_btnControllerFordugs.reset();
}*/












/*Autocomplete(
optionsBuilder: (TextEditingValue textEditingValue) {
if (textEditingValue.text.isEmpty) {
return const Iterable<String>.empty();
} else {
return DrugsName.d.where((word) => word
    .toLowerCase()
    .contains(textEditingValue.text.toLowerCase()));
}
}, optionsViewBuilder:
(context, Function(String) onSelected, options) {
return Material(
elevation: 4,
child: ListView.separated(
padding: EdgeInsets.zero,
itemBuilder: (context, index) {
final option = options.elementAt(index);

return ListTile(
title: SubstringHighlight(
text: option.toString(),
term: drugsctrl.text,
textStyleHighlight:
TextStyle(fontWeight: FontWeight.w700),
),
onTap: () {
onSelected(option.toString());
},
);
},
separatorBuilder: (context, index) => Divider(),
itemCount: options.length,
),
);
}, onSelected: (selectedString) {
print(selectedString);
}, fieldViewBuilder:
(context, controller, focusNode, onEditingComplete) {
drugsctrl = controller;

return TextField(
focusNode: focusNode,
controller: controller,
onEditingComplete: onEditingComplete,
decoration: getInputDecoration(
"Drug Name", FaIcon(FontAwesomeIcons.pills)),
);
}),*/
