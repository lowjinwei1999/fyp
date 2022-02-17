
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fyp_project/api/task_api.dart';
import 'package:fyp_project/notifier/auth_notifier.dart';
import 'package:fyp_project/notifier/task_testing_notifier.dart';
import 'package:fyp_project/screens/task_testing_screen.dart';
import 'package:fyp_project/sp/screens/sp_main.dart';
import 'package:provider/provider.dart';

class Process extends StatefulWidget {
  @override
  _ProcessState createState() => _ProcessState();
}

class _ProcessState extends State<Process> {
  var isLoading = false;
  var _isInit = true;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  void iniState() {
     
    // print('run inistate');
    // AuthNotifier authNotifier =
    //     Provider.of<AuthNotifier>(context, listen: true);
    // getUserData(authNotifier);
    // //print(authNotifier.userList[0].accounttype);
    // setState(() {
    //   isLoading = true;
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        isLoading = true;
      });
      AuthNotifier authNotifier =
          Provider.of<AuthNotifier>(context, listen: true);
      getUserData(authNotifier).then((_) {
        setState(() {
          configureRealTimePushNotification();
          isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  configureRealTimePushNotification() async {
    print('run configureRealTimePushNotificatipon');
    var user = await FirebaseAuth.instance.currentUser();
    CollectionReference userRef2 = Firestore.instance.collection('users');

    DocumentReference documentRef2 = userRef2.document(user.uid);
    _firebaseMessaging.getToken()
      ..then((token) {
        documentRef2.updateData({'androidNotificationToken': token});
      });
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> msg) async {
          final String recipientId = msg['data']['recipient'];
          final String body = msg['notification']['body'];

          if(recipientId==user.uid)
          {
            SnackBar snackBar = SnackBar(
              backgroundColor: Colors.grey,
              content:Text(body,style: TextStyle(color: Colors.black,),overflow: TextOverflow.ellipsis,
            ));
          _scaffoldKey.currentState.showSnackBar(snackBar);

          }
        });
  }

  @override
  Widget build(BuildContext context) {
    // print('process screen');
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: true);
    return isLoading
        ? Scaffold(body: Center(child: new CircularProgressIndicator()))
        : authNotifier.userList[0].accounttype == 'Customer'
            ? TaskTestingScreen()
            : SpMain();
  }
}
