import 'package:doctor_app/patient/add_patient/documents.dart';
import 'package:flutter/material.dart';

import '../../global_variables.dart';
import '../add_patient/add_picture.dart';
import '../patient_form.dart';
import 'visitation/visitation_page.dart';

class PatientDetailsPage extends StatefulWidget {
  var patDetails;
  PatientDetailsPage({required this.patDetails});

  @override
  State<PatientDetailsPage> createState() => _PatientDetailsPageState();
}

class _PatientDetailsPageState extends State<PatientDetailsPage> {
  var edit=true;
 var image;
 var picDetails;
  addPicFun(type,imageFile)
  {
    print('entered addpicfun');
    if(type=='profile')
    {
      image=imageFile;
    }
    picDetails={
      'profile_image':image,
      'documents':imageList.toString()
    };
    print(picDetails);
    return picDetails;

  }
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom:TabBar(
            tabs: [
              Tab(child: Text('Details',style: Theme.of(context).textTheme.headline4,)),
              Tab(child: Text('Documents',style: Theme.of(context).textTheme.headline4,)),
              Tab(child: Text('Follow up',style: Theme.of(context).textTheme.headline4,)),
            ],
          ),
          title:Text(widget.patDetails.first_name,style: Theme.of(context).textTheme.headline3,),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height:height*0.05,
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(border:Border.all(color: Colors.blue)),
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.zero,
                        child: IconButton(icon: Icon(Icons.edit,color: Colors.blue,size: 25,),onPressed: (){
                          setState(() {
                            edit=!edit;
                          });
                        },),
                      ),
                    ],
                  ),
                  AddPicture(type:'profile',profile_image:widget.patDetails.pat_image,fun:addPicFun,),
                  PatientForm(type:'update',patDetails: widget.patDetails,edit:edit),
                ],
              ),
            ),
            Documents(type:'add',subType:'view',docs:widget.patDetails.documents),
            VisitationPage(patDetails:widget.patDetails,)
          ],
        ),
      ),
    );
  }
}
