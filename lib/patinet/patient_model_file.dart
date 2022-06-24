class PatientData {
  var username, password, Name, gender;
  String disease;
  double lat, long;
  int role;

  PatientData(
      {required this.username,
        required this.role,
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
    'role':role,
    'lat':lat,
    'long':long,
    'disease':disease,
  };
}
