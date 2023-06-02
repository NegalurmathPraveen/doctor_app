import 'package:doctor_app/drawer_widgets/receptionist/receptionist_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddReceptionist extends StatefulWidget {
  var type;
  var details;
  AddReceptionist({required this.type,this.details});

  @override
  State<AddReceptionist> createState() => _AddReceptionistState();
}

class _AddReceptionistState extends State<AddReceptionist> {
  ReceptionistApis receptionistApis=ReceptionistApis();
  var _formKey = GlobalKey<FormState>();
  var name;
  var mobile;
  var whatsapp;
  var email;
  var password;
  var obscure=true;
  var edit=true ;

  @override
  void initState() {
    super.initState();
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
          readOnly:widget.type=='add'?false:edit,
          //enabled: edit,
          initialValue:widget.type=='update'? labelText == 'Name'?widget.details['name']:labelText == 'Mobile'?widget.details['mobile_number']:labelText == 'Whatsapp'?widget.details['whatsapp_number']:labelText == 'Email'?widget.details['email']:null:null,
          keyboardType: labelText == 'Mobile' || labelText == 'Whatsapp'
              ? TextInputType.number
              : TextInputType.text,
          maxLength: limit,
          //maxLines: labelText == 'message' ? 6 : null,
          style: Theme.of(context).textTheme.headline4,
          inputFormatters: inputFormatters,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: labelText == 'Password' ? obscure : false,
          decoration: InputDecoration(
              isDense: false,
              suffix: labelText == 'Password'?IconButton(icon: Icon(Icons.visibility,color: Color.fromRGBO(0, 0, 0, 0.6),),onPressed: (){setState(() {
                obscure=!obscure;
              });},):null,
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              contentPadding:labelText == 'Password'?EdgeInsets.zero:
              EdgeInsets.symmetric(vertical: 10, horizontal: 15)),
          validator: (value) {
            String? email = value;

            final bool emailValid = RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(email!);
            if(labelText=='Email')
            {
              if (!emailValid) {
                return 'Please enter a valid email address';
              }
            }
            else if (labelText == 'Name') {
              if (value!.length > 15) {
                return 'message length shouldn\'t be more than 45 letters';
              } else {
                return null;
              }
            } else if (labelText == 'Mobile' || labelText == 'Whatsapp') {
              if ((value!.length!=0 && value!.length < 10) || value.length > 10) {
                return 'should contain only 10 digits';
              } else {
                return null;
              }
            } else {
              return null;
            }
          },
          onSaved: (value) {
            if (labelText == 'Name') {
              name = value;
            }
            else if (labelText == 'Mobile') {
              mobile = value;
            }
            else if (labelText == 'Whatsapp') {
              whatsapp = value;
            }
            else if (labelText == 'Email') {
              email = value;
            }
            else {
              password = value;
            }
          },
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        )
      ],
    );
  }

  submitDetails()async
  {
    var body={
      "name":name,
      "mobile_number":mobile,
      "whatsapp_number":whatsapp,
      "email":email,
      "password":password,
      "status":'active'
    };
    if(widget.type=='add')
      {
        var res=await receptionistApis.submitReceptionistDetails(body, context);
        print(res);
      }
    else{
      var res=await receptionistApis.updateReceptionistDetails(body, context);
      print(res);
    }
    
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: Theme.of(context).textTheme.headline3,
        ),
        actions: [
          widget.type=='add'?Container():IconButton(onPressed: (){
            setState(() {
              edit=!edit;
            });
          }, icon: Icon(Icons.edit_note_outlined))
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                textFields('Name', null, null),
                textFields(
                    'Mobile',
                    [
                      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                    ],
                    null),
                textFields(
                    'Whatsapp',
                    [
                      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                    ],
                    null),
                textFields('Email', null, null),
                textFields('Password', null, null),
                SizedBox(height: height*0.02,),
                Card(
                  elevation: 10,
                  child: Container(
                    width: double.infinity,
                    height: height * 0.06,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue,
                    ),
                    child: TextButton(
                      onPressed: () {
                        final isValid = _formKey.currentState!.validate();
                        FocusScope.of(context).unfocus();
                        print('entered');
                        if (isValid) {
                          _formKey.currentState!.save();
                          submitDetails();
                        }},
                      child: Text(
                        'Confirm',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
