import 'package:doctor_app/widgets/logo_with_name.dart';
import 'package:flutter/material.dart';
class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    text(icon,text,type)
    {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon),
          // SizedBox(width: width*0.01,),
          Container(
              width: width*0.7,

              child: Text(text,
                style: type=='mob_num'?TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                    fontSize: 18,color:Color.fromRGBO(0, 0, 0, 0.87)):Theme.of(context).textTheme.headline3,textAlign: TextAlign.center,)),
        ],
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text('About Us',style: Theme.of(context).textTheme.headline3,),),
      body: Center(
        child: Container(
          child:Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: height*0.02,),
                Container(
                  height: 288,
                  width: 263,
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      image:DecorationImage(
                          fit: BoxFit.fill,
                          image:  AssetImage('assets/icon/logo.png',)
                      ) ),
                ),
                SizedBox(height: height*0.05,),
                Text('Dr. Arfath Khan',style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                    fontSize: 22,color:Color.fromRGBO(0, 0, 0, 0.87)),textAlign: TextAlign.center,),
                SizedBox(height: height*0.005,),
                Text('Family Physician',style:  TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                    fontSize: 18,color:Color.fromRGBO(0, 0, 0, 0.87)),textAlign: TextAlign.center,),
                SizedBox(height: height*0.03,),
                text(Icons.call,'8050765888, 9050765999','mob_num'),
                SizedBox(height: height*0.01,),
                text(Icons.location_on_outlined,'No. 127, St Johns Church Road, Frazer Town,   Bangalore - 560005','address'),
                // Container(
                //   height: height * 0.35,
                //   width: width,
                //   decoration: BoxDecoration(
                //       color: Colors.black12,
                //       image:DecorationImage(
                //           fit: BoxFit.fill,
                //           image:  AssetImage('assets/images/splash_screen_image.png',)
                //       ) ),
                // ),
              ]
          ),
        ),
      ),
    );
  }
}
