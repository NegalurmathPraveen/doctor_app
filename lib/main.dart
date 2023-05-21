import '/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doctor App',
      theme: ThemeData(appBarTheme: AppBarTheme(backgroundColor:Colors.white,iconTheme:IconThemeData(color: Color.fromRGBO(0, 0, 0, 1)),toolbarHeight:70),
        textTheme:TextTheme(
            headline1: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
              fontSize: 23,color:Color.fromRGBO(0, 0, 0, 0.6),
            ),
            headline2: TextStyle(
                color:Color.fromRGBO(0, 0, 0, 1),
                fontWeight: FontWeight.w200,
                fontFamily: 'Inter',
                fontSize: 15),

            headline3: TextStyle(
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
                fontSize: 19,color:Color.fromRGBO(0, 0, 0, 0.87)),

          headline4: TextStyle(
              fontWeight: FontWeight.w400,
              fontFamily: 'Inter',
              fontSize: 15,color:Colors.black),

          headline6:TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
              fontSize: 25,color:Colors.black),
        ),
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}
