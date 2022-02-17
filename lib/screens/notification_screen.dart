import 'package:flutter/material.dart';
import 'package:fyp_project/api/task_api.dart';
import 'package:fyp_project/notifier/notification_notifier.dart';
import 'package:fyp_project/screens/notification_listscreen.dart';
import 'package:fyp_project/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  static const routeName = '/notification-screen';
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
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
        drawer: AppDrawer(),
        body: NotificationScreenList()
      );
  }
}