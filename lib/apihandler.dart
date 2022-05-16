import 'package:dio/dio.dart';
import 'dart:convert' as convert;

import 'package:rxpakistan/doctor/doctor_model_file.dart';
import 'package:rxpakistan/patinet/patient_model_file.dart';

class ApiHandler
{
  var dio=Dio();
  var commonPart="http://192.168.18.37/rxApi/api/";


  Future<bool> postrx(var controller,var action,PrescriptionData object) async
  {
    try{
      var apiString="$commonPart$controller/$action";

    var response = await dio.post(apiString,data: convert.jsonEncode(object),onSendProgress: (a,b){
      print("Send Progress $a and $b");

    },onReceiveProgress: (a,b){
      print("Recive Progress $a and $b");
    });
    print(response.data.toString());
    return true;
    }catch(Exception){
      return false;
    }
  }
  Future<bool> postPatient(var controller,var action,PatientData object) async
  {
    try{
      var apiString="$commonPart$controller/$action";

      var response = await dio.post(apiString,data: convert.jsonEncode(object),onSendProgress: (a,b){
        print("Send Progress $a and $b");

      },onReceiveProgress: (a,b){
        print("Recive Progress $a and $b");
      });
      if(response.statusCode==200){
        print(response.data.toString());
        return true;
      }
      return false;
    }
    catch(Exception) {
      return false;
    }

  }
  Future<dynamic> getRecentPatients(var controller,var action,String docName) async
  {
    var apiString="$commonPart$controller/$action?docName=$docName";
    var response= await dio.get(apiString);
    if(response.statusCode==200) {
        return response.data;
      }
    else{
        return [];
      }
  }
  Future<int> getPrescriptionCount(var controller,var action) async{
    var apiString="$commonPart$controller/$action";
    var response= await dio.get(apiString);
    if(response.statusCode==200) {
      print("In api calling  ${response.data}");
      return response.data;
    }
    else {
      print('fasle');
      return -1;
    }
  }
  Future<dynamic> getAllDrugs(var controller,var action) async
  {
    var apiString="$commonPart$controller/$action";
    var response= await dio.get(apiString);
    if(response.statusCode==200) {
      print("In api calling  ${response.data}");
      return response.data;
    }
    else {
      print('true');
      return [] as List<String>;
    }
  }
  Future<dynamic> getAllPharmacy(var controller,var action,Function(bool) loadingFlag,Function(bool) isSheetOpen ) async
  {
    var apiString="$commonPart$controller/$action";
    var response= await dio.get(apiString);
    if(response.statusCode==200) {
      loadingFlag.call(true);
      isSheetOpen.call(true);
      return response.data;
    }
    else{
      return [];
    }
  }
  Future<dynamic> getPrescriptionForPharmacy(var controller,var action,String pharmacyUName) async
  {
    var apiString="$commonPart$controller/$action?value=$pharmacyUName";
    var response= await dio.get(apiString);
    if(response.statusCode==200) {
      return response.data;
    }
    else{
      return [];
    }
  }
}