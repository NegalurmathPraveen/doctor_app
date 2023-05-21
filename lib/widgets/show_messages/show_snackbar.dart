import 'package:flutter/material.dart';

class ShowSnackBar{

  void showToast(message,context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message,textAlign: TextAlign.center,),
    ));
  }

}