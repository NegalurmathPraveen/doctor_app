import 'dart:io';

import 'package:image_picker/image_picker.dart' as Img;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../local_storage_classes/local_storage.dart';
import '../patient_api.dart';
class AddPicture extends StatefulWidget {
  var type;
  AddPicture({required this.type});

  @override
  State<AddPicture> createState() => _AddPictureState();
}

class _AddPictureState extends State<AddPicture> {

  PatientApi patientApi=PatientApi();
  LocalStorage localStorage= LocalStorage(path1:'profileImage.json');
  var imageFile;
  var image1;
  var imageFile1;
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
    var pickedFile = await Img.ImagePicker().pickImage(source: Img.ImageSource.gallery,);
    if (pickedFile != null) {
      // setState(() {
      //   imageLoading=true;
      // });
      imageFile = File(pickedFile.path);
      print('file:$imageFile');
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

      setState(() {
        imageLoading=false;
      });

    }
  }

  getFromCamera() async {
    var pickedFile = await Img.ImagePicker().pickImage(source: Img.ImageSource.camera);
    if (pickedFile != null) {
      imageFile =File(pickedFile!.path);
      setState(() {});
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
          setState((){
            imageLoading=false;
          });
      //   }
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    return Container(
      height: widget.type=='update'?height*0.12:height*0.17,
      padding: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          widget.type=='update'?Container(
            width: imageFile==null?width*0.35:null,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
                color: Colors.black12,
                image: DecorationImage(image:AssetImage('assets/images/Image.png'),fit: BoxFit.cover)),
            height: double.infinity,
            child: ClipOval(
              child: imageFile==null?Container():imageLoading?Center(child: CircularProgressIndicator()):Image.file(
                imageFile,
                width:100,
                height:170,
                fit:BoxFit.cover,
              ),
            ),
          ):
          Container(
            width: width*0.35,
            height: double.infinity,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.black12,
                image: DecorationImage(image:AssetImage('assets/images/Image.png'),fit: BoxFit.cover)
            ),
            child: imageFile==null?Container():imageLoading?Center(child: CircularProgressIndicator()):Image.file(
              imageFile,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: double.infinity,
            child: TextButton(onPressed: (){
              showBottomDialog(context);
            },child: Container(
              decoration: BoxDecoration(color: Colors.blue,borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
              child: Row(
                children: [
                  Icon(Icons.photo_camera_outlined,color: Colors.white,),
                  SizedBox(width: width*0.03,),
                  Text('Take Photo',style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                      fontSize: 18,color:Colors.white),),
                ],
              ),
            ),),
          )

        ],
      ),
    );
  }
}
