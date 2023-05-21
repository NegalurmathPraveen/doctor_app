import 'dart:convert';
import 'package:http/http.dart' as http;

import 'api_error_handling.dart';
import 'global_variables.dart';
import 'local_storage_classes/secure_storage.dart';
import 'widgets/show_messages/show_snackbar.dart';

class TwoFactorApis{
  SecureStorage secureStorage = SecureStorage();
  ShowSnackBar showSnackBar = ShowSnackBar();
  ApiErrorHandling apiErrorHandling = ApiErrorHandling();


  Future trans_sms_api(var details,var context) async {
    try {
      var url = Uri.parse('https://2factor.in/API/R1/');
      print(url);
      var body={
        "module":"TRANS_SMS",
        "apikey":"b8c9ee74-5294-11ec-b710-0200cd936042",
        "to":details['mobile_nos'].toString(),
        "from":"fedcba",
        "scheduletime":details['schedule_time'].toString(),
        "templatename":"visitation",
        "var1":details['name'].toString(),
        "var2":details['date'].toString()
      };
      print(json.encode(body));
      var Response = await http.post(url, body: body, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      });
      var response = json.decode(Response.body);
      print('res:${response}');
      if (Response.statusCode == 200) {
        if (response['Status'] == 'Success') {
          showSnackBar.showToast('message sent!', context);
          return true;
        }
        else {
          return false;
        }
      }
      else {
        apiErrorHandling.apiErrorHandlerFun(Response.statusCode, context);
        throw response;
      }
    } catch (error) {
      print(error);
    }
  }
}