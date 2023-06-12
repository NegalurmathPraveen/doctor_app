import 'package:flutter/material.dart';
class LogoWithName extends StatelessWidget {
  const LogoWithName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return LayoutBuilder(builder: (ctx,constraint){
      return Container(
        height: height * 0.6,
        width: width * 0.7,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: height * 0.35,
                width: width,
                decoration: BoxDecoration(
                    color: Colors.black12,
                    image:DecorationImage(
                        fit: BoxFit.fill,
                        image:  AssetImage('assets/icon/logo.png',)
                    ) ),
              ),
              // SizedBox(height:height * 0.05,),
              // Container(
              //   width: width,
              //   child: Text('PARK VIEW CLINIC',style: TextStyle(fontFamily:'Inter',
              //       color: Colors.black,fontSize: 18,fontWeight: FontWeight.w400),
              //       textAlign: TextAlign.center,
              //   ),
              // )
            ]
        ),
      );
    });
  }
}
