import 'package:flutter/material.dart';
class StatusButton extends StatefulWidget {
  var status;
  StatusButton({required this.status});

  @override
  State<StatusButton> createState() => _StatusButtonState();
}

class _StatusButtonState extends State<StatusButton> {
  var status=false;

  @override
  void initState() {
    if(widget.status=='active')
      {
        status=true;
      }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed:(){
      setState(() {
        status=!status;
      });
    },child: Text(status?'active':'inactive',));
  }
}
