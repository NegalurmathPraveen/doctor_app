class PatientDetails {
  var id;
  var first_name;
  var mid_name;
  var last_name;
  var sex;
  var age;
  var age_group; //what is age group?
  var dob;
  var blood_group;
  var mob_num;
  var second_mob_num;
  var whatsapp_num;
  var email; //optional
  var father_name;
  var mother_name;
  var address;
  var city;
  var pincode;
  var referred_by;
  var allergies;
  var pre_term_days; //what are pre term days??
  var sec_num_type; //what is secondary number type?
  var significant_history;
  var office_id;
  var patient_id; // autogenerated?
  var additional_notes;
  var pat_image;
  var documents;
  var createdAt;
  var updatedAt;
  PatientDetails({
    required this.id,
    required this.first_name,
    this.mid_name,
    this.last_name,
    required this.sex,
    required this.age,
    this.age_group,
    required this.dob,
    required this.blood_group,
    required this.mob_num,
    this.second_mob_num,
    this.whatsapp_num,
    this.email,
    this.father_name,
    this.mother_name,
    this.address,
    this.city,
    this.pincode,
    this.referred_by,
    required this.allergies,
    this.pre_term_days,
    this.sec_num_type,
    this.significant_history,
    this.office_id,
    this.patient_id,
    this.additional_notes,
    this.pat_image,
    this.documents,
    required this.createdAt,
    required this.updatedAt
  });
}
