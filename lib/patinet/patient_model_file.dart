class PatientData {
  var username, password, Name, gender;
  String disease;
  double lat, long;
  PatientData(
      {required this.username,
      required this.password,
      required this.Name,
      required this.gender,
      required this.disease,
      required this.lat,
      required this.long});
  Map toJson()=>{
    'username':username,
    'password':password,
    'Name':Name,
    'Gender':gender,
    'lat':lat,
    'long':long,
    'disease':disease,
  };
}
