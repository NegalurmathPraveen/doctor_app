class DoctorDetails{
  var id;
  var name;
  var role;
  var mobile_number;
  var whatsapp_number;
  var status;
  var email;
  var password;
  DoctorDetails({
    required this.id,
    required this.name,
    required this.role,
    this.status,
    this.mobile_number,
    this.whatsapp_number,
    required this.email,
    required this.password,
  });
}