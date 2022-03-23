import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxpakistan/doctor/create_prescripton.dart';
import 'dart:convert' as convert;

class DocHomePage extends StatefulWidget {
  const DocHomePage({Key? key}) : super(key: key);

  @override
  State<DocHomePage> createState() => _DocHomePageState();
}

class _DocHomePageState extends State<DocHomePage> {

  List<String> titles =["Ashwan","Akbar Zain","Hammad","Tariq Ch","Usman Aslam","Awais tariq",
    "Zara Asharaf","Akbar Mirza","Tariq ali","Mutaza Ch","Eisha","Misbha","Akbar Mirza","Tariq ali","Mutaza Ch","Eisha","Misbha"];

  List<String> subtitles =["PO bhatti Dist Islamabad","PO Kartar Dist Rawalpindi","PO bhatti Dist Islamabad",
    "PO bhatti Dist Islamabad","PO Kartar Dist Rawalpindi","PO bhatti Dist Islamabad",
    "PO bhatti Dist Islamabad","PO Kazi Dist Islamabad","PO Rawat Dist Rawalpindi","PO Asli Dist Rawalpindi",
    "PO Kartar Dist Rawalpindi","PO Asli Dist Rawalpindi","PO Kartar Dist Rawalpindi"
    "PO Asli Dist Rawalpindi","PO Kartar Dist Rawalpindi","PO Ubaid Dist Rawalpindi","PO Kartar Dist Gujarkhan"];



  void postData() async
  {

    var dio=Dio();
    var response = await dio.post("http://192.168.100.23/task1/api/user/adddrug",data: convert.jsonEncode(Drug(
        Did: 12,
        DName: "Welchol",
        DExpDate: "2023-18-3",DStatus: 1,DType: "Tablet")),onSendProgress: (a,b){
      print("Send Progress $a and $b");

    },onReceiveProgress: (a,b){
      print("Recive Progress $a and $b");
    });
    print(response.data.toString());
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){

        postData();

      },child: Icon(Icons.add_outlined),),
      appBar: AppBar(
        title: Text("Patients",style: TextStyle(fontSize: 30)),

        actions: [
          IconButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>Prescription()));}, icon: Icon(Icons.add,size: 35,)),
          IconButton(onPressed: (){}, icon: Icon(Icons.account_box_rounded,size: 35,)),
        ],
      ),
      body: Container(
        child: ListView.builder(
          itemCount: 15,
          itemBuilder: (context,index){


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
                  offset: Offset(2,6),
                )],
                color: Colors.white

              ),
              child: ListTile(
                leading: Icon(Icons.account_circle_sharp,color: Colors.amber,size: 50,),
                title: Text(titles[index],style: TextStyle(fontSize: 20),),
                subtitle: Text(subtitles[index],style: TextStyle(fontSize: 15),),
              ),
            ),
          );
        },),
      )
    );
  }
}


class Drug
{
  int Did;
  String DName;
  int DStatus;
  String DType;
  String DExpDate;
  Drug({required this.Did,required this.DName,required this.DStatus,required this.DExpDate,required this.DType} );
  Map toJson() => {
    'Did': Did,
    'DName': DName,
    'DStatus': DStatus,
    'DExpDate': DExpDate,
    'DType': DType,
  };
}


