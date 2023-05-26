import 'package:doctor_app/notifications/notifications_api.dart';
import 'package:doctor_app/patient/patient_api.dart';
import 'package:flutter/material.dart';

import '../patient_details/documents_display.dart';
import 'documents_upload.dart';
class Documents extends StatefulWidget {
  var type;
  var body;
  Documents({required this.type,this.body});

  @override
  State<Documents> createState() => _DocumentsState();
}

class _DocumentsState extends State<Documents> {
PatientApi patientApi=PatientApi();
NotificationApis notificationApis=NotificationApis();

  submitPatientDetails()async
  {
    var res=await patientApi.submitPatientDetails(widget.body, context).then((value)async{
      var body={
        'heading':'New Patient Added',
        'content':widget.body['first_name'],
        'sub_heading':'Age - ${widget.body['age']}'
      };
      var response=await notificationApis.addNotification(body, context);});
  }
  textButton()
  {
    return  TextButton(
      // height: 75,
      //minWidth: 1000,
      onPressed: (){
          submitPatientDetails();
        },
      child: Container(
        height:MediaQuery.of(context).size.height * 0.05 ,
        margin: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Color.fromRGBO(1, 127, 251, 1),
            borderRadius: BorderRadius.circular(5)),
        child: Text(
          'CONFIRM',
          style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:widget.type=='add'?AppBar(title: Text('Documents',style: Theme.of(context).textTheme.headline3,),):null,
      body: Column(children: [
        Container(
          padding: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Details', style: Theme.of(context).textTheme.headline1),
              widget.type!='add'?Container():Text(
                'Page 2 of 2',
                style: Theme.of(context).textTheme.headline3,
              ),
              widget.type=='add'?DocumentsUpload():DocumentsDisplay()
            ],
          ),
        ),
        textButton()
      ],),
    );
  }
}
