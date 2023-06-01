import 'package:flutter/material.dart';

const String URL = "http://10.0.2.2:8000/api/";

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
final GlobalKey<FormState> scaffoldKey = GlobalKey<FormState>();

List constList=[];//constant patient list
List patientList = [];
List receptionistList=[];
var imageUrlList=[];
List imageList=[];
