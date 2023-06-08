
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
// import 'package:open_document/open_document.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';


class PdfDocument {

 textFun(var heading,var description,var textStyle)
{
  return pw.Column(
    children: [
      pw.Text(description==null?'$heading : empty':'$heading : $description',
          style: pw.TextStyle(
          color: PdfColor.fromHex('#000000'),
          font: textStyle,
           fontWeight: pw.FontWeight.normal,
          fontStyle: pw.FontStyle.normal,
          fontSize: 13)),
      pw.SizedBox(
        height: 5
      )
    ]
  );
}

 patDetailsTable(patDetails)
 {
   List list=[
     {
       "title":"Patient Name:",
       "value":patDetails.first_name,
     },
     {
       "title":"Date of Birth:",
       "value":patDetails.dob.toString()=='null'?'empty':patDetails.dob,
     },
     {
       "title":"Phone Number:",
       "value":patDetails.mob_num,
     },
     {
       "title":"WhatsApp Number:",
       "value":patDetails.whatsapp_num,
     },
   ];
   return pw.Table.fromTextArray(
       headers:['',''],
       data:list.map((item) => [
     item['title'],
     item['value']
   ]).toList() );
 }
 buildTable(List list,myFont)
 {
   final headers=['Age','Name of Vaccine','Expected Date','Vaccination Given','Comment if any'];
   return pw.Table.fromTextArray(
       cellStyle: pw.TextStyle(
           color: PdfColor.fromHex('#000000'),
           font: myFont,
           fontWeight: pw.FontWeight.normal,
           fontStyle: pw.FontStyle.normal,
           fontSize:11) ,
     headers: headers,
      data: list.map((item){
        return [
          item.age,
          item.name,
          item.date,
          item.vaccine,
          item.comment
        ];
      }).toList()
   );
 }
  Future<File> createHelloWorld(patDetails,list) async{
    var data = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
    var myFont = Font.ttf(data);
    var myStyle = pw.TextStyle(font: myFont);
    final pdf = pw.Document();
    final image = (await rootBundle.load("assets/icon/pdfIcon.png"))
        .buffer
        .asUint8List();
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (Context context) {
          return [pw.Column(
            children: [
              pw.Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  pw.Container(
                      height: 116,
                      width: 350,
                    child:patDetailsTable(patDetails)
                  ),
                 pw.Container(
                        height: 106,
                        width: 117,
                        child: pw.Image(pw.MemoryImage(image), fit: pw.BoxFit.cover),
                      ),
                ]
              ),
              pw.SizedBox(height: 10),
              buildTable(list,myFont),
              pw.SizedBox(height: 30),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.RichText(
                    text: pw.TextSpan(
                      text: 'Contact No:  ',
                      style: pw.TextStyle(
                          color: PdfColor.fromHex('#000000'),
                          font: myFont,
                          fontWeight: pw.FontWeight.bold,
                          fontStyle: pw.FontStyle.normal,
                          fontSize: 13),
                      children:<TextSpan>[
                        pw.TextSpan(
                            text: '8050765888 / 9050765999', style:pw.TextStyle(
                            color: PdfColor.fromHex('#000000'),
                            font: myFont,
                            fontWeight: pw.FontWeight.normal,
                            fontStyle: pw.FontStyle.normal,
                            fontSize: 11)),
                      ],
                    ),
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Dr. Arfath Ahmed Khan',style:pw.TextStyle(
                          color: PdfColor.fromHex('#000000'),
                          font: myFont,
                          fontWeight: pw.FontWeight.bold,
                          fontStyle: pw.FontStyle.normal,
                          fontSize: 13)),
                      pw.Text('Family Physician',style: pw.TextStyle(
                          color: PdfColor.fromHex('#000000'),
                          font: myFont,
                          fontWeight: pw.FontWeight.normal,
                          fontStyle: pw.FontStyle.normal,
                          fontSize: 12)),
                    ]
                  )
                ]
              )
            ]
          )] ;// Center
        },
      ),
    );
    return savePdfFile('vaccination:${patDetails.first_name}',pdf);
  }
 Future<File> savePdfFile(String fileName,Document pdf) async {
   final bytes=await pdf.save();
   final dir=await getApplicationDocumentsDirectory();
   final file=File('${dir.absolute.path}/$fileName.pdf');
   await file.writeAsBytes(bytes);
   return file;
 }

 Future openFile(File file)async{
   print(file.path);
   await OpenFile.open(file.path);
 }

}
