import 'dart:io';

import 'package:dio/dio.dart';
import 'package:doctor_app/patient/add_patient/files_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import 'add_picture.dart';
class DocumentsUpload extends StatefulWidget {
  const DocumentsUpload({Key? key}) : super(key: key);

  @override
  State<DocumentsUpload> createState() => _DocumentsUploadState();
}

class _DocumentsUploadState extends State<DocumentsUpload> {
   Dio dio=Dio();
   List<Widget> gridList=[];
   var execute=false;
   var files;
   var openedFiles;
   var newFile;


   void openFile(var filee)
   {
     print('running');
     OpenFile.open(filee.path!);
   }

   saveFilePermanently(var file)async
   {
      final appStorage=await getApplicationDocumentsDirectory();
      final newFile=File('${appStorage.path}/${file.name}');

      return File(file.path!).copy(newFile.path);
   }

   Future uploadPdf()async {
     FilePickerResult? result=await FilePicker.platform.pickFiles(allowMultiple: true,allowedExtensions: ['pdf','jpeg','jpg'],type:FileType.custom);
     if(result!=null){
       final file=result.files.first;
         newFile=await saveFilePermanently(file);
         files=result.files;
       setState(() {
         execute=true;
       });
        //openFile(result.files);

       // FormData data=FormData.fromMap({
       //   'x-api-key':'apiKey',
       //   'file':await MultipartFile.fromFile(filePath,filename:fileName)
       // });
       //
       // var response = dio.post("",data:data,onSendProgress:(int sent,int total){
       //   print('$sent $total');
       // });
       // print(response.toString());
     }else{
       print('result is null');
     }
   }

  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;

    return Container(
      height:height*0.67,
      width: width*0.9,
      child:Column(
        children: [
          // Container(
          //   width:double.infinity,
          //     height: height*0.05,
          //     decoration: BoxDecoration(color: Colors.blue,borderRadius: BorderRadius.circular(5)),
          //     child: TextButton(onPressed: (){ uploadPdf();},child: Text('upload',style:TextStyle(
          //         color: Colors.white,
          //         fontSize: 18,
          //         fontWeight: FontWeight.bold),
          //     ),),),
          // execute?FilesPage(files: files, onOpenedFile:openFile):Container(),
          AddPicture(type:'docs',),
        ],
      )
    );
  }
}

