import 'package:flutter/material.dart';

import 'package:rxpakistan/doctor/doctor_main_screen.dart';
import 'package:rxpakistan/signup_page.dart';
import 'package:rxpakistan/widgets/custom_widgets.dart';

import 'doctor/create_prescripton.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'Rx Pakistan',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DumyPage(),
    );
  }
}

