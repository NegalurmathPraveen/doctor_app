import 'package:flutter/material.dart';
class DocumentsUpload extends StatefulWidget {
  const DocumentsUpload({Key? key}) : super(key: key);

  @override
  State<DocumentsUpload> createState() => _DocumentsUploadState();
}

class _DocumentsUploadState extends State<DocumentsUpload> {

  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    List<Widget> gridList=[
      InkWell(
      onTap: (){},
      child: Container(
        height:height*0.3,
        width:width*0.4,
        child:Center(child: Icon(Icons.add_circle_outline_rounded)),),
    )];
    return Container(
      height:height*0.7,
      width: width*0.4,
      child: GridView.count(crossAxisCount: 2,
      children: gridList.map((e) => e).toList(),),
    );
  }
}
