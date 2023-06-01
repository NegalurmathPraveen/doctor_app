import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_app/notifications/notifications_api.dart';
import 'package:doctor_app/patient/patient_api.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../patient_details/documents_display.dart';
import 'add_picture.dart';
import 'documents_upload.dart';
class Documents extends StatefulWidget {
  var type;
  var body;
  var picDetails;
  Documents({required this.type,this.body,this.picDetails});

  @override
  State<Documents> createState() => _DocumentsState();
}

class _DocumentsState extends State<Documents> {
PatientApi patientApi=PatientApi();
NotificationApis notificationApis=NotificationApis();

var profile;
var imageList=[];
var docsList=[];
var loading=false;

CollectionReference _reference=FirebaseFirestore.instance.collection('patient_list');

  submitPatientDetails()async
  {
    upload();
    var res=await patientApi.submitPatientDetails(widget.body, context).then((value)async{
      var body={
        'heading':'New Patient Added',
        'content':widget.body['first_name'],
        'sub_heading':'Age - ${widget.body['age']}'
      };
      var response=await notificationApis.addNotification(body, context);
    setState(() {
      loading=false;
    });
    }

    );
  }

  upload()
  {
    setState(() {
      loading=true;
    });
    uploadTOFirebase('profile',widget.picDetails['profile_image']).then((value) {
      uploadTOFirebase('docs',widget.picDetails['profile_image']);
    } );

  }

Future uploadTOFirebase(type,image)async
{
  String uniqueFileName=DateTime.now().millisecondsSinceEpoch.toString();
  //get a reference to storage root
  Reference referenceRoot=FirebaseStorage.instance.ref();
  Reference referenceDirImages=referenceRoot.child('images');

  //create a reference for the image to be stored
  Reference referenceImageToUpload=referenceDirImages.child(uniqueFileName);
  //handle errors/success
  try{
    //store the image
    await referenceImageToUpload.putFile(File(image.path!));

    //sucess:get the download url

    var imageUrl=await referenceImageToUpload.getDownloadURL();

    if(type=='profile')
      {
        profile=imageUrl;
      }
    else{
      imageList.add(imageUrl);
    }
    print('imageurl:$imageUrl');

    // Map<String,String> dataToSend={
    //   'id':widget.mob_num.toString(),
    //   'first_name':widget.name.toString(),
    //   'profile_image':imageUrl.toString(),
    //   'documents':''
    // };
   // print(dataToSend);
  widget.picDetails['documents']='';
    _reference.add(widget.picDetails);
  }catch(error)
  {
    print(error);
  }
}
  textButton()
  {
    return  loading?CircularProgressIndicator():TextButton(
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
            ],
          ),
        ),
        widget.type=='add'?AddPicture(type:'docs'):DocumentsDisplay(),
        textButton()
      ],),
    );
  }
}
