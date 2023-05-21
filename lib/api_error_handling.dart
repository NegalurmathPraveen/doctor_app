import 'package:flutter/material.dart';

import 'local_storage_classes/secure_storage.dart';
import 'login/login_screen.dart';
import 'widgets/show_messages/show_snackbar.dart';

class ApiErrorHandling{
  SecureStorage secureStorage=new SecureStorage();
  ShowSnackBar showSnackBar=ShowSnackBar();
  apiErrorHandlerFun(var errorCode,var context)async
  {
    if(errorCode==401)
    {
      showSnackBar.showToast("You are not authenticated as an user!!", context);
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>LoginScreen()));
      // return '$errorCode no access!!';
    }
    else
    {
      print(errorCode);
      showSnackBar.showToast("$errorCode Something went Wrong..!!", context);
      // return '$errorCode error!!';
    }
  }
}