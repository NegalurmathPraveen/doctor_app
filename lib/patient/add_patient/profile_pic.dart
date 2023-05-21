import 'dart:io';

import 'package:doctor_app/patient/patient_api.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' as Img;

import '../../local_storage_classes/local_storage.dart';

class ProfilePic extends StatefulWidget {
  var firstName;
  var lastName;
  ProfilePic({required this.firstName,required this.lastName});

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  PatientApi patientApi=PatientApi();
  LocalStorage localStorage= LocalStorage(path1:'profileImage.json');
  var imageFile;
  var image1;
  var imageFile2;
  var image3;
  var image4;
  var imageLoading=true;

  void showBottomDialog(BuildContext context) {
    showGeneralDialog(
      barrierLabel: "showGeneralDialog",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 400),
      context: context,
      pageBuilder: (context, _, __) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: _buildDialogContent(context),
        );
      },
      transitionBuilder: (_, animation1, __, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0, 1),
            end: const Offset(0, 0),
          ).animate(animation1),
          child: child,
        );
      },
    );
  }
  Widget item(var icon, var text, var context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 25,
          child: IconButton(icon: icon, onPressed: () {
            if (text == 'Camera') {
              getFromCamera();
              Navigator.pop(context);
            }
            else {
              getFromGallery();
              Navigator.pop(context);
            }
          },),
        ),
        SizedBox(height: MediaQuery
            .of(context)
            .size
            .height * 0.01,),
        Text(text, style: Theme
            .of(context)
            .textTheme
            .headline3,),
      ],
    );
  }

  Widget _buildDialogContent(var context) {
    return IntrinsicHeight(
      child: Container(
          width: double.maxFinite,
          clipBehavior: Clip.antiAlias,
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Material(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: MediaQuery
                  .of(context)
                  .size
                  .height * 0.015,),
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.17,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  item(Icon(Icons.camera_alt_outlined, size: 25,), 'Camera',
                      context),
                  item(Icon(Icons.broken_image_outlined, size: 25,), 'Gallery',
                      context),
                ],
              ),
            ),
          )
      ),
    );
  }

  getFromGallery() async {
    setState(() {
      imageLoading=true;
    });
    var pickedFile = await Img.ImagePicker().getImage(
      imageQuality: 75,
      source: Img.ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      // setState(() {
      //   imageLoading=true;
      // });
      var imageFile1 = File(pickedFile.path);
      print('file:$imageFile1');

      // await patientApi.sendProfilePic(imageFile1).then((value) async {
      //   print('valueee$value');
      //   if(value=='success')
      //   {
      //     print('entrooo');
      //     image1=await patientApi.getProfilePic(context);
      //     print('entered heyyy');
      //     imageFile2=await image1;
      //     print('image$imageFile2');
      //     setState(() {
      //       imageLoading=false;
      //     });
      //   }
      // });



    }
    else{
      print('entered');
      setState(() {
        imageLoading=false;
      });
    }
  }

  getFromCamera() async {
    var pickedFile = await Img.ImagePicker().getImage(
      imageQuality: 75,
      source: Img.ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageLoading=true;
      });
      imageFile = File(pickedFile.path);
      // await patientApi.sendProfilePic(imageFile).then((value) async {
      //   print('valueee$value');
      //   if(value=='success')
      //   {
      //     print('entrooo1');
      //     image1=await patientApi.getProfilePic(context);
      //     print('entered heyyy1');
      //     imageFile2=await image1;
      //     //var bytes=uint8List.fromList(imageFile2);
      //     print('image$imageFile2');
      //     setState((){
      //       imageLoading=false;
      //     });
      //   }
      // });
    }
  }

  getImage()async{
    image4=await localStorage.readData();
    print('IMAGE4:$image4');
    if(image4!=null)
    {
      imageFile2=image4;
      setState(() {
        imageLoading=false;
      });
    }
    else{
      image4=null;
      imageFile2=null;
    }
  }


  @override
  void initState() {
    getImage();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var circleHeight = MediaQuery
        .of(context)
        .size
        .height * 0.20;
    var circleWidth = MediaQuery
        .of(context)
        .size
        .height * 0.20;
    var buttonHeight = MediaQuery
        .of(context)
        .size
        .height * 0.05;
    var buttonWidth = MediaQuery
        .of(context)
        .size
        .height * 0.17;
    return Container(
      padding: EdgeInsets.only(top: 20),
      height: MediaQuery
          .of(context)
          .size
          .height * 0.30,
      width: circleWidth,
      child: Center(
        child: Column(
          children: [
            Container(
              height: circleHeight,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.blue,
                    child: CircleAvatar(
                      radius: 79,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 70,
                        child: imageFile2==null|| imageFile2==0?Container(child: Text('Hey !!',textAlign: TextAlign.center,)):imageLoading?Center(child: CircularProgressIndicator()):ClipRRect(
                          borderRadius: BorderRadius.circular(70),
                          child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(70)),
                            //borderRadius: BorderRadius.circular(70),
                            child:Image.file(
                              imageFile,
                              fit: BoxFit.cover,
                            ),
                            // child: Image.file(
                            //   imageFile,
                            //   fit: BoxFit.cover,
                            // ),
                          ),
                        ),
                      ),
                    ),
                    //child: Container(decoration: BoxDecoration(border: Border.all(width: 1,color: Colors.blue)),),
                  ),
                  Positioned(
                    top: circleHeight - (buttonHeight + MediaQuery
                        .of(context)
                        .size
                        .height * 0.02),
                    left: circleWidth - MediaQuery
                        .of(context)
                        .size
                        .height * 0.125,
                    bottom: MediaQuery
                        .of(context)
                        .size
                        .height * 0.022,
                    child: Container(
                      height: buttonHeight,
                      width: buttonWidth,
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Color.fromRGBO(175, 218, 255, 1),
                          child: Center(
                            child: IconButton(
                              icon: Icon(Icons.create_outlined, size: 22),
                              onPressed: () {
                                showBottomDialog(context);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Container(child: imageFile == null?Container(child: Text('hey'),): ClipRRect(
                  //   //borderRadius: BorderRadius.circular(70),
                  //   child: Image.file(
                  //     imageFile,
                  //     fit: BoxFit.cover,
                  //
                  //   ),
                  // ),)
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.02,
            ),
            Container(
              child: FittedBox(
                child: Text(
                  '${widget.firstName}', style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Poppins',
                    fontSize: 20, color: Color.fromRGBO(1, 127, 251, 1)),),
              ),
            )
          ],
        ),
      ),
    );
  }
}