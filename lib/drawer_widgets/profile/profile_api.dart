import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../api_error_handling.dart';
import '../../global_variables.dart';
import '../../local_storage_classes/secure_storage.dart';
import '../../models/doctor_details.dart';
import '../../widgets/show_messages/show_snackbar.dart';

class ProfileApi{
  SecureStorage secureStorage=SecureStorage();
  ShowSnackBar showSnackBar=ShowSnackBar();
  ApiErrorHandling apiErrorHandling=ApiErrorHandling();
  Future editDocProfile(var body,var context)async{
    try{
      var url=Uri.parse(URL+'editDocProfile');
      print(url);
      print(json.encode(body));
      var Response=await http.post(url,body: json.encode(body),headers: {
        'content-Type' : 'application/json',
      });
      var response=json.decode(Response.body);
      if(Response.statusCode==200)
      {
        print(response);
        if(response['status']=='success')
        {
          showSnackBar.showToast('updated profile successfully',context);
          await secureStorage.writeSecureData('doctorDetails',json.encode(response['details']));
          var det=await secureStorage.readSecureData('doctorDetails');
          doctorDetails=json.decode(det);
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