import 'package:doctor_app/notifications/notification_page.dart';
import 'package:doctor_app/patient/add_patient/add_patient.dart';
import 'package:doctor_app/patient/patient_api.dart';
import 'package:doctor_app/drawer_widgets/side_drawer.dart';
import 'package:doctor_app/patient/patient_form.dart';
import 'package:flutter/material.dart';

import 'global_variables.dart';
import 'patient/display_profile_image.dart';
import 'patient/patient_details/patient_details_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PatientApi patientApi=PatientApi();
  ScrollController _scrollController = new ScrollController();

  List newList=[];
  List subList=[];
  bool isLoadingMore=false;

  var now = new DateTime.now();

  @override
  void initState() {
    getPatientslist();
    super.initState();
  }

  searchFunction(value)
  {
    subList.clear();
    value.toString().toLowerCase();
    if(value.toString().isEmpty)
      {
        subList.clear();
        print('sublist:${subList.length}');
        setState(() {});
      }
    else
      {
        patientList.forEach((element) {
          if(element.first_name.toString().toLowerCase().contains(value) || element.mob_num.toString().toLowerCase().contains(value) || element.age.toString().contains(value)){
            setState(() {
              subList.add(element);
            });
          }
        });
      }

  }
  getPatientslist()async{
   await patientApi.getAllPatientsList(page,context);
    constList=List.from(patientList);
    _scrollController.addListener(_scrollListener);
    setState(() {});
    print(patientList);
  }

  _scrollListener()async{
    if(isLoadingMore) return;
    if(_scrollController.position.pixels==_scrollController.position.maxScrollExtent)
      {
        setState(() {
          isLoadingMore=true;
        });
        page=page-1;
        await patientApi.getAllPatientsList(page,context);
        constList=List.from(patientList);
        setState(() {
          isLoadingMore=false;
        });
      }
  }
  Widget cardWidget(var response,var width,var height)
  {
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      child: ListTile(
        //shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          onTap: (){
            Navigator.of(context).push(
                MaterialPageRoute(builder: (c) => PatientDetailsPage(patDetails: response,)));
          },
          leading: ProfileImage(details:response),
          // Container(
          //   width:width*0.12,
          //   decoration: BoxDecoration(
          //     shape: BoxShape.circle,
          //       color: Colors.black12,
          //       image:DecorationImage(
          //           fit: BoxFit.cover,
          //           image:  AssetImage('assets/images/Image.png',)
          //       ) ),
          // ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height:height*0.01,),
              Text(response.first_name.toString(),style:TextStyle(
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Inter',
                  fontSize: 17,color:Color.fromRGBO(0, 0, 0, 0.87)),),
              SizedBox(height:height*0.01,),
              Text('+91-${response.mob_num.toString()}',style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Inter',
                  fontSize: 16,color:Color.fromRGBO(0, 0, 0, 0.6)),),
              SizedBox(height:height*0.01,),
            ],
          ),
          subtitle: Text(response.createdAt.toString().split(' ')[0],style:  TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
            fontSize: 15,
            color: Color.fromRGBO(0, 0, 0, 0.6),
          ),),
          trailing: Column(
            children: [
              Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: Colors.blue),
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12,vertical:7),
                    //alignment: Alignment.topCenter,
                    child: Text('age:${response.age.toString()}',style:TextStyle(
                        color:Colors.white,
                        fontWeight: FontWeight.w200,
                        fontFamily: 'Inter',
                        fontSize: 15),)),),
            ],
          )
      ),
    );
  }

  filterFunction(var time)
  {
    patientList.clear();
    newList.forEach((element) {
      var eleDate=DateTime.parse(element.createdAt.toString());
      if(time.isBefore(eleDate)){
        setState(() {
          patientList.add(element);
        });
      }
      setState(() {});
    });

  }

  dialogButton(var title)
  {
    newList=List.from(constList);
    subList.clear();
    print('new:$newList');
    var now_1w = now.subtract(Duration(days: 7));
    var now_1m = new DateTime(now.year, now.month-1, now.day);
    return TextButton(
        onPressed:(){
      if(title=='All Time')
        {
          patientList.clear();
            patientList=List.from(constList);
            setState(() {});
        }
      else if(title=='Today')
      {
        print('today');
        print(newList);
        patientList.clear();
        newList.forEach((element) {
          var eleDate=DateTime.parse(element.createdAt.toString());
          print('day:${eleDate.day}');
          print('now:${now.day.toString()}');
            if(eleDate.day.toString()==now.day.toString()){
              setState(() {
                patientList.add(element);
              });
            }
            print(patientList);
            setState(() {});
            print('yes');
        });
      }
      else if(title=='This Week')
        {
          filterFunction(now_1w);
        }
      else
        {
          filterFunction(now_1m);
        }
      Navigator.pop(context);
    }, child:Container(width:double.infinity,child: Text(title,style: Theme.of(context).textTheme.headline3,)));
  }
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: SideDrawer(fun: (){},),
      appBar: AppBar(
        title: Text('All Patients',style: Theme.of(context).textTheme.headline3,),
        actions: [IconButton(onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(
              builder: (c) =>NotificationPage()));
        }, icon:Icon(Icons.notifications_outlined,color:Color.fromRGBO(0, 0, 0, 0.6),size: 25,))],
      ),
      body:Column(
        children: [
          SizedBox(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: width*0.75,
                height: height*0.1,
                alignment: Alignment.center,
                child: TextField(
                  onChanged: (value){
                    searchFunction(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search..',
                      border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 15)),
                ),
              ),
              Container(
                //height: height*0.15,
                decoration: BoxDecoration(border: Border.all(),borderRadius: BorderRadius.circular(10)),
                child: IconButton(onPressed: (){
                  showDialog(context: context,
                      builder:(_)=>AlertDialog(
                        contentPadding: EdgeInsets.all(5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                        content: Container(
                          height: height*0.3,
                          width: width*0.1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            dialogButton('All Time'),
                            Divider(thickness: 2),
                            dialogButton('Today'),
                              Divider(thickness: 2),
                            dialogButton('This Week'),
                              Divider(thickness: 2),
                            dialogButton('This Month'),
                          ],),
                        ),//alignment: Alignment.topRight,
                        insetPadding: EdgeInsets.only(left: 190,right: 10,bottom: 200),
                      ),
                    barrierDismissible: true
                  );
                },icon: Icon(Icons.filter_list_rounded,size: 30,),),
              )
            ],
      ),
          Divider(color: Colors.black12,thickness:5 ),
          SingleChildScrollView(
            child: Stack(
              children: [Container(
                height:height*0.7,
                child: patientList.isEmpty?Center(child: Text('Oopss!! Patients list is empty',style: Theme.of(context).textTheme.headline2,)):ListView(
                  controller: _scrollController,
                  children: subList.length!=0?subList.map((response) => cardWidget(response,width,height)).toList():patientList.map((response) => cardWidget(response,width,height)).toList(),
                ),
              ),
                isLoadingMore?Positioned(
                  bottom: 0,
                    left: width*0.45,
                    child: CircularProgressIndicator()):Container()
              ]
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.of(context).push(MaterialPageRoute(
            builder: (c) =>AddPatient()));
      },child: Icon(Icons.add),),
    );
  }
}
