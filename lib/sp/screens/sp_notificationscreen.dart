import 'package:flutter/material.dart';
import 'package:fyp_project/api/task_api.dart';
import 'package:fyp_project/notifier/notification_notifier.dart';
import 'package:fyp_project/sp/screens/sp_notificationlistscreen.dart';
import 'package:fyp_project/sp/widgets/sp_appdrawer.dart';
import 'package:provider/provider.dart';

class SpNotificationScreen extends StatefulWidget {
  static const routeName = '/sp-notification-screen';
  @override
  _SpNotificationScreenState createState() => _SpNotificationScreenState();
}

class _SpNotificationScreenState extends State<SpNotificationScreen> {
   void initState() {
    NotificationNotifier notificationNotifier = Provider.of<NotificationNotifier>(context,listen: false);
    getNotification(notificationNotifier);
    setState(() {
        //  isLoading = false;
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar( 
          title: Text(
            'Notification',
           
          ),
          actions: [],
        ),
        drawer: SpAppDrawer(),
        body: SpNotificationScreenList()
      );
  }
}