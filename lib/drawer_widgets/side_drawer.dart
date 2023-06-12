import 'package:doctor_app/drawer_widgets/profile/profile_page.dart';
import 'package:doctor_app/global_variables.dart';
import 'package:doctor_app/login/login_screen.dart';
import 'package:flutter/material.dart';

import '../local_storage_classes/secure_storage.dart';
import 'about_us/about_us_page.dart';
import 'receptionist/receptionist_page.dart';
import 'vaccination/vaccination_page.dart';

class SideDrawer extends StatefulWidget {
  var fun;
  SideDrawer({required this.fun});
  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  SecureStorage secureStorage=SecureStorage();

  List drawerList=['Receptionist','Vaccination Follow up','About Us','Logout'];

  List icons=[Icon(Icons.group_outlined,color: Color.fromRGBO(2, 113, 253, 1),),Icon(Icons.vaccines,color: Color.fromRGBO(2, 113, 253, 1)),Icon(Icons.person_pin_outlined,color: Color.fromRGBO(2, 113, 253, 1)),Icon(Icons.logout_rounded,color: Colors.red,)];

  var index=0;

  @override
  void initState() {
    if(role=='receptionist')
      {
        setState(() {
          drawerList.removeAt(0);
          icons.removeAt(0);
        });
      }
    super.initState();
  }


  Widget drawerItem(var item,BuildContext context)
  {
    if(index>3)
    {
      index=0;
    }
    return Row(
      children: [
        icons[index++],
        SizedBox(width: MediaQuery.of(context).size.width*0.03,),
        TextButton(onPressed: ()async{
          //onPressed(index);
          //Navigator.pop(context);
          if(item=='Receptionist')
          {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (c) => ReceptionistPage()));
          }
          else if(item=='Vaccination Follow up')
          {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (c) => VaccinationPage()));
          }
          else if(item=='About Us')
          {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (c) => AboutUs()));
          }
          else if(item=='Settings')
          {

          }
          else if(item=='Logout')
          {
            await secureStorage.deleteSecureData('doctorDetails').then((value) => Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (c) => LoginScreen()), (Route<dynamic> route) => false));

          }
        },
            child:Text(item,style: Theme.of(context).textTheme.headline3,textAlign: TextAlign.center,))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var width=MediaQuery.of(context).size.width;
    var height=MediaQuery.of(context).size.height;
    return Container(
      width: MediaQuery.of(context).size.width*0.8,
      child: Drawer(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: ListTile(
              onTap: (){
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (c) => ProfilePage()));
              },
              leading:  Container(
              width:width*0.12,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black12,
                  image:DecorationImage(
                      fit: BoxFit.cover,
                      image:  AssetImage('assets/images/Image.png',)
                  ) ),
            ),
              title: Text(doctorDetails['name'].toString(),style:Theme.of(context).textTheme.headline3,),
            ),
            centerTitle: false,
            //titleSpacing: MediaQuery.of(context).size.width*0.12,
          ),
          body: Container(
            margin: EdgeInsets.all(30),
            child: Column(
                children:drawerList.map((item) => drawerItem(item,context)).toList()
            ),
          ),
        ),
      ),
    );
  }
}