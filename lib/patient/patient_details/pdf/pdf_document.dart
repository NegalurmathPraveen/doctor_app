
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
// import 'package:open_document/open_document.dart';
 import 'package:open_file/open_file.dart';
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


  Future<File> createHelloWorld(var patDetails) async{
    var data = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
    var myFont = Font.ttf(data);
    var myStyle = pw.TextStyle(font: myFont);
    final pdf = pw.Document();
    final image = (await rootBundle.load("assets/icon/icon.jpeg"))
        .buffer
        .asUint8List();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (Context context) {
          return pw.Center(
            child: pw.Text('Hello World', style: myStyle),
          ); // Center
        },
      ),
    );
    return savePdfFile('invoice',pdf);
  }
 Future<File> savePdfFile(String fileName,Document pdf) async {
   final bytes=await pdf.save();
   final dir=await getApplicationDocumentsDirectory();
   final file=File('${dir.path}/$fileName.pdf');
   await file.writeAsBytes(bytes);
   return file;
 }

 Future openFile(File file)async{
   final url=file.path;
   await OpenFile.open(url);
 }

}
