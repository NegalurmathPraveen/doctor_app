import 'dart:convert';
import 'package:doctor_app/models/receptionist_details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../api_error_handling.dart';
import '../../global_variables.dart';
import '../../local_storage_classes/secure_storage.dart';
import '../../widgets/show_messages/show_snackbar.dart';

class ReceptionistApis{
  SecureStorage secureStorage = SecureStorage();
  ShowSnackBar showSnackBar = ShowSnackBar();
  ApiErrorHandling apiErrorHandling = ApiErrorHandling();

  Future submitReceptionistDetails(var body, var context) async {
    try {
      var url = Uri.parse(URL + 'submitReceptionistDetails');
      print(url);
      print(json.encode(body));
      var Response = await http.post(url, body: json.encode(body), headers: {
        'content-Type': 'application/json',
      });
      var response = json.decode(Response.body);
      if (Response.statusCode == 200) {
        if (response['status'] == 'success') {
          print(response['status']);
          showSnackBar.showToast('added receptionist successfully!', context);

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

  Future getAllReceptionistList(var context) async {
    try {
      var url = Uri.parse(URL + 'getAllReceptionistList');
      print(url);
      var Response = await http.post(url);
      var response = json.decode(Response.body);
      if (Response.statusCode == 200) {
        print(response);
        if (response['status'] == 'success') {
          receptionistList = convertListToReceptionistModel(response['receptionist_list']);
          print('length${patientList.length}');
          return receptionistList;
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


  convertListToReceptionistModel(List list) {
    var recList = [];
    list.forEach((element) {
      recList.add(
          ReceptionistDetails(
              id:element['id'],
              name: element['name'],
              email:element['email'],
              password:element['password'],
              status:element['status'],
              createdAt: element['createdAt'],
              updatedAt: element['updatedAt']
          ));
    });
    return recList;
  }

  Future updateReceptionistDetails(var body, var context) async {
    try {
      var url = Uri.parse(URL +'editReceptionistProfile');
      print(url);
      print(json.encode(body));
      var Response = await http.post(url, body: json.encode(body), headers: {
        'content-Type': 'application/json',
      });
      var response = json.decode(Response.body);
      if (Response.statusCode == 200) {
        if (response['status'] == 'success') {
          print(response['status']);
          showSnackBar.showToast('updated status successfully!', context);
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

  // editStatus(var status)async
  // {
  //   try {
  //     var url = Uri.parse(URL + 'editReceptionistProfile');
  //     print(url);
  //     print(json.encode(body));
  //     var Response = await http.post(url, body: json.encode(body), headers: {
  //       'content-Type': 'application/json',
  //     });
  //     var response = json.decode(Response.body);
  //     if (Response.statusCode == 200) {
  //       if (response['status'] == 'success') {
  //         print(response['status']);
  //         showSnackBar.showToast('updated patient details successfully!', context);
  //       }
  //       else {
  //         showSnackBar.showToast('something went wrong!', context);
  //         return false;
  //       }
  //     }
  //     else {
  //       apiErrorHandling.apiErrorHandlerFun(Response.statusCode, context);
  //       throw response;
  //     }
  //   } catch (error) {
  //     print(error);
  //   }
  // }
}