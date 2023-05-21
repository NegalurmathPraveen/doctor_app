import 'package:doctor_app/notifications/notifications_api.dart';
import 'package:flutter/material.dart';
class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  ScrollController _scrollController = new ScrollController();
  NotificationApis notificationApis=NotificationApis();

  var notificationsList=[];

  @override
  void initState() {
    getNotifications();
    super.initState();
  }
  getNotifications()async
  {
    notificationsList=await notificationApis.getNotifications(context);
    setState(() {});
  }

  Widget cardWidget(var response,var width,var height)
  {
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height:height*0.01,),
              Text(response.heading.toString(),style:TextStyle(
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Inter',
                  fontSize: 17,color:Colors.blue),),
              SizedBox(height:height*0.01,),
              Text('${response.content.toString()}',style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                  fontSize: 18,color:Color.fromRGBO(0, 0, 0, 0.87)),),
              SizedBox(height:height*0.01,),
            ],
          ),
          subtitle: Text(response.sub_heading.toString(),style:  TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
            fontSize: 17,
            color: Color.fromRGBO(0, 0, 0, 0.6),
          ),)
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          title: Text('Notifications',style: Theme.of(context).textTheme.headline3,),
        ),
      body: SingleChildScrollView(
        child: Container(
          height:height*0.7,
          child: notificationsList.isEmpty?Center(child: Text('Oopss!! Notifications list is empty',style: Theme.of(context).textTheme.headline2,)):ListView(
            controller: _scrollController,
            children: notificationsList.map((response) => cardWidget(response,width,height)).toList(),
          ),
        ),
      ),
    );
  }
}
