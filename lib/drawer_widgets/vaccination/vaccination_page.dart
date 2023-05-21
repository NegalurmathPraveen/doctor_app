import 'package:doctor_app/drawer_widgets/vaccination/vaccination_api.dart';
import 'package:flutter/material.dart';

import 'vaccination_message.dart';
class VaccinationPage extends StatefulWidget {
  const VaccinationPage({Key? key}) : super(key: key);

  @override
  State<VaccinationPage> createState() => _VaccinationPageState();
}

class _VaccinationPageState extends State<VaccinationPage> {
  VaccinationApis vaccinationApis=VaccinationApis();
  ScrollController _scrollController = new ScrollController();
  List vaccinationList=[];


  @override
  void initState() {
    getVaccination();
    super.initState();
  }
  getVaccination()async
  {
    vaccinationList=await vaccinationApis.getVaccination(context);
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
      )
    );
  }
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Vaccination follow-up',style: Theme.of(context).textTheme.headline3,),
      ),
      body:Column(
        children: [
          SingleChildScrollView(
            child: Container(
              height:height*0.7,
              child: vaccinationList.isEmpty?Center(child: Text('Oopss!! Patients list is empty',style: Theme.of(context).textTheme.headline2,)):ListView(
                controller: _scrollController,
                children: vaccinationList.reversed.map((response) => cardWidget(response,width,height)).toList(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.of(context).push(MaterialPageRoute(
            builder: (c) =>VaccineMessage()));
      },child: Icon(Icons.add),),
    );
  }
}
