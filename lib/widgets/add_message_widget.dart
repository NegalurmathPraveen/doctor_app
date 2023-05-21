import 'package:doctor_app/2factor_apis.dart';
import 'package:doctor_app/drawer_widgets/vaccination/vaccination_api.dart';
import 'package:doctor_app/patient/patient_details/visitation/visitation_api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddMessage extends StatefulWidget {
  var page;
  var patDetails;
  AddMessage({required this.page,this.patDetails});

  @override
  State<AddMessage> createState() => _AddMessageState();
}

class _AddMessageState extends State<AddMessage> {
  TwoFactorApis twoFactorApis=TwoFactorApis();
  VaccinationApis vaccinationApis=VaccinationApis();
  VisitationApis visitationApis=VisitationApis();
  var _formKey = GlobalKey<FormState>();
  TextEditingController dateController = TextEditingController();
  var message;
  var error=false;


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
            dateController.text=DateFormat('dd-MM-yyyy').format(DateTime.parse(date.toString()));
            setState(() {
              error=false;
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
    var body={
      "due_date":dateController.text,
      "message":message,
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
    var inputFormat = DateFormat('dd-MM-yyyy');
    var date1 = inputFormat.parse(dateController.text);

    var outputFormat = DateFormat('yyyy-MM-dd');
    var date2 = outputFormat.format(date1);
   // var date1= DateFormat('yMd').format(DateTime.parse(dateController.text.toString()));
   print(date2);
   var date3=DateFormat("yyyy-MM-dd hh:mm:ss").parse(date2.toString()+' 11:00:00');
   print(date2);
    var details={
      "name":widget.patDetails.first_name,
      "date":dateController.text,
      "mobile_nos":widget.patDetails.mob_num,   //string seperated by commas
      "schedule_time":date3.toString()  //yyyy-mm-dd hh:mm:ss 24 hour format
    };
    print(details);
    var res=await twoFactorApis.trans_sms_api(details, context).then((value)async{
      await visitationApis.addNextVisitation(body, context).then((value) => Navigator.pop(context));
    });

  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder:(context,constraint){
       return Form(
         key:_formKey,
         child: Column(
          children: [
            SizedBox(height: constraint.maxHeight*0.02,),
            textFields('date',null,null),
            SizedBox(height: widget.page=='vaccination'?constraint.maxHeight *0.04:constraint.maxHeight*0.01,),
            textFields('message',null, null),
            // SizedBox(height: height*0.06,),
            // Card(elevation: 2,
            //   child: ListTile(
            //     onTap: (){
            //       Navigator.of(context)
            //           .push(MaterialPageRoute(builder: (c) => PatientList()));
            //     },
            //       leading: Text('Select Patients (0/4)',style:TextStyle(
            //       fontWeight: FontWeight.w400,
            //       fontFamily: 'Inter',
            //       fontSize: 17,color:Color.fromRGBO(0, 0, 0, 0.87)),),
            //   trailing:Icon(Icons.chevron_right,color:Colors.black,size: 25,),
            //   ),
            // ),
            SizedBox(height: widget.page=='vaccination'?constraint.maxHeight *0.41:constraint.maxHeight*0.06,),
            Card(
              elevation: 10,
              child: Container(
                width: double.infinity,
                height:widget.page=='vaccination'?constraint.maxHeight *0.07:constraint.maxHeight*0.11,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.blue,),
                child: TextButton(
                  onPressed:() {
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


                  },
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
       );
    });

  }
}
