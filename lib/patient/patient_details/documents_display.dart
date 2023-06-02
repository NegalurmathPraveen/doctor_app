import 'dart:convert';

import 'package:flutter/material.dart';

class DocumentsDisplay extends StatefulWidget {
  var docs;
  DocumentsDisplay({required this.docs});

  @override
  State<DocumentsDisplay> createState() => _DocumentsDisplayState();
}

class _DocumentsDisplayState extends State<DocumentsDisplay> {
  var imageList=[];
  @override
  void initState() {
    imageList = json.decode(widget.docs).cast<String>().toList();
    print(imageList);
    super.initState();
  }

  buildImage(var image)
  {
    return Container(
      padding: EdgeInsets.all(8),
      width:MediaQuery.of(context).size.width*0.25,
      child: Image.file(
        image,
        fit: BoxFit.cover,
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    return Container(
      height:height*0.4,
      child: GridView.builder(
          gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemCount:imageList.length,
          itemBuilder:(context,index){
            final image=imageList[index];
            return buildImage(image);
          }),
    );
  }
}
