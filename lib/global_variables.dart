import 'package:flutter/material.dart';

const String URL = "http://laconicpharma.com/doctor_app_apis-master/public/api/";

final int patientId=0;
bool newUser=true;
String mobileNumber='';
String screenStage = 'false';

//appbar height
var appBarHeight;

//userId and Token details

var doctorDetails;
var page=1;
var globalBtoken;
//var Btoken;

var fileNotFound;
var writeCount=0;
var directory;

//scaffold key
GlobalKey<FormState> scaffoldKey = GlobalKey<FormState>();

List constList=[];//constant patient list
List patientList = [];
List receptionistList=[];
var imageUrlList=[];
List imageList=[];
