import 'dart:convert';
import 'package:doctor_app/models/notification_details.dart';
import 'package:doctor_app/models/visitation_model.dart';
import 'package:http/http.dart' as http;

import '../../../api_error_handling.dart';
import '../../../global_variables.dart';
import '../../../local_storage_classes/secure_storage.dart';
import '../../../widgets/show_messages/show_snackbar.dart';

class VisitationApis{
  SecureStorage secureStorage = SecureStorage();
  ShowSnackBar showSnackBar = ShowSnackBar();
  ApiErrorHandling apiErrorHandling = ApiErrorHandling();

  Future addNextVisitation(var body, var context) async {
    try {
      var url = Uri.parse(URL + 'addNextVisitation');
      print(url);
      print(json.encode(body));
      var Response = await http.post(url, body: json.encode(body), headers: {
        'content-Type': 'application/json',
      });
      var response = json.decode(Response.body);
      if (Response.statusCode == 200) {
        if (response['status'] == 'success') {
          print(response['status']);
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

  Future getVisitations(var patId,var context) async {
    try {
      var visitList = [];
      var url = Uri.parse(URL + 'getVisitations?patient_id=$patId');
      print(url);
      var Response = await http.post(url);
      var response = json.decode(Response.body);
      if (Response.statusCode == 200) {
        print(response);
        if (response['status'] == 'success') {
          visitList = convertListToVisitationModel(response['visitations_list']);
          return visitList;
        }
        else {
          showSnackBar.showToast('something went wrong!', context);
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

  convertListToVisitationModel(List list) {
    var notList = [];
    list.forEach((element) {
      notList.add(
          VisitationModel(
              patient_id:element['patient_id'],
              visitation_id:element['visitation_id'],
              due_date:element['due_date'],
              message:element['message'],
              createdAt: element['createdAt'],
              updatedAt: element['updatedAt']
          ));
    });
    return notList;
  }
}