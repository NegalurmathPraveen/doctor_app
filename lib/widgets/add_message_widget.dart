import 'package:doctor_app/2factor_apis.dart';
import 'package:doctor_app/drawer_widgets/vaccination/vaccination_api.dart';
import 'package:doctor_app/patient/patient_details/visitation/visitation_api.dart';
import 'package:doctor_app/whatsapp_message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../drawer_widgets/vaccination/patient_list.dart';

class AddMessage extends StatefulWidget {
  var page;
  var patDetails;
  AddMessage({required this.page,this.patDetails});

  @override
  State<AddMessage> createState() => _AddMessageState();
}

class _AddMessageState extends State<AddMessage> {
  WhatsappMsg whatsappMsg=WhatsappMsg();
  TwoFactorApis twoFactorApis=TwoFactorApis();
  VaccinationApis vaccinationApis=VaccinationApis();
  VisitationApis visitationApis=VisitationApis();
  var _formKey = GlobalKey<FormState>();
  TextEditingController dateController = TextEditingController();
  var message;
  var error=false;
  var date3;
  var ratio;
  var loading=false;
  List patList=[];

  getVaccPatList()async
  {
    var res=await vaccinationApis.vaccinePatients(date3.toString(), context);
        setState(() {
          ratio=res['ratio'];
          patList=res['patList'];
          loading=false;
        });
    print('res:$res');

  }
  Widget textFields(String labelText, var inputFormatters, var limit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ' $labelText',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: Color.fromRGBO(40, 41, 61, 1),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        TextFormField(
          onTap: labelText == 'date'
              ? ()async{
            // Below line stops keyboard from appearing
            DateTime? date = DateTime(1900);
            FocusScope.of(context).requestFocus(new FocusNode());
            date = await showDatePicker(
                context: context,
                initialDate:DateTime.now(),
                firstDate:DateTime.now(),
                lastDate: DateTime(2100));
            // Show Date Picker Here
            setState(() {
              loading=true;
            });
            dateController.text=DateFormat('dd-MM-yyyy').format(DateTime.parse(date.toString()));
            var inputFormat = DateFormat('dd-MM-yyyy');
            var date1 = inputFormat.parse(dateController.text);

            var outputFormat = DateFormat('yyyy-MM-dd');
            var date2 = outputFormat.format(date1);
            // var date1= DateFormat('yMd').format(DateTime.parse(dateController.text.toString()));
            date3=DateFormat("yyyy-MM-dd hh:mm:ss").parse(date2.toString()+' 11:00:00');
            if(widget.page=='vaccination')
              getVaccPatList();

            setState(() {
              error=false;
              if(widget.page!='vaccination')
                loading=false;
            });
          } : null,
          maxLength: limit,
          maxLines: labelText == 'message'
              ? 6 : null,
          style: Theme.of(context).textTheme.headline4,
          inputFormatters: inputFormatters,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
              suffixIcon: labelText=='date'?Icon(Icons.calendar_month_outlined):null,
              hintText: labelText=='date'?dateController.text:null,
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              contentPadding:
              EdgeInsets.symmetric(vertical: 10, horizontal: 15)),
          validator: (value) {
            if (labelText == 'message') {
              if (value!.isEmpty) {
                return 'can\'t be empty';
              } else if (value.length < 3) {
                return 'message length shouldn\'t be less than 3 letters';
              } else if (value.length > 200) {
                return 'message length shouldn\'t be more than 200 letters';
              } else {
                return null;
              }
            }else {
              return null;
            }
          },
          onSaved: (value) {
            if (labelText == 'message') {
              message = value;
            }
          },
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        )
      ],
    );
  }

  submitVaccinationDetails()async
  {
    List nos=[];
    patList.forEach((element) {nos.add(element.mob_num);});
    var body={
      "due_date":date3.toString(),
      "mobile_nos":nos.toString().replaceAll('[', '').replaceAll(']','')
    };
      var res=await vaccinationApis.addVaccination(body, context).then((value) => Navigator.pop(context));

  }

  submitVisitationDetails()async
  {
    var body={
      "patient_id":widget.patDetails.id,
      "due_date":dateController.text,
      "message":message,
    };

    var details={
      "name":widget.patDetails.first_name,
      "date":dateController.text,
      "mobile_nos":widget.patDetails.mob_num,   //string seperated by commas
      "schedule_time":date3.toString()  //yyyy-mm-dd hh:mm:ss 24 hour format
    };
    print(details);
    // var res=await twoFactorApis.trans_sms_api(details, context).then((value)async{
    //   await visitationApis.addNextVisitation(body, context).then((value) => Navigator.pop(context));
    // });

    var res=await whatsappMsg.whatsappMsg(details, context).then((value)async{
      await visitationApis.addNextVisitation(body, context).then((value) => Navigator.pop(context));
    });

  }
  cardWidget(var response,var width,var height)
  {
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height:height*0.01,),
            Text('Patient name : ${response.first_name.toString()}',style:TextStyle(
                fontWeight: FontWeight.w400,
                fontFamily: 'Inter',
                fontSize: 17,color:Colors.blue),),
            SizedBox(height:height*0.01,),
            Text('${response.mob_num.toString()}',style: TextStyle(
                fontWeight: FontWeight.w500,
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
    return LayoutBuilder(builder:(context,constraint){
       return Stack(
         children:[
           Form(
           key:_formKey,
           child: Column(
            children: [
              SizedBox(height: constraint.maxHeight*0.02,),
              textFields('date',null,null),
              SizedBox(height:constraint.maxHeight*0.01,),
              widget.page!='vaccination'?textFields('message',null, null):Container(),
              widget.page=='vaccination'&& ratio!=null?SizedBox(height:constraint.maxHeight *0.02,):Container(),
              widget.page=='vaccination'&& ratio!=null?Card(elevation: 2,
                child: ListTile(
                    leading: Text('Patients (${ratio})',style:TextStyle(
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Inter',
                    fontSize: 17,color:Color.fromRGBO(0, 0, 0, 0.87)),),
                ),
              ):Container(),
              SizedBox(height: widget.page=='vaccination'?ratio!=null?constraint.maxHeight *0.01:constraint.maxHeight*0.72:constraint.maxHeight*0.06,),
              widget.page=='vaccination'?ratio!=null?SingleChildScrollView(
                child: Container(
                  height:constraint.maxHeight *0.60,
                  child: patList==null || patList.isEmpty?Center(child: Text('Oopss!! patient list is empty',style: Theme.of(context).textTheme.headline2,)):ListView(
                    //controller: _scrollController,
                    children: patList.map<Widget>((response) => cardWidget(response,constraint.maxWidth,constraint.maxHeight)).toList(),
                  ),
                ),
              ):Container():Container(),
              Card(
                elevation: 10,
                child: Container(
                  width: double.infinity,
                  height:widget.page=='vaccination'?constraint.maxHeight *0.07:constraint.maxHeight*0.11,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.blue,),
                  child: TextButton(
                    onPressed:(widget.page=='vaccination' && ratio!=null) || widget.page!='vaccination'?() {
                      final isValid = _formKey.currentState!.validate();
                      FocusScope.of(context).unfocus();
                      print('entered');
                      if (isValid) {
                        _formKey.currentState!.save();
                        if(dateController.text.isNotEmpty)
                          {
                            widget.page=='vaccination'? submitVaccinationDetails():submitVisitationDetails();
                            print('clicked');
                          }
                        else
                          {
                            setState(() {
                              error=true;
                            });
                          }
                      }


                    }:null,
                    child: Text(widget.page=='vaccination'?
                      'Confirm':'ADD',
                      style: TextStyle(
                          color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              error?Text('choose date',style: TextStyle(color: Colors.red),):Container()
            ],
      ),
         ),
           loading==true?Center(child: Container(decoration:BoxDecoration(color:Colors.black12,borderRadius: BorderRadius.circular(15)),child: Container(margin:EdgeInsets.all(25),child: CircularProgressIndicator()))):Container()
         ],
       );
    });

  }
}
