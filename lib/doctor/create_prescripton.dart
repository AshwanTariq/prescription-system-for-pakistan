import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:rxpakistan/main.dart';
import 'package:substring_highlight/substring_highlight.dart';
import 'package:badges/badges.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Prescription extends StatefulWidget {
  const Prescription({Key? key}) : super(key: key);

  @override
  _PrescriptionState createState() => _PrescriptionState();
}

class _PrescriptionState extends State<Prescription> {
  var patient = TextEditingController();
  var types = TextEditingController();
  var drugs = TextEditingController();
  var time = TextEditingController();

  var company = TextEditingController();
  var qty = TextEditingController();
  var note = TextEditingController();

  //List<Drugs> drgs = [];
  String? compannyDropDownRslt = "Compnay";
  String? type = "Type";
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
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Badge(
            badgeContent: Text('3'),
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: IconButton(onPressed: () {}, icon: Icon(Icons.circle)))),
      ),
      appBar: AppBar(
        title: Text("Create Precription", style: TextStyle(fontSize: 22)),
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
                          term: drugs.text,
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
                drugs = controller;

                return TextField(
                  focusNode: focusNode,
                  controller: controller,
                  onEditingComplete: onEditingComplete,
                  decoration:
                      getInputDecoration("Drug Name", Icon(Icons.circle)),
                );
              }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DropdownButton<String>(
                  hint: Text(compannyDropDownRslt!),
                  icon: Icon(Icons.arrow_drop_down),
                  items: companylist.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    compannyDropDownRslt = value;
                    setState(() {});
                    print(compannyDropDownRslt);
                    print(value);
                  },
                ),
                DropdownButton<String>(
                  hint: Text(type!),
                  icon: Icon(Icons.arrow_drop_down),
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
            Incrementor(onchangedCallback: (value) {
              print(value);
            },),
          ],
        ),
      ),
    );
  }

  InputDecoration getInputDecoration(String hint, Widget icon) {
    return InputDecoration(
      labelText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      prefixIcon: icon,
    );
  }
}

class Incrementor extends StatefulWidget {
   Incrementor({Key? key,required this.onchangedCallback}) : super(key: key);

   final Function(int) onchangedCallback;
  @override
  _IncrementorState createState() => _IncrementorState();
}

class _IncrementorState extends State<Incrementor> {
  int value = 0;


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(20),
      ),

      height: 60,
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                setState(() {
                  if (value != 0) {
                    value--;
                    widget.onchangedCallback.call(value);
                  }
                });
              },
              icon: FaIcon(FontAwesomeIcons.minus)),

          Text(value.toString()),
          IconButton(
              onPressed: () {

                setState(() {
                  value++;
                  widget.onchangedCallback.call(value);
                });
              },
              icon: Icon(Icons.add)),

        ],
      ),
    );
  }
}

/*
class Drugs {
  var name;
  var type;
  var comapny;
  var time;
  var qty;
  var note;
  Drugs(
      {required this.name,
        required this.type,
        required this.comapny,
        required this.time,
        required this.qty,
        var note});
}
*/
