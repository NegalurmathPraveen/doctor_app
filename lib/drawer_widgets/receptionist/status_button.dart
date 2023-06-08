import 'package:flutter/material.dart';

import 'receptionist_api.dart';
class StatusButton extends StatefulWidget {
  var details;
  var status;
  StatusButton({required this.details,required this.status});

  @override
  State<StatusButton> createState() => _StatusButtonState();
}

class _StatusButtonState extends State<StatusButton> {
  ReceptionistApis receptionistApis=ReceptionistApis();
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
    return TextButton(onPressed:()async{
      setState(() {
        status=!status;
      });
     var body={
      "email":widget.details.email,
      "password":widget.details.password,
      "status":status.toString()
      };
      var res=await receptionistApis.updateReceptionistDetails(body, context);
    },child: Text(status?'active':'inactive',));
  }
}
