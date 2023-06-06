import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_app/home_screen.dart';
import 'package:doctor_app/notifications/notifications_api.dart';
import 'package:doctor_app/patient/patient_api.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../global_variables.dart';
import '../patient_details/documents_display.dart';
import 'add_picture.dart';
import 'documents_upload.dart';
class Documents extends StatefulWidget {
  var type;
  var body;
  var subType;
  var docs;
  var picDetails;
  Documents({required this.type,this.body,this.subType,this.docs,this.picDetails});

  @override
  State<Documents> createState() => _DocumentsState();
}

class _DocumentsState extends State<Documents> {
PatientApi patientApi=PatientApi();
NotificationApis notificationApis=NotificationApis();
var dataToSend;
var profile;
var docsList=[];
var loading=false;

CollectionReference _reference=FirebaseFirestore.instance.collection('patient_list');

  submitPatientDetails()async
  {
    var val1=await upload().then((value)async{
      var val=await patientApi.submitPatientDetails(widget.body,dataToSend, context).then((value)async{
        var body={
          'heading':'New Patient Added',
          'content':widget.body['first_name'],
          'sub_heading':'Age - ${widget.body['age']}'
        };
        var response=await notificationApis.addNotification(body, context).then((value){
          setState(() {
            imageUrlList.clear();
            imageList.clear();
            loading=false;
          });

          Navigator.pushAndRemoveUntil(
              context, MaterialPageRoute(builder: (c) => HomeScreen()), (
              Route<dynamic> route) => false);
        });
        });


    });





  }

  Future upload()async
  {
    setState(() {
      loading=true;
    });
    await uploadTOFirebase('profile',widget.picDetails!=null?widget.picDetails['profile_image']:null).then((value)async{
      print('imagelist:$imageList');
      if(imageList.isNotEmpty)
        {
          for(int i=0;i<imageList.length;i++)
          {
            await uploadTOFirebase('docs',imageList[i]);
          }
        }
    } );

  }

Future uploadTOFirebase(type,image)async
{
  if(image==null){
    return null;
  }
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
        print('profile: $profile');
      }
    else{
      imageUrlList.add(imageUrl);
      print('imageUrlList:$imageUrlList');
    }
    print('imageurl:$imageUrl');
    if(imageList.indexOf(image)==imageList.length-1)
      {
        print('hero');
        print(imageList.indexOf(image));
        print(imageList.length-1);

         dataToSend={
          'id':widget.body['mob_num'].toString(),
          'first_name':widget.body['first_name'].toString(),
          'profile_image':imageUrl.toString(),
          'documents':imageUrlList
        };
        print(dataToSend);
        //_reference.add(dataToSend);
      }

   // print(dataToSend);
  //widget.picDetails['documents']='';
  }catch(error)
  {
    print(error);
  }
}
addPicFun()
{
  print('entered addpicfun');
  return widget.picDetails['documents']=imageList;


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
          widget.type=='add' && widget.subType==null?'CONFIRM':'UPDATE',
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
        appBar:widget.type=='add'?widget.subType==null?AppBar(title: Text('Documents',style: Theme.of(context).textTheme.headline3,),):null:null,
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            padding: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Details', style: Theme.of(context).textTheme.headline1),
                widget.type!='add'?widget.subType!=null?Container():Text(
                  'Page 2 of 2',
                  style: Theme.of(context).textTheme.headline3,
                ):Container(),
              ],
            ),
          ),
          widget.type=='add' && widget.subType==null?Container():DocumentsDisplay(docs:widget.docs),
          AddPicture(type:'docs',fun: addPicFun),
          textButton()
        ],),
      ),
    );
  }
}
