
import 'dart:convert';

import 'package:doctor_app/api_error_handling.dart';
import 'package:doctor_app/local_storage_classes/secure_storage.dart';
import 'package:doctor_app/models/doctor_details.dart';

import '/widgets/show_messages/show_snackbar.dart';

import '../global_variables.dart';
import 'package:http/http.dart' as http;
class LoginApi{
  SecureStorage secureStorage=SecureStorage();
ShowSnackBar showSnackBar=ShowSnackBar();
ApiErrorHandling apiErrorHandling=ApiErrorHandling();
  Future login(var email,var password,var context)async{
    try{
      var url=Uri.parse(URL+'login?email=$email&password=$password');
      print(url);
      var Response=await http.post(url);
      var response=json.decode(Response.body);
      if(Response.statusCode==200)
      {
        print(response);
        if(response['status']=='success')
          {
            showSnackBar.showToast('logged in successfully',context);
            doctorDetails=response['details'];
            secureStorage.writeSecureData('doctorDetails',json.encode(response['details']));
            DoctorDetails(
              id: response['details']['id'],
              name: response['details']['name'],
              mobile_number:response['details']['name'],
              whatsapp_number:response['details']['name'],
              email:response['details']['email'],
              password: response['details']['password'],
            );
            return true;
          }
        else
          {
            showSnackBar.showToast('you are not an authorised user',context);
            return false;
          }

      }
      else{
        apiErrorHandling.apiErrorHandlerFun(Response.statusCode,context);
        throw response;
      }
    }catch(error)
    {
      print(error);
    }
  }
}