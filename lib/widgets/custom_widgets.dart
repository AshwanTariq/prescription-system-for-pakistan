import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmap;
import 'package:lottie/lottie.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:rxpakistan/doctor/doctor_model_file.dart';
import 'package:rxpakistan/patinet/patient_model_file.dart';

import '../apihandler.dart';
import '../doctor/create_prescripton.dart';
import '../doctor/doctor_main_screen.dart';
import '../pharmacy/drugs_details_in_pharmacy.dart';
import '../pharmacy/nearest_pharmacy.dart';
import '../pharmacy/pharmacy_main_screen.dart';

class DrugsName {
  static List<String> d = [];
}

class Mywidgets {
  static Drawer getDrawer(BuildContext con, String value) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 30,
          ),
          Mywidgets.getLottie(path: "assets/animations/commonuser.json"),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Hello ${value.toUpperCase()} !",
              style: Theme.of(con).textTheme.headline2,
            ),
          ),
          ListTile(
              title: Text("Logout"),
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(con);
                    Navigator.pop(con);
                  },
                  icon: FaIcon(FontAwesomeIcons.signOut)))
        ],
      ),
    );
  }

  static void ShowDisease(BuildContext context, String list) {
    List<String> data = list.split("?");
    List<Widget> txt = [];

    AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO,
      animType: AnimType.BOTTOMSLIDE,
      btnOkOnPress: () {},
      title: 'All Disease',
      desc: "${data.toString()}",
    ).show();
  }

  static void ShowContraindication(BuildContext context,RoundedLoadingButtonController con) {
    AwesomeDialog(
      context: context,
      dismissOnTouchOutside: false,
      dialogType: DialogType.INFO,
      animType: AnimType.BOTTOMSLIDE,
      btnOkOnPress: () =>con.reset(),
      title: 'Contraindication',
      desc:
          " You Can Not insert this Drug \nit Can give side effects to the Patient.",
    ).show();
  }

  static PreferredSizeWidget getAppBar(String data) {
    return AppBar(
      title: Text(data),
    );
  }

  static getLottie({required String path, double? width, double? height}) {
    return Lottie.asset(path, width: width, height: height);
  }

  static InputDecoration getInputDecoration(String hint, Widget icon) {
    return InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        icon: icon,
        labelText: hint,
        labelStyle: TextStyle(color: Colors.grey));
  }
}

class RefilWidget extends StatefulWidget {
  RefilWidget({Key? key, required this.con}) : super(key: key);

  TextEditingController con;
  @override
  _RefilWidgetState createState() => _RefilWidgetState();
}

class _RefilWidgetState extends State<RefilWidget> {
  bool ans = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.blue, width: 2)),
        child: SwitchListTile(
          title: ans
              ? TextField(
                  controller: widget.con,
                  decoration: InputDecoration(
                    labelText: "Enter Number of Refils",
                  ),
                  keyboardType: TextInputType.number,
                )
              : Text(
                  'Unlimited refils',
                  style: TextStyle(color: Colors.grey),
                ),
          value: ans,
          onChanged: (bool value) {
            setState(() {
              ans = value;
            });
          },
          secondary: const FaIcon(FontAwesomeIcons.prescriptionBottle),
        ),
      ),
    );
  }
}

class Incrementor extends StatefulWidget {
  Incrementor({Key? key, required this.onchangedCallback, required this.time})
      : super(key: key);

  final Function(int) onchangedCallback;
  final String time;
  @override
  _IncrementorState createState() => _IncrementorState();
}

class _IncrementorState extends State<Incrementor> {
  int value = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.blue, width: 2)),
        height: 43,
        child: Row(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                widget.time,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            )),
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
      ),
    );
  }
}

class CustomGoogleMaps extends StatefulWidget {
  CustomGoogleMaps({required this.getlatlong, Key? key}) : super(key: key);

  final Function(double, double) getlatlong;
  @override
  _CustomGoogleMapsState createState() => _CustomGoogleMapsState();
}

class _CustomGoogleMapsState extends State<CustomGoogleMaps> {
  Set<gmap.Marker> _markers = {};
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(33.738045, 73.084488),
    zoom: 14.4746,
  );

  double lat = 0.0, lang = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);

          showDialog(
              context: context,
              builder: (context) {
                return Container(
                  width: 200,
                  height: 200,
                  child:const Padding(
                    padding:EdgeInsets.all(18.0),
                    child: const Center(
                      child: Card(
                        elevation: 2,
                        shadowColor: Colors.black54,
                        child: Text("LOCATION ADDED"),
                      ),
                    ),
                  ),
                );
              });
        },
        child: Icon(FontAwesomeIcons.check),
      ),
      body: GoogleMap(

        markers: _markers,
        onTap: (value) {
          _markers = {};
          _markers.add(gmap.Marker(
              markerId: MarkerId(value.toString()),
              position: value,
              infoWindow: const InfoWindow(
                title: 'Your Location',
              )));
          print(value);
          widget.getlatlong.call(value.latitude, value.longitude);
          setState(() {});
        },
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  CustomTextField(
      {Key? key,
      required this.con,
      required this.obscure,
      required this.prefix,
      required this.hint})
      : super(key: key);

  TextEditingController con;
  bool obscure;

  final Widget prefix;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 9, right: 9, top: 8),
      child: TextField(
          obscureText: obscure,
          controller: con,
          decoration: Mywidgets.getInputDecoration(hint, prefix)),
    );
  }
}

class DumyPage extends StatelessWidget {
  DumyPage({Key? key}) : super(key: key);

  var controllerphr = TextEditingController();
  var controllerdoc = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DUMY PAGE FOR DEMO"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 300,
                  child: TextField(
                    controller: controllerdoc,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                      ),
                      hintText: "Enter Doctor username  ...",
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      if (controllerdoc.text.isNotEmpty) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DocHomePage(
                                      docName: controllerdoc.text,
                                    )));
                      }
                    },
                    child: Icon(FontAwesomeIcons.userDoctor)),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 300,
                  child: TextField(
                    controller: controllerphr,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                      ),
                      hintText: "Enter Pharmacy username  ...",
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (controllerphr.text.isNotEmpty) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AllPrescription(
                                    pharmacyUname: controllerphr.text,
                                  )));
                    }
                  },
                  child: Icon(FontAwesomeIcons.hospital),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MyListtile extends StatelessWidget {
  MyListtile(
      {Key? key,
      required this.RxDetails,
      required this.title,
      required this.subtitle,
      required this.rxid,
      required this.Docname,
      required this.lat,
      required this.long,
      required this.flag})
      : super(key: key);

  var title;
  var subtitle, rxid, Docname;
  bool flag;
  double lat, long;
  var apiHandler = ApiHandler();
  var _btnController = RoundedLoadingButtonController();
  dynamic RxDetails;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black45,
                spreadRadius: 2,
                blurRadius: 6,
                offset: Offset(2, 6),
              )
            ],
            color: Colors.white),
        child: ListTile(
          leading: const Icon(
            Icons.account_circle_sharp,
            color: Colors.amber,
            size: 50,
          ),
          title: Text(
            title.toString(),
            style: TextStyle(fontSize: 20),
          ),
          subtitle: Text(subtitle.toString(), style: TextStyle(fontSize: 14)),
          trailing: SizedBox(
            width: 50,
            height: 50,
            child: flag == true
                ? RoundedLoadingButton(
                    elevation: 0,
                    child: const Icon(
                      FontAwesomeIcons.arrowRight,
                      size: 20,
                    ),
                    controller: _btnController,
                    onPressed: () async {
                      await apiHandler
                          .getPrescriptionCount("emr", "getprescriptioncount")
                          .then((rxCount) {
                        rxid = rxCount;
                        rxid++;
                        List<String> value = title.toString().split("•");

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Prescription(
                                      show: false,
                                      rxid: rxid,
                                      Docname: Docname,
                                      Patientdetails: PatientData(
                                        role: 1,
                                        username: value[0].toString(),
                                        lat: lat,
                                        long: long,
                                        password: "",
                                        disease: subtitle
                                            .toString()
                                            .replaceAll(",", "?"),
                                        Name: "",
                                        gender: "",
                                      ),
                                    ))).whenComplete(() => _btnController.reset());
                      });
                    },
                  )
                : SizedBox(
                    width: 1,
                    height: 1,
                  ),
          ),
          onTap: flag == false
              ? () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AllDrugsInPharmacy(
                                data: RxDetails,
                              )));
                }
              : () {
                  print("FLAG TRUE");
                },
        ),
      ),
    );
  }
}

class CustomDiseaseBox extends StatelessWidget {
  CustomDiseaseBox({Key? key, required this.data, required this.isSelected})
      : super(key: key);

  var data;
  final Function(String) isSelected;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(data),
        ),
        RoundCheckBox(
          size: 30,
          onTap: (selected) {
            if (selected == true) {
              isSelected.call("${data}?");
            } else {
              print("${data} Not Selected");
            }
          },
        ),
      ],
    );
  }
}
