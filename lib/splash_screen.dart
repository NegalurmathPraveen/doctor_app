import 'dart:convert';

import 'package:doctor_app/drawer_widgets/vaccination/vaccination_api.dart';
import 'package:doctor_app/home_screen.dart';
import 'package:doctor_app/patient/patient_api.dart';

import 'drawer_widgets/receptionist/receptionist_api.dart';
import 'local_storage_classes/secure_storage.dart';
import 'package:flutter/material.dart';

import 'global_variables.dart';
import 'login/login_screen.dart';
import 'widgets/logo_with_name.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  ReceptionistApis receptionistApis=ReceptionistApis();
  SecureStorage secureStorage=SecureStorage();
  PatientApi patientApi=PatientApi();
  @override
  void initState() {

    checkUserCreds();
    setLastPage();
    super.initState();
  }
  setLastPage()async
  {
    await patientApi.getLastPage(context);
  }
  checkUserCreds()async{
     await Future.delayed(Duration(seconds: 3));
     //await secureStorage.deleteSecureData('doctorDetails');
     var res=await secureStorage.readSecureData('doctorDetails');
     print(res);

    if(res==null)
    {
      print('user doesn\'t exist');
      Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (c) => LoginScreen()), (Route<dynamic> route) => false);
    }
    else
      {
        doctorDetails=json.decode(res);
        role=json.decode(res)['role'];
        if(role=='receptionist')
          {
            var body={
              "email":doctorDetails['email'],
              "password":doctorDetails['password']
            };
            var status=await receptionistApis.checkStatus(body,context);
            if(!status)
              {
                Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (c) => LoginScreen()), (Route<dynamic> route) => false);
              }
            else
              {
                Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (c) => HomeScreen()), (Route<dynamic> route) => false);
              }
          }
        else
          {
            Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (c) => HomeScreen()), (Route<dynamic> route) => false);
          }
      }
  }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx,constraint){
      return Scaffold(
        body: Center(child: LogoWithName()),
      );
    }
    );
  }
}
