import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:rxpakistan/doctor/drugs_detail_screen.dart';
import 'package:rxpakistan/main.dart';
import 'package:substring_highlight/substring_highlight.dart';
import 'package:badges/badges.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widgets/custom_widgets.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';

import 'doctor_model_file.dart';

class Prescription extends StatefulWidget {
  const Prescription({Key? key}) : super(key: key);

  @override
  _PrescriptionState createState() => _PrescriptionState();
}

class _PrescriptionState extends State<Prescription> {

  var drugsctrl = TextEditingController();


  String description = '';
  TextEditingController controllerForNote = TextEditingController();

  List<Drugs> AllDrugs = [];
  String? company = "Company";
  String? type = "Type";
  int Breakfast = 0;
  int Lunch = 0;
  int Dinner = 0;


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
    'Fizer',
    'Med Spahe',
    'Bed Care'
  ];
  List<String> autoCompleteDrugs = <String>[
    "Acetaminophen",
    "Adderall",
    "Amitriptyline",
    "Amlodipine",
    "Amoxicillin",
    "Ativan",
    "Benzonatate",
    "Cephalexin",
    "Clindamycin",
    "Clonazepam",
    "Cyclobenzaprine",
    "Cymbalta",
    "Doxycycline",
    "Dupixent",
    "Humira",
    "Hydrochlorothiazide",
    "Hydroxychloroquine",
    "Jardiance",
    "Metformin",
    "Januvia",
    "Ibuprofen"
  ];

  List<String> autoCompleteData = <String>[
    "Ashwan",
    "Akbar Zain",
    "Hammad",
    "Tariq Ch",
    "Usman Aslam",
    "Awais tariq",
    "Zara Asharaf",
    "Akbar Mirza",
    "Tariq ali",
    "Mutaza Ch",
    "Eisha",
    "Misbha",
    "Akbar Mirza",
    "Tariq ali",
    "Mutaza Ch",
    "Eisha",
    "Misbha"
  ];

  DateTime getdate() {
    var now = DateTime.now();
    /*var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);*/
    return now;
  }

  @override
  void initState() {
    super.initState();

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
              onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>AllDrugsScreen(drgs: AllDrugs)));},
              child: FaIcon(FontAwesomeIcons.pills),
            )
        ),
        appBar: AppBar(
          title: Text("Create Prescription", style: TextStyle(fontSize: 22)),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Autocomplete(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text.isEmpty) {
                        return const Iterable<String>.empty();
                      } else {
                        return autoCompleteDrugs.where((word) => word
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
                }),
              ),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Incrementor(
                  time: "Breakfast",
                  onchangedCallback: (value) {
                    Breakfast = value;
                    print(value);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Incrementor(
                  time: "Lunch",
                  onchangedCallback: (value) {
                    Lunch = value;
                    print(value);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Incrementor(
                  time: "Dinner",
                  onchangedCallback: (value) {
                    Dinner = value;
                    print(value);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MarkdownTextInput(
                      (String value) => setState(() => description = value),
                  description,
                  label: 'Enter any kind of extra note here.',
                  maxLines: 10,
                  actions: [
                    MarkdownType.bold,
                    MarkdownType.italic,
                    MarkdownType.title,
                    MarkdownType.blockquote
                  ],
                  controller: controllerForNote,
                ),
              ),
              TextButton(
                onPressed: () {
                  var oneDrug = Drugs(
                      name: drugsctrl.text.isEmpty ? "NO DRG" : drugsctrl.text,
                      type: type == "Type" ? "NO Type" : type,
                      comapny: company == "Company" ? "No Compnay" : company,
                      method: "B$Breakfast/L$Lunch/D$Dinner",
                      note: controllerForNote.text.isEmpty ? "No Note" : controllerForNote.text);
                  AllDrugs.add(oneDrug);
                  drugsctrl.text = "";
                  type = "Type";
                  company = "Company";
                  Breakfast = 0;
                  Lunch = 0;
                  Dinner = 0;
                  controllerForNote.text="";

                  print(AllDrugs.length);

                  setState(() {});
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.plus,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Add Drug'),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.prescription,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Send Rx'),
                  ],
                ),
              )
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
