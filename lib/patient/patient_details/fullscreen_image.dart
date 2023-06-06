import 'package:flutter/material.dart';
class FullScreenImage extends StatefulWidget {
  var image;
  FullScreenImage({required this.image});

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text('Image',style: Theme.of(context).textTheme.headline3,),),
      body:Image.network(
        widget.image,
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      ),
    );
  }
}
