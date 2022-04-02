import 'package:dio/dio.dart';
import 'dart:convert' as convert;

import 'package:rxpakistan/doctor/doctor_model_file.dart';

class ApiHandler
{
  var dio=Dio();
  var commonPart="http://192.168.135.90/rxApi/api/";

  void postrx(var controller,var action,PrescriptionData object) async
  {
    var apiString="$commonPart$controller/$action";

    var response = await dio.post(apiString,data: convert.jsonEncode(object),onSendProgress: (a,b){
      print("Send Progress $a and $b");

    },onReceiveProgress: (a,b){
      print("Recive Progress $a and $b");
    });
    print(response.data.toString());
  }
}