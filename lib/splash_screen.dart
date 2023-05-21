import 'dart:convert';

import 'package:doctor_app/home_screen.dart';

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
  SecureStorage secureStorage=SecureStorage();
  @override
  void initState() {

    checkUserCreds();
    super.initState();
  }

  checkUserCreds()async{
     await Future.delayed(Duration(seconds: 3));
   // await secureStorage.deleteSecureData('doctorDetails');
     var res=await secureStorage.readSecureData('doctorDetails');

    if(res==null)
    {
      print('user doesn\'t exist');
      Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (c) => LoginScreen()), (Route<dynamic> route) => false);
    }
    else
      {
        doctorDetails=json.decode(res);
        Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (c) => HomeScreen()), (Route<dynamic> route) => false);
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
