import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_project/screens/chat_screen.dart';
import 'package:fyp_project/sp/screens/sp_acceptedtasklist.dart';
import 'package:fyp_project/sp/screens/sp_chatscreen.dart';
import 'package:fyp_project/sp/screens/sp_debitscreen.dart';
import 'package:fyp_project/sp/screens/sp_main.dart';
import 'package:fyp_project/sp/screens/sp_managetaskscreen.dart';
import 'package:fyp_project/sp/screens/sp_notificationscreen.dart';
import 'package:fyp_project/sp/screens/sp_paymentrecordscreen.dart';
import 'package:fyp_project/sp/screens/sp_usermanagementscreen.dart';
import 'package:fyp_project/widgets/create_agreement.dart';
import 'package:provider/provider.dart';
import 'package:getwidget/getwidget.dart';

// import '../screens/task_testing_screen.dart';
// import '../screens/user_management_screen.dart';
import '../../notifier/auth_notifier.dart';

class SpAppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);

    return GFDrawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          GFDrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: GFAvatar(
                    radius: 40.0,
                    backgroundImage: NetworkImage(authNotifier
                                .userList[0].imageUrl !=
                            null
                        ? authNotifier.userList[0].imageUrl
                        : 'https://cdn2.iconfinder.com/data/icons/facebook-51/32/FACEBOOK_LINE-01-512.png'),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  authNotifier.userList[0].name != null
                      ? authNotifier.userList[0].name
                      : 'Hello Friend!',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Colors.white70),
                ),
                SizedBox(height: 3),
                Text(
                  authNotifier.userList[0].email != null
                      ? authNotifier.userList[0].email
                      : 'No Email',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Main'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(SpMain.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('Manage Profile'),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return SpUserManagementScreen(
                  isView: false,
                );
              }));
              //print(authResult.user.uid);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Task'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(SpTaskManageScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.credit_card),
            title: Text('Payment Record'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(SpPaymentRecordScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.credit_card),
            title: Text('Debit/Credit'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(SpDebitScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.chat_bubble),
            title: Text('Inbox'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(SpChatScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.notification_important),
            title: Text('Notification'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(SpNotificationScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.file_copy),
            title: Text('Terms and Condition'),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return CreateAgreement();
              }));
              //print(authResult.user.uid);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
              FirebaseAuth.instance.signOut();
              showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                          title: Text('Login Successfully'),
                          content: Text('You are logout.'),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Okay'),
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                            )
                          ]));
            },
          ),
        ],
      ),
    );
  }
}

//     return Drawer(
//       child: Column(
//         children: <Widget>[
//           AppBar(
//             title: Text(
//                 authNotifier.userList[0].name != null
//                   ? 'Hello ' + authNotifier.userList[0].name :
//                 'Hello Friend!'),
//             automaticallyImplyLeading: false,
//           ),
//           Divider(),
//           ListTile(
//             leading: Icon(Icons.edit),
//             title: Text('Manage Task'),
//             onTap: () {
//               Navigator.of(context)
//                   .pushReplacementNamed(TaskTestingScreen.routeName);
//             },
//           ),
//           Divider(),
//           ListTile(
//             leading: Icon(Icons.people),
//             title: Text('Manage Profile'),
//             onTap: () {
//               Navigator.of(context)
//                   .pushReplacementNamed(UserManagementScreen.routeName);
//               //print(authResult.user.uid);
//             },
//           ),
//           Divider(),
//           ListTile(
//             leading: Icon(Icons.chat_bubble),
//             title: Text('Chat/Notification'),
//             onTap: () {
//               Navigator.of(context);
//               //.pushReplacementNamed(ChatScreen.routeName);
//             },
//           ),
//           Divider(),
//           ListTile(
//             leading: Icon(Icons.exit_to_app),
//             title: Text('Logout'),
//             onTap: () {
//               Navigator.of(context).pushReplacementNamed('/');
//               FirebaseAuth.instance.signOut();
//               showDialog(
//                   context: context,
//                   builder: (ctx) => AlertDialog(
//                           title: Text('Login Successfully'),
//                           content: Text('You are logout.'),
//                           actions: <Widget>[
//                             FlatButton(
//                               child: Text('Okay'),
//                               onPressed: () {
//                                   Navigator.of(ctx).pop();
//                               },
//                             )
//                           ]));

//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// ListTile(
//   leading: Icon(Icons.exit_to_app),
//   title: Text('Logout'),
//   onTap : () {
//     Navigator.of(context).pop();
//    showDialog(
// context: context,
// builder: (ctx) => AlertDialog(
//   title: Text('Login Successfully'),
//   content: Text('You are logout.'),
//   actions: <Widget>[
//     FlatButton(
//       child: Text('Okay'),
//       onPressed: () {
//         Navigator.of(ctx).pop();
//       },
//     )
//   ],
// ),
// );
//    // Navigator.of(context).pushReplacementNamed('/');//always back to home route
//     // Navigator.of(context)
//     //     .pushReplacementNamed(UserProductsScreen.routeName);
//     Provider.of<Auth>(context,listen: false).logout();
//   },
// )
