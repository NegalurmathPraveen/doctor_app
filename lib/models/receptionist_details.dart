class ReceptionistDetails{
  var id;
  var name;
  var mob_num;
  var whatsapp_num;
  var email;
  var password;
  var status;
  var createdAt;
  var updatedAt;
  ReceptionistDetails({
     required this.id,
     this.name,
     this.mob_num,
     this.whatsapp_num,
     required this.email,
     required this.password,
     required this.status,
     required this.createdAt,
     required this.updatedAt
});
}