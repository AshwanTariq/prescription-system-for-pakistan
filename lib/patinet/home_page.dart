import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rxpakistan/widgets/custom_widgets.dart';

import 'dashboard.dart';
import 'history.dart';

class PatientHomePage extends StatefulWidget {
  PatientHomePage({Key? key, required this.Pusername}) : super(key: key);

  final Pusername;
  @override
  State<PatientHomePage> createState() => _PatientHomePageState();
}

class _PatientHomePageState extends State<PatientHomePage> {
  int _pageIndex = 0;
  Widget _mywidget = Text("TEMP PAGE");
  @override
  void initState() {
    _mywidget = PateintDashBoard(
      username: widget.Pusername,
    );
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Mywidgets.getDrawer(context, widget.Pusername),
      appBar: AppBar(
        actions: [
          Builder(builder: (context) {
            return IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: FaIcon(FontAwesomeIcons.bars));
          })
        ],
        title: Text("Rx Pakistan"),
        leading: Padding(
          padding: EdgeInsets.all(8.0),
          child: Image.asset(
            "assets/images/logo.png",
          ),
        ),
      ),
      body: _mywidget,
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _pageIndex,
          onTap: (value) => setState(() {
                _pageIndex = value;
                switch (_pageIndex) {
                  case 0:
                    _mywidget = PateintDashBoard(
                      username: widget.Pusername,
                    );
                    break;
                  case 1:
                    _mywidget = PatientHistory(
                      username: widget.Pusername,
                    );
                    break;
                  case 2:
                    _mywidget = Center(
                      child: Text("locations"),
                    );
                    break;
                  default:
                    _mywidget = Center(
                      child: Text("ERROR IN SWITCH CASE"),
                    );
                }
              }),
          items: const [
            BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.disease), label: "Diseases"),
            BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.history), label: "History"),
            BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.mapLocation), label: "Clinic"),
          ]),
    );
  }
}
