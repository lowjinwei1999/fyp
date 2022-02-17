import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:fyp_project/api/task_api.dart';
import 'package:fyp_project/notifier/chat_notifiier.dart';
import 'package:fyp_project/notifier/notification_notifier.dart';
import 'package:fyp_project/notifier/payment_notifier.dart';
//import 'package:fyp_project/providers/payment.dart';
//import 'package:fyp_project/providers/user.dart';
import 'package:fyp_project/screens/chat_screen.dart';
import 'package:fyp_project/screens/notification_screen.dart';
import 'package:fyp_project/screens/paymentrecord_screen.dart';
import 'package:fyp_project/screens/process.dart';
import 'package:fyp_project/sp/screens/sp_chatscreen.dart';
import 'package:fyp_project/sp/screens/sp_debitscreen.dart';
import 'package:fyp_project/sp/screens/sp_main.dart';
import 'package:fyp_project/sp/screens/sp_managetaskscreen.dart';
import 'package:fyp_project/sp/screens/sp_notificationscreen.dart';
import 'package:fyp_project/sp/screens/sp_paymentrecordscreen.dart';
import 'package:fyp_project/sp/screens/sp_usermanagementscreen.dart';
//import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

//import 'screens/chat_screen.dart';
import 'notifier/comment_notifier.dart';
import 'screens/tasklist_screen.dart';
import 'screens/user_management_screen.dart';
import 'screens/login.dart';

//import 'providers/task_method.dart';

import 'notifier/auth_notifier.dart';
import 'notifier/chat_notifiier.dart';
import 'package:fyp_project/notifier/task_testing_notifier.dart';
import 'screens/task_testing_screen.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => AuthNotifier(),
    ),
    ChangeNotifierProvider(
      create: (context) => TaskTestingNotifier(),
    ),
    ChangeNotifierProvider(
      create: (context) => ChatNotifier(),
    ),
     ChangeNotifierProvider(
      create: (context) => CommentNotifier(),
    ),
    ChangeNotifierProvider(
      create: (context) => PaymentNotifier(),
    ),
     ChangeNotifierProvider(
      create: (context) => NotificationNotifier(),
    ),
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

//methOdThatLoadsId().then((id) => print("Id that was loaded: $id"));
class _MyAppState extends State<MyApp> {
  @override
  
  @override
  Widget build(BuildContext context) {
//AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    return MaterialApp(
      title: 'We Do',
      theme: ThemeData(
        fontFamily: GoogleFonts.openSans().fontFamily,
        primarySwatch: Colors.deepPurple,
        backgroundColor: Colors.deepPurple,
        accentColor: Colors.deepPurple,
        accentColorBrightness: Brightness.dark,
        buttonTheme: ButtonTheme.of(context).copyWith(
            buttonColor: Colors.deepPurple,
            textTheme: ButtonTextTheme.primary,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))),
      ),
      //snapshot help the application to auto login
      home: StreamBuilder(
          stream: FirebaseAuth.instance.onAuthStateChanged,
          builder: (ctx, userSnapshot) {
            if (userSnapshot.hasData) {
              return Process();
            }
            //return SpMain();
            return Login();
          }),
      routes: {
        Login.routeName: (ctx) => Login(),
        TaskListScreen.routeName: (ctx) => TaskListScreen(),
        UserManagementScreen.routeName: (ctx) => UserManagementScreen(isView: false,),
        TaskTestingScreen.routeName: (ctx) => TaskTestingScreen(),
        ChatScreen.routeName: (ctx) => ChatScreen(),
        PaymentRecordScreen.routeName:(ctx)=>PaymentRecordScreen(),
        NotificationScreen.routeName:(ctx)=>NotificationScreen(),

        SpMain.routeName: (ctx) => SpMain(),
        SpUserManagementScreen.routeName: (ctx) => SpUserManagementScreen(isView: false,),
        SpTaskManageScreen.routeName:(ctx)=>SpTaskManageScreen(),
        SpChatScreen.routeName: (ctx) => SpChatScreen(),
        SpDebitScreen.routeName: (ctx) => SpDebitScreen(),
        SpPaymentRecordScreen.routeName:(ctx)=>SpPaymentRecordScreen(),
        SpNotificationScreen.routeName:(ctx)=>SpNotificationScreen(),
      },
    );
  }
}

Future<String> getCurrentUserData(String current21) async {
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  final currentdoc =
      await Firestore.instance.collection('users').document(user.uid).get();
  //create a list
  String current21 = currentdoc.data['accounttype'];
  return current21;
}
