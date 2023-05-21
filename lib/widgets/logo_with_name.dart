import 'package:flutter/material.dart';
class LogoWithName extends StatelessWidget {
  const LogoWithName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return LayoutBuilder(builder: (ctx,constraint){
      return Container(
        color: Colors.white10,
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
                        image:  AssetImage('assets/images/splash_screen_image.png',)
                    ) ),
              ),
              SizedBox(height:height * 0.02,),
              Container(
                width: width,
                padding: EdgeInsets.symmetric(vertical: 15),
                color: Colors.blue,
                child: Text('PARK VIEW CLINIC',style: TextStyle(fontFamily:'Inter',
                    color: Colors.black,fontSize: 25,fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                ),
              )
            ]
        ),
      );
    });
  }
}
