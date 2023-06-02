import 'package:doctor_app/drawer_widgets/receptionist/receptionist_api.dart';
import 'package:flutter/material.dart';

import 'add_receptionist.dart';
import 'status_button.dart';

class ReceptionistPage extends StatefulWidget {
  @override
  State<ReceptionistPage> createState() => _ReceptionistPageState();
}

class _ReceptionistPageState extends State<ReceptionistPage> {
  ScrollController _scrollController = new ScrollController();
  ReceptionistApis receptionistApis=ReceptionistApis();
  List receptionistList=[];



  Widget cardWidget(var response,var width,var height)
  {
    return Card(
        margin: EdgeInsets.only(bottom: 10),
        child: ListTile(
          trailing:StatusButton(status:response.status.toString()),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height:height*0.01,),
              Text('name : ${response.name.toString()}',style:TextStyle(
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Inter',
                  fontSize: 17,color:Colors.blue),),
              SizedBox(height:height*0.01,),
              Text('email - ${response.email.toString()}',style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                  fontSize: 18,color:Color.fromRGBO(0, 0, 0, 0.87)),),
              SizedBox(height:height*0.01,),
            ],
          ),
        )
    );
  }
  @override
  void initState() {
   getList();
    super.initState();
  }

  getList()async
  {
    receptionistList=await receptionistApis.getAllReceptionistList(context);
    print(receptionistList);
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Receptionists',style: Theme.of(context).textTheme.headline3,),
      ),
      body:Column(
        children: [
          SingleChildScrollView(
            child: Container(
              height:height*0.7,
              child: receptionistList.isEmpty?Center(child: Text('Oopss!! Patients list is empty',style: Theme.of(context).textTheme.headline2,)):ListView(
                controller: _scrollController,
                children: receptionistList.reversed.map((response) => cardWidget(response,width,height)).toList(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.of(context).push(MaterialPageRoute(
            builder: (c) =>AddReceptionist(type:'add')));
      },child: Icon(Icons.add),),
    );
  }
}
