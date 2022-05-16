
class Drugs {
  int rxidFK;
  var name;
  var type;
  var company;
  var method;
  var note;
  Drugs(
      {required this.rxidFK,
        required this.name,
        required this.type,
        required this.company,
        required this.method,
       this.note});
  Map toJson() => {
    'rxidFK': rxidFK,
    'company': company,
    'method': method,
    'drugs':name,
    'type': type,
    'Note': note,
  };
}



/*class DrugsForRx
{
  int rxidFK=-1;
  var company;
  var method;
  var drugs;
  var type;
  var Note;
  DrugsForRx({required this.rxidFK,required this.company,required this.method,required this.drugs,required this.type,required this.Note} );
  Map toJson() => {
  'rxidFK': rxidFK,
  'company': company,
  'method': method,
  'drugs':drugs,
  'type': type,
  'Note': Note,
};*/

class PrescriptionData
{
  List<Drugs> RxHaveDrugs=[];
  int rxid=-1;
  var rxDate;
  var DocUName;
  var PharmacyUName;
  var PatientUName;
  int rxStatus=-1;
  int rxRefil;
  PrescriptionData({required this.RxHaveDrugs,required this.rxid,
    required this.rxDate,required this.DocUName,
    required this.PharmacyUName,required this.PatientUName,required this.rxStatus,required this.rxRefil});
  Map toJson()=>{
    'RxHaveDrugs': RxHaveDrugs,
    'rxid': rxid,
    'rxDate': rxDate,
    'DocUName':DocUName,
    'PharmacyUName': PharmacyUName,
    'PatientUName': PatientUName,
    'rxStatus':rxStatus,
    'rxRefil':rxRefil,
  };
}


