import 'dart:convert';
import 'package:http/http.dart' as http;

import 'api_error_handling.dart';
import 'local_storage_classes/secure_storage.dart';
import 'widgets/show_messages/show_snackbar.dart';

class WhatsappMsg{
  SecureStorage secureStorage = SecureStorage();
  ShowSnackBar showSnackBar = ShowSnackBar();
  ApiErrorHandling apiErrorHandling = ApiErrorHandling();


  Future whatsappMsg(var details,var context) async {
    try {
      var url = Uri.parse('http://private.itswhatsapp.com/wapp/api/send?apikey=2bed3bbbdb7941e5b7b41ce5cf0c1ff4&mobile=${details['mobile_nos'].toString()}&msg=you have your followup scheduled tomorrow');
      print(url);
      var Response = await http.post(url);
      var response = json.decode(Response.body);
      print('res:${response}');
      if (Response.statusCode == 200) {
        if (response['status'] == 'success') {
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