import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:rxpakistan/apihandler.dart';
import 'package:rxpakistan/patinet/home_page.dart';
import 'package:rxpakistan/pharmacy/pharmacy_main_screen.dart';
import 'package:rxpakistan/signup_pages/doctor_signup.dart';
import 'package:rxpakistan/signup_pages/patient_siginup.dart';
import 'package:rxpakistan/signup_pages/pharmacy_signup.dart';

import 'doctor/add_patients_details.dart';
import 'doctor/doctor_main_screen.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _conUsername = TextEditingController();
  final _conPassword = TextEditingController();
  final _conButton = RoundedLoadingButtonController();
  final _api = ApiHandler();

  bool showErrorFlag = true;
  void nextPage(MaterialPageRoute route, BuildContext con) {
    Navigator.push(con, route).whenComplete(() => _conButton.reset());
  }

  void showOptions(BuildContext cont, String title, String dexc) {
    AwesomeDialog(
      body: Column(
        children: [
          Text(
            "Select Role",
            style: Theme.of(context).textTheme.headline3,
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () => Navigator.push(cont,
                  MaterialPageRoute(builder: (context) => PatientSignUpPage())),
              child: Text("Patient")),
          ElevatedButton(
              onPressed: () => Navigator.push(cont,
                  MaterialPageRoute(builder: (context) => DoctorSignUpPage())),
              child: Text("Doctor")),
          ElevatedButton(
              onPressed: () => Navigator.push(
                  cont,
                  MaterialPageRoute(
                      builder: (context) => PharmacySignUpPage())),
              child: Text("Pharmacist")),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
      context: cont,
      dialogType: DialogType.INFO,
      animType: AnimType.BOTTOMSLIDE,
    ).show();
  }

  void showError(BuildContext cont, String title, String dexc) {
    AwesomeDialog(
      context: cont,
      dialogType: DialogType.ERROR,
      animType: AnimType.BOTTOMSLIDE,
      dismissOnTouchOutside: false,
      btnOkOnPress: () {
        _conButton.reset();
      },
      title: title,
      desc: dexc,
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    final floatingactionbutton = FloatingActionButton(
      tooltip: "Cancel Login",
      onPressed: () {
        _conButton.reset();
      },
      child: FaIcon(FontAwesomeIcons.close),
    );
    final logo = Padding(
      padding: EdgeInsets.all(20),
      child: Hero(
          tag: 'hero',
          child: SizedBox(
              width: 200,
              height: 200,
              child: Image.asset('assets/images/logo.png'))),
    );
    final inputEmail = Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: _conUsername,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            hintText: 'Username',
            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(50.0))),
      ),
    );
    final inputPassword = Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: _conPassword,
        keyboardType: TextInputType.emailAddress,
        obscureText: true,
        decoration: InputDecoration(
            hintText: 'Password',
            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(50.0))),
      ),
    );
    final buttonLogin = Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: ButtonTheme(
        height: 56,
        child: RoundedLoadingButton(
            controller: _conButton,
            child: Text('Login',
                style: TextStyle(color: Colors.white, fontSize: 20)),
            color: Colors.black87,
            width: 400,
            onPressed: () async {
              if (_conUsername.text.isNotEmpty ||
                  _conPassword.text.isNotEmpty) {
                await _api
                    .chkLoginPat(_conUsername.text, _conPassword.text)
                    .then((value) {
                  if (value == 1) {
                    showErrorFlag = false;
                    nextPage(
                        MaterialPageRoute(
                            builder: (context) =>
                                PatientHomePage(Pusername: _conUsername.text)),
                        context);
                  } else {
                    print("Not Patient Value == $value");
                  }
                });
                await _api
                    .chkLoginDoc(_conUsername.text, _conPassword.text)
                    .then((value) {
                  if (value == 2) {
                    showErrorFlag = false;
                    nextPage(
                        MaterialPageRoute(
                            builder: (context) =>
                                DocHomePage(docName: _conUsername.text)),
                        context);
                  } else {
                    print("Not Doc Value == $value");
                  }
                });
                await _api
                    .chkLoginPhar(_conUsername.text, _conPassword.text)
                    .then((value) {
                  if (value == 3) {
                    showErrorFlag = false;
                    nextPage(
                        MaterialPageRoute(
                            builder: (context) => AllPrescription(
                                pharmacyUname: _conUsername.text)),
                        context);
                  } else {
                    print("Not Phar Value == $value");
                  }
                });
                showErrorFlag == true
                    ? showError(context, 'Login Failed',
                        "Recheck your username and password \nRegister if your do not have nay account! ")
                    : print("No ERROR");
              } else {
                showError(context, "Empty Text Field",
                    "Username or Password missing");
              }
            }),
      ),
    );
    final buttonForgotPassword = ElevatedButton(
        child: const Text(
          'Signup',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () {
          showOptions(context, "Sign Up", "Select your Role");
        });
    return Scaffold(
      floatingActionButton: floatingactionbutton,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 20),
          children: <Widget>[
            logo,
            const SizedBox(
              height: 60,
            ),
            inputEmail,
            inputPassword,
            buttonLogin,
            buttonForgotPassword
          ],
        ),
      ),
    );
  }
}
