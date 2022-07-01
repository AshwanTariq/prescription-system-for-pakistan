import 'package:dio/dio.dart';
import 'dart:convert' as convert;

import 'package:rxpakistan/doctor/doctor_model_file.dart';
import 'package:rxpakistan/patinet/patient_model_file.dart';
import 'package:rxpakistan/signup_pages/doctor_signup.dart';
import 'package:rxpakistan/signup_pages/pharmacy_signup.dart';

class ApiHandler {
  var dio = Dio();
  final _controllerForlogin="admin";
  var commonPart = "http://192.168.201.90/rxApi/api/";

  /// PATIENT SIDE OPERATIONS







  Future<dynamic> chkLoginDoc(String user, String password) async {
    var apiStringD =
        "$commonPart$_controllerForlogin/loginDoctor?username=$user&password=$password";

    dynamic value=await dio.get(apiStringD).then((value) {
      print("In Doctor ${value.data}");
      if (value.data == 2) {
        return value.data;
      } else {
        return value.data;
      }
    });
    return value;
  }
  Future<dynamic> chkLoginPat(String user, String password) async {
    var apiStringP = "$commonPart$_controllerForlogin/loginPatient?username=$user&password=$password";

   dynamic value= await dio.get(apiStringP).then((value) {
      print("In Patient ${value.data}");
      if (value.data == 1) {
        return value.data;
      } else {
        return value.data;
      }
    });
    return value;
  }
  Future<dynamic> chkLoginPhar(String user, String password) async {
    var apiStringPh =
        "$commonPart$_controllerForlogin/loginPharmacy?username=$user&password=$password";
   dynamic value= await dio.get(apiStringPh).then((value) {
      print("In pharmacy ${value.data}");
      if (value.data == 3) {
        return value.data;
      } else {
        return value.data;
      }
    });
    return value;
  }
  Future<dynamic> getDashboardData(
      var controller, var action, String uname) async {
    var apiString = "$commonPart$controller/$action?PUname=$uname";
    var response = await dio.get(apiString);

    print(" DATA IN FUNCTION  getDashboardData :: ${response.data}");

    if (response.statusCode == 200) {
      return response.data;
    } else {
      return [];
    }
  }

  Future<dynamic> gethistory(var controller, var action, String uname) async {
    var apiString = "$commonPart$controller/$action?uname=$uname";
    var response = await dio.get(apiString);

    print(" datatata ${response.data}");

    if (response.statusCode == 200) {
      return response.data;
    } else {
      return [];
    }
  }

  /// ADMIN SIDE OPERATIONS
  Future<bool> updateDrugsStatus(
      var controller, var action, int status, int id) async {
    var apiString = "$commonPart$controller/$action?status=$status&id=$id";
    await dio.post(apiString).then((value) {
      if (value.data == "1") {
        return true;
      } else {
        return false;
      }
    });
    return false;
  }

  Future<dynamic> getDrugsStatus(var controller, var action, int status) async {
    var apiString = "$commonPart$controller/$action?status=$status";
    var response = await dio.get(apiString);

    print(" datatata ${response.data}");

    if (response.statusCode == 200) {
      return response.data;
    } else {
      return [];
    }
  }

  Future<dynamic> getAllPharmacies(var controller, var action) async {
    var apiString = "$commonPart$controller/$action";
    var response = await dio.get(apiString);

    print(" datatata ${response.data}");

    if (response.statusCode == 200) {
      return response.data;
    } else {
      return [];
    }
  }

  Future<dynamic> getAllDoctors(var controller, var action) async {
    var apiString = "$commonPart$controller/$action";
    var response = await dio.get(apiString);

    print(" datatata ${response.data}");

    if (response.statusCode == 200) {
      return response.data;
    } else {
      return [];
    }
  }

  ///               DOCTOR SIDE OPRATIONS

  Future<bool> postrx(
      var controller, var action, PrescriptionData object) async {
    try {
      var apiString = "$commonPart$controller/$action";

      var response = await dio.post(apiString, data: convert.jsonEncode(object),
          onSendProgress: (a, b) {
        print("Send Progress $a and $b");
      }, onReceiveProgress: (a, b) {
        print("Recive Progress $a and $b");
      });
      print(response.data.toString());
      return true;
    } catch (Exception) {
      return false;
    }
  }

  Future<bool> postPatient(
      var controller, var action, PatientData object) async {
    try {
      var apiString = "$commonPart$controller/$action";

      var response = await dio.post(apiString, data: convert.jsonEncode(object),
          onSendProgress: (a, b) {
        print("Send Progress $a and $b");
      }, onReceiveProgress: (a, b) {
        print("Recive Progress $a and $b");
      });
      if (response.statusCode == 200) {
        print(response.data.toString());
        return true;
      }
      return false;
    } catch (Exception) {
      return false;
    }
  }
  Future<bool> postDoctor(
      var controller, var action, DoctorData object) async {
    try {
      var apiString = "$commonPart$controller/$action";

      var response = await dio.post(apiString, data: convert.jsonEncode(object),
          onSendProgress: (a, b) {
            print("Send Progress $a and $b");
          }, onReceiveProgress: (a, b) {
            print("Recive Progress $a and $b");
          });
      if (response.statusCode == 200) {
        print(response.data.toString());
        return true;
      }
      return false;
    } catch (Exception) {
      return false;
    }
  }
  Future<bool> postPharmacy(
      var controller, var action, PharmacyData object) async {
    try {
      var apiString = "$commonPart$controller/$action";

      var response = await dio.post(apiString, data: convert.jsonEncode(object),
          onSendProgress: (a, b) {
            print("Send Progress $a and $b");
          }, onReceiveProgress: (a, b) {
            print("Recive Progress $a and $b");
          });
      if (response.statusCode == 200) {
        print(response.data.toString());
        return true;
      }
      return false;
    } catch (Exception) {
      return false;
    }
  }

  Future<dynamic> getRecentPatients(
      var controller, var action, String docName) async {
    var apiString = "$commonPart$controller/$action?docName=$docName";
    var response = await dio.get(apiString);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      return [];
    }
  }

  Future<int> getPrescriptionCount(var controller, var action) async {
    var apiString = "$commonPart$controller/$action";
    var response = await dio.get(apiString);
    if (response.statusCode == 200) {
      print("In api calling  ${response.data}");
      return response.data;
    } else {
      print('fasle');
      return -1;
    }
  }

  Future<dynamic> getAllDrugs(var controller, var action) async {
    var apiString = "$commonPart$controller/$action";
    var response = await dio.get(apiString);
    if (response.statusCode == 200) {
      print("In api calling  ${response.data}");
      return response.data;
    } else {
      print('true');
      return [] as List<String>;
    }
  }
  Future<bool> chkDrugToDrug(String dname,var controller, var action,) async {
    var apiStringD = "$commonPart$controller/$action?conDrugsUnSplited=$dname";

    Response rs=await dio.get(apiStringD);
    if(rs.statusCode==200){
      if(rs.data){
        return true;
      }else{
        return false;
      }
    }else{
      print("EXCEPTION IN API STATUS CODE IS NOT 200");
      return false;
    }


  }

  Future<dynamic> getAllPharmacy(var controller, var action,
      Function(bool) loadingFlag, Function(bool) isSheetOpen,double latitude,double longitude) async {
    var apiString = "$commonPart$controller/$action?latitude=$latitude&longitude=$longitude";
    var response = await dio.get(apiString);
    if (response.statusCode == 200) {
      loadingFlag.call(true);
      isSheetOpen.call(true);
      return response.data;
    } else {
      return [];
    }
  }

  Future<dynamic> getPrescriptionForPharmacy(
      var controller, var action, String pharmacyUName) async {
    var apiString = "$commonPart$controller/$action?value=$pharmacyUName";
    var response = await dio.get(apiString);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      return [];
    }
  }

  Future<dynamic> setRxRecived(var controller, var action, int rxid) async {
    var apiString = "$commonPart$controller/$action?value=$rxid";
    var response = await dio.get(apiString);
    if (response.statusCode == 200) {
      print("DONE ${response.data}");
      return response.data;
    } else {
      return [];
    }
  }
}
