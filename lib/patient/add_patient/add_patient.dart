import 'package:doctor_app/patient/patient_form.dart';
import 'package:flutter/material.dart';

import 'add_picture.dart';
import 'documents.dart';

class AddPatient extends StatefulWidget {
  const AddPatient({Key? key}) : super(key: key);

  @override
  State<AddPatient> createState() => _AddPatientState();
}

class _AddPatientState extends State<AddPatient> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Patient',
          style: Theme.of(context).textTheme.headline3,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Details', style: Theme.of(context).textTheme.headline1),
                  Text(
                    'Page 1 of 2',
                    style: Theme.of(context).textTheme.headline3,
                  )
                ],
              ),
            ),
            AddPicture(type: 'add',),
            PatientForm(type:'add'),
          ],
        ),
      ),
    );
  }
}
