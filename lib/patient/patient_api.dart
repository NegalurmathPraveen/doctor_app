import 'dart:convert';
import 'package:doctor_app/home_screen.dart';
import 'package:doctor_app/models/patient_details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:path/path.dart';

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

  Future submitPatientDetails(var body,var images, var context) async {
    try {
      if(images!=null)
        {
          if(images['profile_image']==null && images['documents']!=null)
            {
              body['pat_image']=null;
             // body['documents']=images['documents'].toString().replaceAll('[', '').replaceAll(']','');
              body['documents']=json.encode(images['documents']);
            }
          else if(images['profile_image']!=null && images['documents']==null)
          {
            body['pat_image']=images['profile_image'];
            body['documents']=null;
          }
          else
            {
              body['pat_image']=images['profile_image'];
              print(body['pat_image']);
              //body['documents']=images['documents'].toString().replaceAll('[', '').replaceAll(']','');
              body['documents']=json.encode(images['documents']);
              print(body['documents']);
            }
        }
     else
       {
         body['pat_image']=null;
         print(body['pat_image']);
         body['documents']=null;
         print(body['documents']);
       }

      var url = Uri.parse(URL + 'submitPatientDetails');
      print(url);
      print(json.encode(body));
      var Response = await http.post(url, body: json.encode(body), headers: {
        'content-Type': 'application/json',
      });
      var response = json.decode(Response.body);
      if (Response.statusCode == 200) {
        if (response['status'] == 'success') {
          print(response['status']);
          patientList=await getAllPatientsList(page, context);
          showSnackBar.showToast('added patient successfully!', context);
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
         // page=response['last_page'];
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

  Future getLastPage(var context) async {
    try {
      var url = Uri.parse(URL + 'getLastPage');
      print(url);
      var Response = await http.post(url);
      var response = json.decode(Response.body);
      if (Response.statusCode == 200) {
        print(response);
        if (response['status'] == 'success') {
           page=response['last_page'];
           //page=434;
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
              pat_image: element['pat_image'],
              documents: element['documents'],
              createdAt: element['createdAt'],
              updatedAt: element['updatedAt']
          ));
    });
    return patList;
  }

  Future updatePatientDetails(var details,var picDetails,var body, var context) async {
    try {
      body['pat_image']=picDetails!=null?picDetails['profile_image'].toString()!='null'?picDetails['profile_image']:details.pat_image:details.pat_image;
      body['documents']=details.documents;
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
          patientList=await getAllPatientsList(page, context);
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

  uploadUpdatedPatProfilePic(var id,var imageUrl)
  {

  }
}