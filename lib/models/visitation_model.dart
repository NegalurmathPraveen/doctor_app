class VisitationModel{
  var patient_id;
  var visitation_id;
  var due_date;
  var message;
  var createdAt;
  var updatedAt;
  VisitationModel({
    required this.patient_id,
    required this.visitation_id,
    required this.due_date,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
  });
}