import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../api_error_handling.dart';
import '../../global_variables.dart';
import '../../local_storage_classes/secure_storage.dart';
import '../../models/vaccination_model.dart';
import '../../widgets/show_messages/show_snackbar.dart';

class VaccinationApis{
  SecureStorage secureStorage = SecureStorage();
  ShowSnackBar showSnackBar = ShowSnackBar();
  ApiErrorHandling apiErrorHandling = ApiErrorHandling();

  Future addVaccination(var body, var context) async {
    try {
      var url = Uri.parse(URL + 'addVaccination');
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

  Future getVaccination(var context) async {
    try {
      var visitList = [];
      var url = Uri.parse(URL + 'getVaccination');
      print(url);
      var Response = await http.post(url);
      var response = json.decode(Response.body);
      if (Response.statusCode == 200) {
        print(response);
        if (response['status'] == 'success') {
          visitList = convertListToVaccinationModel(response['vaccination_list']);
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

  convertListToVaccinationModel(List list) {
    var notList = [];
    list.forEach((element) {
      notList.add(
          VaccinationModel(
              id:element['id'],
              due_date:element['due_date'],
              message:element['message'],
              createdAt: element['createdAt'],
              updatedAt: element['updatedAt']
          ));
    });
    return notList;
  }
}