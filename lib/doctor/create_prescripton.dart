import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rxpakistan/main.dart';
import 'package:substring_highlight/substring_highlight.dart';

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

  List<Drugs> drgs = [];

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

  String date() {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    return formattedDate.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Precription", style: TextStyle(fontSize: 25)),
        centerTitle: true,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: myTextFild().getInputField(
                            "Patient's Name",
                            Icon(Icons.account_circle_rounded),
                            autoCompleteData,
                            patient)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Date\n${date()}",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              Text(
                "Add Drugs",
                style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: myTextFild().getInputField(
                            "Name",
                            Icon(Icons.animation_rounded),
                            autoCompleteDrugs,
                            drugs)),
                  ),
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: myTextFild().getInputField("Type", Icon(Icons.apps_rounded),
                            autoCompleteTypes, types)),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: myTextFild().getInputField(
                            "Company", Icon(Icons.home), companylist, company)),
                  ),
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: time,
                          decoration: InputDecoration(
                              hintText: "M/A/N",
                              prefixIcon: Icon(Icons.access_alarm)),
                        )),
                  ),
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: qty,
                          decoration: InputDecoration(
                              hintText: "400mg",
                              prefixIcon: Icon(Icons.equalizer_rounded)),
                        )),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  child: TextField(
                    controller: note,
                    decoration: InputDecoration(
                      hintText: "NOTE",
                      prefixIcon: Icon(Icons.create),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        drgs.add(Drugs(
                            name: drugs.text,
                            type: types.text,
                            comapny: company.text,
                            time: time.text,
                            qty: qty.text,
                            note: note.text.isEmpty ? "" : note.text));
                        setState(() {});
                      },
                      child: Text("ADD Drug")),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text("Send Drug"),
                  ),
                ],
              ),
              Text(
                "All Drugs",
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
              Builder(builder: (context) {
                if (drgs.isEmpty) {
                  return Center(child: Text("ADD DRUGS"));
                } else {
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: drgs.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                boxShadow: [BoxShadow(

                                  color: Colors.black45,
                                  spreadRadius: 2,
                                  blurRadius: 4,
                                  offset: Offset(2,6),
                                )],
                                color: Colors.white

                            ),
                            child: ListTile(
                              leading: Icon(Icons.animation,size: 30,color: Colors.indigo,),
                              title: Text(
                                "DRUG ADDED",
                                style: TextStyle(fontSize: 22),
                              ),
                              /*subtitle: Text("${drgs[index].note}"),
                              trailing: Text(
                                  "${drgs[index].time}\n${drgs[index].type}",
                                  style: TextStyle(fontSize: 10)),*/
                            ),
                          ),
                        );
                      });
                }
              }),
            ],
          ),
        ),
      ),
    );
  }



  InputDecoration getInputDecoration(String hint, Widget icon) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      prefixIcon: icon,
      prefixIconColor: Colors.amber,
      hintStyle: TextStyle(color: Colors.grey),
      hintText: hint,
    );
  }
}
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
class myTextFild {
  Widget getInputField(String value, Widget icon, List<String> Data,
      TextEditingController TEC) {
    return Autocomplete(optionsBuilder: (TextEditingValue textEditingValue) {
      if (textEditingValue.text.isEmpty) {
        return const Iterable<String>.empty();
      } else {
        return Data.where((word) =>
            word.toLowerCase().contains(textEditingValue.text.toLowerCase()));
      }
    }, optionsViewBuilder: (context, Function(String) onSelected, options) {
      return Material(
        elevation: 4,
        child: ListView.separated(
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            final option = options.elementAt(index);

            return ListTile(
              // title: Text(option.toString()),
              title: SubstringHighlight(
                text: option.toString(),
                term: TEC.text,
                textStyleHighlight: TextStyle(fontWeight: FontWeight.w700),
              ),
              //subtitle: Text("This is subtitle"),
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
    }, fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
      TEC = controller;
      return TextField(
        focusNode: focusNode,
        controller: controller,
        onEditingComplete: onEditingComplete,
        decoration: getInputDecoration(value, icon),
      );
    });
  }

  InputDecoration getInputDecoration(String hint, Widget icon) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      prefixIcon: icon,
      prefixIconColor: Colors.amber,
      hintStyle: TextStyle(color: Colors.grey),
      hintText: hint,
    );
  }
}
