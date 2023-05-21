import 'package:flutter/material.dart';
class WarningDialog extends StatefulWidget {
  String textContent;
  WarningDialog({required this.textContent});

  @override
  State<WarningDialog> createState() => _WarningDialogState();
}

class _WarningDialogState extends State<WarningDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
      titleTextStyle: Theme.of(context).textTheme.headline2,
      contentTextStyle:Theme.of(context).textTheme.headline3 ,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "Submission Failed",
            style:
            TextStyle(fontSize: MediaQuery
                .of(context)
                .size
                .width / 20),
          ),
          Icon(
            Icons.warning,
            size: 25,
            color: Colors.redAccent.withOpacity(0.8),
          ),
        ],
      ),
      content: new Text(widget.textContent,textAlign: TextAlign.center,),
      actions: <Widget>[
        new TextButton(
          child: new Text(
            "Close",
            style: TextStyle(fontSize: 18, color: Colors.blue),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}