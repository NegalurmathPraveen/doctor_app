class DoctorDetails{
  var id;
  var name;
  var mobile_number;
  var whatsapp_number;
  var email;
  var password;
  DoctorDetails({
    required this.id,
    required this.name,
    this.mobile_number,
    this.whatsapp_number,
    required this.email,
    required this.password,
  });
}