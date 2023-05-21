import 'package:doctor_app/global_variables.dart';
import 'package:flutter/material.dart';
class PatientList extends StatefulWidget {
  const PatientList({Key? key}) : super(key: key);

  @override
  State<PatientList> createState() => _PatientListState();
}

class _PatientListState extends State<PatientList> {
  var check=false;
  Widget cardWidget(var response,var width,var height)
  {
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      child: ListTile(
          leading:  Container(
            width:width*0.12,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black12,
                image:DecorationImage(
                    fit: BoxFit.cover,
                    image:  AssetImage('assets/images/Image.png',)
                ) ),
          ),
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
          trailing: Checkbox(onChanged: (value){
            check=!check;
            setState(() {});
            },value: check,)
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text('Select Patients',style: Theme.of(context).textTheme.headline3,),),
      body:SingleChildScrollView(child: Column(children: constList.map((response) => cardWidget(response, width, height)).toList(),)),
    );
  }
}
