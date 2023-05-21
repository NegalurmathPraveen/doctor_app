
import 'package:doctor_app/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../widgets/add_message_widget.dart';
import 'patient_list.dart';
class VaccineMessage extends StatefulWidget {
  const VaccineMessage({Key? key}) : super(key: key);

  @override
  State<VaccineMessage> createState() => _VaccineMessageState();
}

class _VaccineMessageState extends State<VaccineMessage> {
  TextEditingController dateController = TextEditingController();
  var message;


  Widget textFields(String labelText, var inputFormatters, var limit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ' $labelText',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: Color.fromRGBO(40, 41, 61, 1),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        TextFormField(
          onTap: labelText == 'date'
              ? ()async{
            // Below line stops keyboard from appearing
            DateTime? date = DateTime(1900);
            FocusScope.of(context).requestFocus(new FocusNode());
            date = await showDatePicker(
                context: context,
                initialDate:DateTime.now(),
                firstDate:DateTime(1900),
                lastDate: DateTime(2100));
            // Show Date Picker Here
            dateController.text=DateFormat('yyyy-MM-dd').format(DateTime.parse(date.toString()));
            setState(() {});
          } : null,
          maxLength: limit,
          maxLines: labelText == 'message'
              ? 6 : null,
          style: Theme.of(context).textTheme.headline4,
          inputFormatters: inputFormatters,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            suffixIcon: labelText=='date'?Icon(Icons.calendar_month_outlined):null,
              hintText: labelText=='date'?dateController.text:null,
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              contentPadding:
              EdgeInsets.symmetric(vertical: 10, horizontal: 15)),
          validator: (value) {
            if (labelText == 'message') {
              if (value!.isEmpty) {
                return 'can\'t be empty';
              } else if (value.length < 3) {
                return 'message length shouldn\'t be less than 3 letters';
              } else if (value.length > 15) {
                return 'message length shouldn\'t be more than 45 letters';
              } else {
                return null;
              }
            }else {
              return null;
            }
          },
          onSaved: (value) {
            if (labelText == 'message') {
              message = value;
            }
          },
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        )
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar:AppBar(
        title: Text('Add Follow-up Message',style: Theme.of(context).textTheme.headline3,),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: AddMessage(page:'vaccination')
      ),
    );
  }
}
