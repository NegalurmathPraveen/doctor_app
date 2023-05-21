// import 'package:country_code_picker/country_code_picker.dart';
// ignore_for_file: deprecated_member_use
import 'dart:convert';
//import 'dart:io';
import 'dart:async';
import 'package:doctor_app/login/login_api.dart';
import 'package:doctor_app/widgets/logo_with_name.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../home_screen.dart';
import '../local_storage_classes/secure_storage.dart';
import '../widgets/warning_dialog.dart';
//import 'signupScreen.dart';

class LoginScreen extends StatefulWidget {
  //const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginApi loginApi=LoginApi();

  var formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController email = TextEditingController();
  SecureStorage secureStorage=new SecureStorage();
  FocusNode fNameFocus = FocusNode();
  //String? mobileNumber;
  String phoneText='';
  var phoneNumber;
  bool isValid = false;
  String name='';
  // var firstName;

  get Fluttertoast => null;

  set counterDisbled(bool counterDisbled) {}

  set buttonDisabled(bool buttonDisabled) {}

  phoneVerificationPopUp() {
    // ignore: unused_element
    Future<void> validate(StateSetter updateState) async {
      print("in validate : ${_passwordController.text.length}");
      if (_passwordController.text.length == 10) {
        updateState(() {
          isValid = true;
        });
      }
    }
  }

  void showToast(message, Color color) {
    // ignore: non_constant_identifier_names
    var Toast;
    // ignore: non_constant_identifier_names
    var ToastGravity;
    // Fluttertoast.showToast(
    //   msg: message,
    //   //toastLength: message.LENGTH_LONG,
    //   // gravity: ToastGravity.BOTTOM,
    //   //timeInSecForIos: 2,
    //   //
    //   //
    // );
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));

  }

  void _showDialog(String textContent) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WarningDialog(textContent:textContent);
      },
    );
  }

topText(var text)
{
  return  Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      alignment: Alignment.centerLeft,
      child: Text(text,textAlign: TextAlign.start,style: Theme.of(context).textTheme.headline2,));
}
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _passwordController.dispose();
    email.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return LayoutBuilder(builder:(ctx,constraint){
      return Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  LogoWithName(),
                  Text(
                    "Log in",
                    style:Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                  topText('Email'),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (name){
                        String? email = name;

                        final bool emailValid =
                        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(email!);
                        if(!emailValid)
                          {
                            return 'Please enter a valid email address';
                          }
                       else if(name!.isEmpty)
                        {
                          return 'Please enter your email';
                          // print('name:$name');
                          // print('phoneText:$phoneText');
                          //_showDialog('Name field can not be empty or name should not have more than two white spaces');
                          //_showDialog('Please enter your name!');
                        }
                        else if(name.length<3)
                        {
                          return 'Please ensure name has atleast 3 letters';
                          //_showDialog('Please ensure that your name shouldn\'t contains less than three letters or more than 30 letters');
                        }
                        else if(name.length>30)
                        {
                          return 'Please ensure name has atmost 30 letters';
                        }
                      },
                      onSaved: (value){
                        name=value!;
                        print('text:$name');
                      },
                      autofocus: true,
                      //cursorColor: Colors.black12,
                      style: Theme.of(context).textTheme.headline3,
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        //errorText: _errorText,
                          contentPadding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                          hintText: "Enter your email",
                          prefix: Padding(
                            padding: EdgeInsets.all(4),
                          ),
                          //border: InputBorder.none
                          border: OutlineInputBorder(borderSide: BorderSide(width: 1))
                      ),
                      onChanged: (text){
                        name=text;
                      },
                      keyboardType: TextInputType.text,
                      controller: email,
                    ),
                  ),
                topText('Password'),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value){
                        if (value!.isEmpty) {
                          return 'Please enter your password!!';
                        }
                        else
                        {
                          return null;
                        }
                      },
                      //textAlignVertical: TextAlignVertical.center,
                      style: Theme.of(context).textTheme.headline3,
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        // errorBorder: new OutlineInputBorder(
                        //   borderSide: new BorderSide(color: Colors.black38, width: 1.0),
                        // ),
                        // focusedErrorBorder: new OutlineInputBorder(
                        //   borderSide: new BorderSide(color: Colors.red, width: 1.0),
                        // ),
                          contentPadding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                          //errorText: _errorText,
                          hintText: "Enter your Password",
                          //border: InputBorder.none
                          border: OutlineInputBorder(borderSide: BorderSide(width: 1))
                      ),
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      onChanged: (text){setState(() {
                      });},
                      maxLength: 10,
                      controller: _passwordController,
                    ),
                  ),
                  Container(
                    height:MediaQuery.of(context).size.height * 0.06 ,
                    //padding: EdgeInsets.symmetric(vertical: 1,horizontal: 60),
                    //alignment: Alignment.bottomCenter,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(1, 127, 251, 1),
                        borderRadius: BorderRadius.circular(100)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 1,horizontal: 60),
                      child: TextButton(
                        // height: 75,
                        //minWidth: 1000,

                        onPressed: ()async {
                          final isValid = formKey.currentState!.validate();
                          FocusScope.of(context).unfocus();
                          if (isValid) {
                            formKey.currentState!.save();

                            loginApi.login(email.text,_passwordController.text,context).then((value){
                              print('value:$value');
                              if(value)
                                {
                                  Navigator.of(context).push(MaterialPageRoute(
                                  builder: (c) =>HomeScreen()));
                                }
                            }
                            );}
                        },

                        child: Text(
                          'SIGN IN',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height*0.02,)
                ],
              ),
            ),
          ),
        ),
      );
    });

  }
}