import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class ProfileImage extends StatefulWidget {
  var details;
  ProfileImage({required this.details});

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {

  CollectionReference _referenceProfileImage=FirebaseFirestore.instance.collection('patient_list');
  late Stream<QuerySnapshot> _streamImageList;

  @override
  void initState() {
    _streamImageList=_referenceProfileImage.snapshots();
   // print('list1:$_streamImageList');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width=MediaQuery.of(context).size.width;
    return StreamBuilder<QuerySnapshot>(
      stream:_streamImageList,
      builder:(BuildContext context,AsyncSnapshot snapshot){
        //print('snap:$snapshot');
        if(snapshot.hasError)
          {
            return  Container(
              width:width*0.12,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black12,
                  image:DecorationImage(
                      fit: BoxFit.cover,
                      image:  AssetImage('assets/images/Image.png',)
                  ) ),
            );
          }
        if(snapshot.connectionState==ConnectionState.active)
          {
              QuerySnapshot querySnapshot=snapshot.data;
              List<QueryDocumentSnapshot> listQueryDocumentSnapshot=querySnapshot.docs;
            //  print('list0:$listQueryDocumentSnapshot');
              return Container(
                width:width*0.12,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black12,
                    image:DecorationImage(
                        fit: BoxFit.cover,
                        image:  AssetImage('assets/images/Image.png',)
                    ) ),
              );
          }
        return CircularProgressIndicator();
      } ,
    );
  }
}
