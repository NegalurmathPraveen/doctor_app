import 'dart:convert';

import 'package:doctor_app/notifications/notifications_api.dart';
import 'package:doctor_app/patient/patient_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../global_variables.dart';
import 'add_patient/add_picture.dart';
import 'add_patient/documents.dart';

class PatientForm extends StatefulWidget {
  var type;
  var patDetails;
  var edit;
  PatientForm({required this.type,this.patDetails,this.edit});
  @override
  State<PatientForm> createState() => _PatientFormState();
}

class _PatientFormState extends State<PatientForm> {
  PatientApi patientApi=PatientApi();
  NotificationApis notificationApis=NotificationApis();
  var _formKey = GlobalKey<FormState>();
  var display=true;
  var loading=false;
  var noDob=false;
  var picDetails;
  var image;
  var first_name;
  var mid_name;
  var last_name;
  String sex = 'Male';
  var age;
  var age_group; //what is age group?
  var dob;
  String blood_group = 'B+';
  var mob_num;
  var second_mob_num;
  var whatsapp_num;
  var email; //optional
  var father_name;
  var mother_name;
  var address;
  var city;
  var pincode;
  var referred_by;
  var allergies;
  var pre_term_days; //what are pre term days??
  var sec_num_type; //what is secondary number type?
  var significant_history;
  var office_id;
  var patient_id; // autogenerated?
  var additional_notes;
  TextEditingController dobController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    if(widget.type=='update')
    {
      dob=widget.patDetails.dob;
      print(dob);
      setState(() {
        print('came here');
        noDob=false;
      });
    }
    super.initState();
  }
   textButton() {
    return TextButton(
      // height: 75,
      //minWidth: 1000,
      onPressed: () {
        final isValid = _formKey.currentState!.validate();
        FocusScope.of(context).unfocus();
        print('entered');
        if (isValid) {
          _formKey.currentState!.save();
          print(dob);
          if(dob.toString().isEmpty)
            {
              noDob=true;
              setState(() {});
            }
          else
            {
              setState(() {
                noDob=false;
              });
              submitDetails();
            }

        }
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.05,
        //margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Color.fromRGBO(1, 127, 251, 1),
            borderRadius: BorderRadius.circular(5)),
        child: Text(widget.type=='update'?'Update':
          'NEXT',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
  submitDetails(){
    setState(() {
      loading=true;
    });
    var body = {
      'first_name': first_name.toString(),
      'mid_name': mid_name,
      'last_name': last_name,
      'sex': sex,
      'age': age,
      'age_group': age_group, //what is age group?
      'dob': dobController.text,
      'blood_group': blood_group,
      'mob_num': mob_num,
      'second_mob_num': second_mob_num,
      'whatsapp_num': whatsapp_num,
      'email': email,
      'father_name': father_name,
      'mother_name': mother_name,
      'address': address,
      'city': city,
      'pincode': pincode,
      'referred_by': referred_by,
      'allergies': allergies,
      'pre_term_days': pre_term_days, //what are pre term days??
      'sec_num_type': sec_num_type, //what is secondary number type?
      'significant_history': significant_history,
      'office_id': office_id,
      'patient_id': patient_id, // autogenerated?
      'additional_notes': additional_notes,
    };
    print(json.encode(body));
    if(widget.type=='update')
      {
        print('entered update');
          var res=patientApi.updatePatientDetails(widget.patDetails,picDetails,body, context).then((value)async{
            var notbody={
              'heading':'Patient Edited',
              'content':first_name.toString(),
              'sub_heading':age.toString()
            };
            var response=await notificationApis.addNotification(notbody, context);
            Navigator.pop(context);
          });
      }
    else
      {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (c) => Documents(type:'add',body: body,picDetails:picDetails)));
      }

  }

  Widget dropdown(var title, var setState) {
    return Column(
      children: [
        Container(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(left: 7),
                child: Text(title,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: Color.fromRGBO(0, 0, 0, 0.6),
                    )),
              ),
              Container(
                  // height: 45,
                  margin: EdgeInsets.only(top: 2),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border:
                          Border.all(color: Color.fromRGBO(142, 142, 142, 1))),
                  child: heightDropdownButton(title)),
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        )
      ],
    );
  }

  Widget heightDropdownButton(var title) {
    return DropdownButtonHideUnderline(
      child: DropdownButton(

        //isDense: true,
        isExpanded: true,
        //borderRadius: BorderRadius.circular(10.0),
        hint: Text(
          title,
          style: TextStyle(fontSize: 15),
        ),
        value: title == 'sex' ? sex : blood_group,
        style: TextStyle(color: Colors.black),
        items: title == 'sex'
            ? ['Male', 'Female', 'Others'].map(
                (val) {
                  return DropdownMenuItem<String>(
                    value: val,
                    child: Text(
                      val,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  );
                },
              ).toList()
            : ['A+', 'B+', 'AB+', 'O+', 'A-', 'B-', 'AB-', 'O-'].map(
                (val) {
                  return DropdownMenuItem<String>(
                    value: val,
                    child: Text(
                      val,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  );
                },
              ).toList(),
        onChanged:widget.type=='update' && widget.edit?null: title == 'sex'
            ? (sex1) {
                setState(
                  () {
                    // FocusScope.of(context).requestFocus(new FocusNode());
                    print(sex1);
                    sex = sex1.toString();
                  },
                );
              }
            : (blood1) {
                setState(
                  () {
                    // FocusScope.of(context).requestFocus(new FocusNode());
                    print(blood1);
                    blood_group = blood1.toString();
                  },
                );
              },
      ),
    );
  }


  Widget textFields(String labelText, var inputFormatters, var limit,bool mandatory) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
            TextSpan(text: labelText.toString(),
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: Color.fromRGBO(0, 0, 0, 0.6),
          ),
              children: mandatory?[TextSpan(text: ' *',style: TextStyle(color: Colors.red))]:[]
        )),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        TextFormField(
          readOnly: widget.edit==null?false:widget.edit,
          initialValue:widget.type=='update'?labelText=='first_name'?widget.patDetails.first_name:labelText=='mid_name'?widget.patDetails.mid_name:labelText=='last_name'?widget.patDetails.last_name:labelText=='age'?widget.patDetails.age.toString()
             :labelText=='mob_num'?widget.patDetails.mob_num.toString():labelText=='second_mob_num'?widget.patDetails.second_mob_num:labelText=='whatsapp_num'?widget.patDetails.whatsapp_num:labelText=='email'?widget.patDetails.email:labelText=='father_name'?widget.patDetails.father_name:labelText=='mother_name'?widget.patDetails.mother_name
              :labelText=='address'?widget.patDetails.address:labelText=='city'?widget.patDetails.city:labelText=='pincode'?widget.patDetails.pincode:labelText=='referred_by'?widget.patDetails.referred_by:labelText=='allergies'?widget.patDetails.allergies:labelText=='pre_term_days'?widget.patDetails.pre_term_days.toString()
              :labelText=='sec_num_type'?widget.patDetails.sec_num_type:labelText=='significant_history'?widget.patDetails.significant_history:labelText=='office_id'?widget.patDetails.office_id:labelText=='patient_id'?widget.patDetails.patient_id
              :widget.patDetails.additional_notes:null,
          onTap: labelText == 'dob'
              ?widget.type=='update' && widget.edit?null:()async{
                  // Below line stops keyboard from appearing
            DateTime? date = DateTime(1900);
            FocusScope.of(context).requestFocus(new FocusNode());
            date = await showDatePicker(
                context: context,
                initialDate:DateTime.now(),
                firstDate:DateTime(1900),
                lastDate: DateTime(2100));
                  // Show Date Picker Here
                dobController.text=DateFormat('dd/MM/yyyy').format(DateTime.parse(date.toString()));
                dob=dobController.text;
                setState(() {
                  display=false;
                });
                }
              : null,
          maxLength: limit,
          keyboardType: labelText == 'additional_notes' ||
                  labelText == 'significant_history' ||
                  labelText == 'allergies' ||
                  labelText == 'address'
              ? TextInputType.multiline
              : labelText == 'mob_num' ||
                      labelText == 'second_mob_num' ||
                      labelText == 'whatsapp_num' ||
                      labelText == 'pincode' ||
                      labelText == 'age'
                  ? TextInputType.number
                  : TextInputType.text,
          maxLines: labelText == 'address'
              ? 6
              : labelText == 'allergies'
                  ? 7
                  : labelText == 'significant_history'
                      ? 8
                      : labelText == 'additional_notes'
                          ? 5
                          : null,
          style: Theme.of(context).textTheme.headline4,
          inputFormatters: inputFormatters,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onFieldSubmitted:
              labelText == 'medicine name' ? (value) {} : (value) {},
          onChanged:
              //labelText == 'medicine name'?(value){ medNameList.add(value);}:labelText == 'Mg'?(value){MgList.add(value);}:labelText == 'times'?(value){timesList.add(value);}:labelText == 'morning iu'?(value){morIuList.add(value);}:labelText == 'afternoon iu'?(value){noonIuList.add(value);}:labelText == 'evening iu'?(value){evenIuList.add(value);}:labelText == 'Insulin'?(value){insulinInjectionList.add(value);}:
              (value) {},
          decoration: InputDecoration(
            hintText: labelText=='dob'?widget.type=='update' && display?widget.patDetails.dob:dobController.text:null,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 0, horizontal: 15)),
          validator: (value) {
            if (labelText == 'first_name') {
              if (value!.isEmpty) {
                return 'can\'t be empty';
              } else if (value.length < 3) {
                return 'name length shouldn\'t be less than 3 letters';
              } else if (value.length > 15) {
                return 'name length shouldn\'t be more than 45 letters';
              } else {
                return null;
              }
            } else if (labelText == 'mid_name' || labelText == 'last_name') {
              if (value!.length > 15) {
                return 'name length shouldn\'t be more than 45 letters';
              } else {
                return null;
              }
            } else if (labelText == 'mob_num' ||
                labelText == 'whatsapp_num') {
              if (value!.length < 10 || value.length > 10) {
                return 'should contain only 10 digits';
              } else {
                return null;
              }
            }else if (
                labelText == 'second_mob_num') {
              if(value!.isNotEmpty)
                {
                  if (value!.length < 10 || value.length > 10) {
                    return 'should contain only 10 digits';
                  } else {
                    return null;
                  }
                }
              else
                {
                  return null;
                }

            } else if (labelText == 'age') {
              if (value!.isEmpty) {
                return 'can\'t be empty';
              } else if (int.parse(value) <= 0 || int.parse(value) > 120) {
                return "age should be in the range of 1-120";
              } else {
                return null;
              }
            } else if (labelText == 'address') {
              if (value!.isEmpty) {
                return null;
              } else if (value.length < 3) {
                return 'shouldn\'t be less than 3 letters';
              } else if (value.length > 150) {
                return 'shouldn\'t be more than 150 letters';
              } else {
                return null;
              }
            } else if (labelText == 'father_name' ||
                labelText == 'mother_name') {
              if (value!.length > 15) {
                return 'shouldn\'t be more than 40 letters';
              } else {
                return null;
              }
            } else {
              return null;
            }
          },
          onSaved: (value) {
            if (labelText == 'first_name') {
              first_name = value;
            } else if (labelText == 'mid_name') {
              mid_name = value;
            } else if (labelText == 'last_name') {
              last_name = value;
            } else if (labelText == 'age') {
              age = value!;
            } else if (labelText == 'age_group') {
              age_group = value;
            } else if (labelText == 'mob_num') {
              mob_num = value!;
            } else if (labelText == 'second_mob_num') {
              second_mob_num = value!;
            } else if (labelText == 'whatsapp_num') {
              whatsapp_num = value!;
            } else if (labelText == 'email') {
              email = value!;
            } else if (labelText == 'father_name') {
              father_name = value!;
            } else if (labelText == 'mother_name') {
              mother_name = value!;
            } else if (labelText == 'address') {
              address = value!;
            } else if (labelText == 'city') {
              city = value;
            } else if (labelText == 'pincode') {
              pincode = value!;
            } else if (labelText == 'referred_by') {
              referred_by = value!;
            } else if (labelText == 'allergies') {
              allergies = value!;
            } else if (labelText == 'pre_term_days') {
              pre_term_days = value!;
            } else if (labelText == 'sec_num_type') {
              sec_num_type = value!;
            } else if (labelText == 'significant_history') {
              significant_history = value!;
            } else if (labelText == 'office_id') {
              office_id = value!;
            } else if (labelText == 'patient_id') {
              patient_id = value!;
            } else if (labelText == 'additional_notes') {
              additional_notes = value!;
            }
          },
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        )
      ],
    );
  }

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
    return LayoutBuilder(builder: (ctx, constraint) {
      return Container(
        height: widget.type=='add'?MediaQuery.of(context).size.height * 0.8:MediaQuery.of(context).size.height * 0.8,
        margin: EdgeInsets.all(10),
        child: Stack(
          children: [Column(
            children: [
              widget.type=='add'?AddPicture(type: 'profile',fun:addPicFun):AddPicture(type: 'profile',subType:'view',profile_image:widget.patDetails.pat_image.toString(),fun:addPicFun),
              Form(
                  key: _formKey,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: SingleChildScrollView(
                      child: Column(children: [
                        textFields('first_name', null, null,true),
                        textFields('mid_name', null, null,false),
                        textFields('last_name', null, null,false),
                        dropdown('sex', setState), //dropdown
                        textFields(
                            'age',
                            [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9]')),
                            ],
                            3,true),
                        textFields('age_group', null, null,false),
                        textFields('dob', null, null,true),
                        dropdown('blood_group', setState), //dropdown
                        textFields(
                            'mob_num',
                            [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9]')),
                            ],
                            10,true),
                        textFields(
                            'second_mob_num',
                            [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9]')),
                            ],
                            10,false),
                        textFields(
                            'whatsapp_num',
                            [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9]')),
                            ],
                            10,true),
                        textFields('email', null, null,false),
                        textFields('father_name', null, null,false),
                        textFields('mother_name', null, null,false),
                        textFields('address', null, null,false),
                        textFields('city', null, null,false),
                        textFields(
                            'pincode',
                            [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9]')),
                            ],
                            6,false),
                        textFields('referred_by', null, null,false),
                        textFields('allergies', null, null,false),
                        textFields('pre_term_days', null, null,false),
                        textFields('sec_num_type', null, null,false),
                        textFields('significant_history', null, null,false),
                        textFields('office_id', null, null,false),
                        textFields('patient_id', null, null,false),
                        textFields('additional_notes', null, null,false),
                      ]),
                    ),
                  )),
              textButton(),
              noDob?Text('* no date of birth',style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: Colors.red,
              ),):Container()
            ],
          ),
            loading?Center(
                child: CircularProgressIndicator()):Container()

          ]
        ));
    });
  }
}
