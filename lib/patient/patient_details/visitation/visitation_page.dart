import 'package:doctor_app/patient/patient_details/visitation/visitation_api.dart';
import 'package:doctor_app/widgets/add_message_widget.dart';
import 'package:flutter/material.dart';

class VisitationPage extends StatefulWidget {
  var patDetails;
  VisitationPage({required this.patDetails});

  @override
  State<VisitationPage> createState() => _VisitationPageState();
}

class _VisitationPageState extends State<VisitationPage> {
  ScrollController _scrollController = new ScrollController();
  VisitationApis visitationApis=VisitationApis();

  var visitationList=[];

  @override
  void initState() {
    getVisitations();
    super.initState();
  }
  getVisitations()async
  {
    visitationList=await visitationApis.getVisitations(widget.patDetails.id,context);
    setState(() {});
  }

  Widget cardWidget(var response,var width,var height)
  {
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height:height*0.01,),
              Text('Due date : ${response.due_date.toString()}',style:TextStyle(
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Inter',
                  fontSize: 17,color:Colors.blue),),
              SizedBox(height:height*0.01,),
              Text('${response.message.toString()}',style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                  fontSize: 18,color:Color.fromRGBO(0, 0, 0, 0.87)),),
              SizedBox(height:height*0.01,),
            ],
          ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height:height*0.7,
          child: visitationList.isEmpty?Center(child: Text('Oopss!! Visitation list is empty',style: Theme.of(context).textTheme.headline2,)):ListView(
            controller: _scrollController,
            children: visitationList.reversed.map((response) => cardWidget(response,width,height)).toList(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: ()async{
        visitationList=await showDialog(context: context,
            builder:(_)=>VisitationAlertDialog(patDetails: widget.patDetails,),
            barrierDismissible: true
        );
        setState(() {});
      },child: Icon(Icons.add),),
    );
  }
}

class VisitationAlertDialog extends StatefulWidget {
  var patDetails;
  VisitationAlertDialog({required this.patDetails});

  @override
  State<VisitationAlertDialog> createState() => _VisitationAlertDialogState();
}

class _VisitationAlertDialogState extends State<VisitationAlertDialog> {
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    return AlertDialog(title:Text('Follow up',style: TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.bold,
      fontSize: 25,color:Color.fromRGBO(0, 0, 0, 0.6),
    ),),
      contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      content: Container(
        height: height*0.47,
        width: width*0.8,
        child: AddMessage(page: 'visitation',patDetails:widget.patDetails),
      ),//alignment: Alignment.topRight,
       insetPadding: EdgeInsets.only(left: 10,right: 10),
    );
  }
}
