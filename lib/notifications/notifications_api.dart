import 'dart:convert';
import 'package:doctor_app/models/notification_details.dart';
import 'package:http/http.dart' as http;

import '../api_error_handling.dart';
import '../global_variables.dart';
import '../local_storage_classes/secure_storage.dart';
import '../widgets/show_messages/show_snackbar.dart';

class NotificationApis{
  SecureStorage secureStorage = SecureStorage();
  ShowSnackBar showSnackBar = ShowSnackBar();
  ApiErrorHandling apiErrorHandling = ApiErrorHandling();

  Future addNotification(var body, var context) async {
    try {
      var url = Uri.parse(URL + 'addNotification');
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

  Future getNotifications(var context) async {
    try {
      var notList = [];
      var url = Uri.parse(URL + 'getNotifications');
      print(url);
      var Response = await http.post(url);
      var response = json.decode(Response.body);
      if (Response.statusCode == 200) {
        print(response);
        if (response['status'] == 'success') {
          notList = convertListToNotificationModel(response['notifications_list']);
          return notList;
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

  convertListToNotificationModel(List list) {
    var notList = [];
    list.forEach((element) {
      notList.add(
          NotificationDetails(
              id:element['id'],
              heading:element['heading'] ,
              content:element['content'] ,
              sub_heading:element['sub_heading'] ,
              createdAt: element['createdAt'],
              updatedAt: element['updatedAt']
          ));
    });
    return notList;
  }
}