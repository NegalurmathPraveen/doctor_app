import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart' as Img;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../global_variables.dart';
import '../../local_storage_classes/local_storage.dart';
import '../patient_api.dart';
class AddPicture extends StatefulWidget {
  var type;
  var profile_image;
  var fun;
  AddPicture({required this.type,this.fun,this.profile_image});

  @override
  State<AddPicture> createState() => _AddPictureState();
}

class _AddPictureState extends State<AddPicture> {

  PatientApi patientApi=PatientApi();
  LocalStorage localStorage= LocalStorage(path1:'profileImage.json');
  CollectionReference _reference=FirebaseFirestore.instance.collection('patient_list');
  var imageFile;
  var image1;
  var imageFile1;
  var imageFile2;
  var image3;
  var image4;
  var imageLoading=false;
  var imageUrl;
  var profileImage;

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
      if(widget.type=='docs')
      {
        setState(() {
          imageList.add(imageFile);
        });
        print('entered here');
        widget.fun();
        print(imageList);
      }
      else
      {
        // imageList.clear();
        // imageList.add(imageFile);
        profileImage=imageFile;
        widget.fun('profile',imageFile);
        // uploadTOFirebase();
      }
      setState((){
        imageLoading=false;
      });
    }
  }
  uploadTOFirebase()async
  {
    String uniqueFileName=DateTime.now().millisecondsSinceEpoch.toString();
    //get a reference to storage root
    Reference referenceRoot=FirebaseStorage.instance.ref();
    Reference referenceDirImages=referenceRoot.child('images');

    //create a reference for the image to be stored
    Reference referenceImageToUpload=referenceDirImages.child(uniqueFileName);
    //handle errors/success
    try{
      //store the image
      await referenceImageToUpload.putFile(File(imageFile.path!));

      //sucess:get the download url

      imageUrl=await referenceImageToUpload.getDownloadURL();
      print('imageurl:$imageUrl');

      if(widget.type=='docs')
        {
          imageUrlList.add(imageUrl);
        }
      Map<String,String> dataToSend={
        'profile_image':widget.type!='docs'?imageUrl.toString():'',
        'documents':widget.type=='docs'?imageUrlList.toString():''
      };
      print(dataToSend);

      _reference.add(dataToSend);
    }catch(error)
    {
      print(error);
    }
  }
  getFromCamera() async {
    var pickedFile = await Img.ImagePicker().pickImage(source: Img.ImageSource.camera);
    if (pickedFile != null) {
      imageFile =File(pickedFile!.path);

        if(widget.type=='docs')
        {
          setState(() {
            imageList.add(imageFile);
          });
          print('entered here');
          widget.fun();
          print(imageList);
        }
        else
        {
          // imageList.clear();
          // imageList.add(imageFile);
          profileImage=imageFile;
          widget.fun('profile',imageFile);
         // uploadTOFirebase();
        }
          setState((){
            imageLoading=false;
          });
    }
  }

  buildImage(var image)
  {
    return Container(
      padding: EdgeInsets.all(8),
      width:MediaQuery.of(context).size.width*0.25,
      child: Image.file(
        image,
        fit: BoxFit.cover,
      ),
    );
  }

  takePhoto()
  {
    return Container(
      height: widget.type=='docs'?MediaQuery.of(context).size.height*0.10:double.infinity,
      child: TextButton(onPressed: (){
        showBottomDialog(context);
      },child: Container(
        decoration: BoxDecoration(color: Colors.blue,borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        child: Row(
          children: [
            Icon(Icons.photo_camera_outlined,color: Colors.white,),
            SizedBox(width: MediaQuery.of(context).size.width*0.03,),
            Text('Take Photo',style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
                fontSize: 18,color:Colors.white),),
          ],
        ),
      ),),
    );
  }
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    return Container(
      height: widget.type=='update'?height*0.12: widget.type=='docs'?height*0.65:height*0.17,
      padding: EdgeInsets.all(5),
      child: widget.type=='docs'?Column(
        children: [
          takePhoto(),
          imageList.isEmpty?Container():imageLoading?Center(child: CircularProgressIndicator()):Container(
            height: MediaQuery.of(context).size.height*0.52,
            child: GridView.builder(
                gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemCount:imageList.length,
                itemBuilder:(context,index){
                  final image=imageList[index];
                  return buildImage(image);
                }),
          ),
        ],
      ):Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // widget.type=='update'?Container(
          //   width: imageFile==null?width*0.40:null,
          //   decoration: BoxDecoration(
          //     shape: BoxShape.circle,
          //       color: Colors.black12,
          //       image: DecorationImage(image:widget.profile_image!=null?NetworkImage(widget.profile_image):AssetImage('assets/images/Image.png') as ImageProvider,fit: BoxFit.cover)),
          //   height: double.infinity,
          //   child: ClipOval(
          //     child: imageList.isEmpty?Container():imageLoading?Center(child: CircularProgressIndicator()):Image.file(
          //       imageFile,
          //       width:100,
          //       height:170,
          //       fit:BoxFit.cover,
          //     ),
          //   ),
          // ):
          Container(
            width: width*0.35,
            height: double.infinity,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.black12,
                image: DecorationImage(image:widget.profile_image!=null?NetworkImage(widget.profile_image):AssetImage('assets/images/Image.png') as ImageProvider,fit: BoxFit.cover)
            ),
            child: widget.type=='profile'?profileImage==null?Container():imageLoading?Center(child: CircularProgressIndicator()):Image.file(
              profileImage,
              fit: BoxFit.cover,
            ):imageList.isEmpty?Container():imageLoading?Center(child: CircularProgressIndicator()): GridView.builder(
                gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemCount:imageList.length,
                itemBuilder:(context,index){
                  final image=imageList[index];
                  return buildImage(image);
                }),
          ),
          takePhoto()
        ],
      ),
    );
  }
}
