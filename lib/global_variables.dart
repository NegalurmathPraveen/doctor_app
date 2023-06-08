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

  List ageList=['Birth','6 Weeks','10 Weeks','14 Weeks','6 Months','7 Months','6-9 Months','9 Months','12-15 Months','15 Months','16-18 Months','18-19 Months','4-6 Years','9-15 Years(Girls)','10-12 Years','2nd, 3rd, 4th, 5thYear'];

  List vacList=['BCG,Hep B1,OPV','DTwP/ DTaP1, Hib-1, IPV-1, Hep B2, PCV1, Rota-1','DTwP/ DTaP2, Hib-2, IPV-2, Hep B3, PCV2, Rota-2','DTwP/ DTaP3, Hib-3, IPV-3, Hep B4, PCV3, Rota-3*',
    'Influenza-1','Influenza-2','Typhoid Conjugate Vaccine','MMR 1 (Mumps, Measles, Rubella)','PCV Booster','MMR 2, Varicella','DTwP/DTaP, Hib, IPV','Hepatitis A-2**, Varicella 2','DTwP/DTaP, Hib, IPV. MMR3',
    'HPV( 2 doses)','Tdap/ Td','Annual Influenza Vaccine'];

