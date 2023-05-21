import 'dart:convert';
import 'package:doctor_app/home_screen.dart';
import 'package:doctor_app/models/patient_details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../api_error_handling.dart';
import '../global_variables.dart';
import '../local_storage_classes/local_storage.dart';
import '../local_storage_classes/secure_storage.dart';
import '../login/login_screen.dart';
import '../widgets/show_messages/show_snackbar.dart';

class PatientApi {
  SecureStorage secureStorage = SecureStorage();
  ShowSnackBar showSnackBar = ShowSnackBar();
  ApiErrorHandling apiErrorHandling = ApiErrorHandling();

  Future submitPatientDetails(var body, var context) async {
    try {
      var url = Uri.parse(URL + 'submitPatientDetails');
      print(url);
      print(body);
      var Response = await http.post(url, body: json.encode(body), headers: {
        'content-Type': 'application/json',
      });
      var response = json.decode(Response.body);
      if (Response.statusCode == 200) {
        if (response['status'] == 'success') {
          print(response['status']);
          showSnackBar.showToast('added patient successfully!', context);
          Navigator.pushAndRemoveUntil(
              context, MaterialPageRoute(builder: (c) => HomeScreen()), (
              Route<dynamic> route) => false);
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

  Future getAllPatientsList(var page,var context) async {
    try {
      var url = Uri.parse(URL + 'getAllPatientsList?page=$page');
      print(url);
      var Response = await http.post(url);
      var response = json.decode(Response.body);
      if (Response.statusCode == 200) {
        print(response);
        if (response['status'] == 'success') {
             patientList = patientList+convertListToPatientModel(response['patient_list']['data']);
          print('length${patientList.length}');
          return patientList;
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


  convertListToPatientModel(List list) {
    var patList = [];
    list.forEach((element) {
      patList.add(
          PatientDetails(
              id:element['id'],
              first_name: element['first_name'],
              mid_name: element['mid_name'],
              last_name: element['last_name'],
              age: element['age'],
              dob: element['dob'],
              mob_num: element['mob_num'],
              sex: element['sex'],
              blood_group: element['blood_group'],
              age_group: element['age_group'],
              address: element['address'],
              city: element['city'],
              email: element['email'],
              father_name: element['father_name'],
              mother_name: element['mother_name'],
              second_mob_num: element['second_mob_num'],
              whatsapp_num: element['whatsapp_num'],
              allergies: element['allergies'],
              additional_notes: element['additional_notes'],
              office_id: element['office_id'],
              patient_id: element['patient_id'],
              pincode: element['pincode'],
              pre_term_days: element['pre_term_days'],
              referred_by: element['referred_by'],
              sec_num_type: element['sec_num_type'],
              significant_history: element['significant_history'],
              createdAt: element['createdAt'],
              updatedAt: element['updatedAt']
          ));
    });
    return patList;
  }

  Future updatePatientDetails(var body, var context) async {
    try {
      var url = Uri.parse(URL + 'editPatientProfile');
      print(url);
      print(json.encode(body));
      var Response = await http.post(url, body: json.encode(body), headers: {
        'content-Type': 'application/json',
      });
      var response = json.decode(Response.body);
      if (Response.statusCode == 200) {
        if (response['status'] == 'success') {
          print(response['status']);
          showSnackBar.showToast('updated patient details successfully!', context);
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

  // Future sendProfilePic(var image)async
  // {
  //   try{
  //     print('yes');
  //     var ret;
  //     var stream = http.ByteStream(DelegatingStream.typed(image.openRead()));
  //     var length = await image.length();
  //
  //     var uri = Uri.parse('${URL}updateprofile');
  //
  //     var request = new http.MultipartRequest("POST", uri);
  //
  //     var multipartFile = new http.MultipartFile('profile', stream, length,
  //       filename: basename(image.path),);
  //     //contentType: new MediaType('image', 'png'));
  //
  //     request.files.add(multipartFile);
  //     print('yes1');
  //     request.fields['patientID']=globalUserId.toString();
  //     print('yes2');
  //     //request.headers.addAll(headers);
  //     var response = await request.send();
  //     print('ressssyy:${response.statusCode}');
  //     response.stream.transform(utf8.decoder).listen((value) {
  //       print(value);
  //       ret=value;
  //     });
  //
  //     if(response.statusCode==200)
  //     {
  //       print('entered 200');
  //       print(response);
  //       print('ret${await ret}');
  //       return await ret;
  //     }
  //     else{
  //       throw 'error';
  //     }
  //   }
  //   catch(e){
  //     print(e);
  //   }
  // }
  //
  // Future getProfilePic(var context)async
  // {
  //   try{
  //     LocalStorage localStorage= LocalStorage(path1:'profileImage.json');
  //     //SecureStorage secureStorage=SecureStorage();
  //     var url2;
  //     String url1='${URL}viewprofile?patientID=$globalUserId';
  //     var url = Uri.parse(url1);
  //     var response=await http.get(url,headers: {
  //       'content-Type' : 'application/x-www-form-urlencoded',
  //       'token': '${globalBtoken}',
  //     });
  //     print(response.body);
  //     if(response.statusCode==200)
  //     {
  //       var x=response.body.toString();
  //       final text = x;
  //
  //       // RegExp exp = new RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
  //       // Iterable<RegExpMatch> matches = exp.allMatches(text);
  //       // matches.forEach((match) {
  //       //   print('url2:${text.substring(match.start, match.end)}');
  //       //    url2=text.substring(match.start, match.end);
  //       // });
  //       url2=response.body;
  //       print('x=$x');
  //       print('url2$url2');
  //       await localStorage.writeData(json.encode(url2.toString()));
  //       var image4=await localStorage.readData();
  //       print('image4:$image4');
  //
  //
  //       return image4;
  //     }
  //     else{
  //       apiErrorHandling.apiErrorHandlerFun(response.statusCode,context);
  //       throw 'error';
  //     }
  //   }
  //   catch(e){
  //     print(e);
  //   }
  // }
}