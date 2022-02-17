import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_project/notifier/chat_notifiier.dart';
import 'package:fyp_project/notifier/comment_notifier.dart';
import 'package:fyp_project/screens/login.dart';
import 'package:fyp_project/screens/task_detail_testing_screen.dart';
import 'package:fyp_project/screens/task_form_testing.dart';
import 'package:fyp_project/screens/tasklist_screen.dart';
import 'package:provider/provider.dart';

import '../notifier/auth_notifier.dart';

import 'package:fyp_project/notifier/task_testing_notifier.dart';
import '../api/task_api.dart';

import '../widgets/app_drawer.dart';

class TaskTestingScreen extends StatefulWidget {
  static const routeName = '/task-testing-screen';

  @override
  _TaskTestingScreenState createState() => _TaskTestingScreenState();
}

class _TaskTestingScreenState extends State<TaskTestingScreen> {
  // var isLoading = false;

  @override

//initState use to retirev the data when the state first build
  void initState() {
    _removeallchatroomlist();
   _removeallviewdcomment();
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    getUserData(authNotifier);
    TaskTestingNotifier tasktestingNotifier =
        Provider.of<TaskTestingNotifier>(context, listen: false);
    getTask(tasktestingNotifier);
    setState(() {
        //  isLoading = false;
        });
    super.initState();
  }
_removeallchatroomlist()
{
   ChatNotifier chatNotifier =
        Provider.of<ChatNotifier>(context, listen: false);
    chatNotifier.clearchatroomlist();
    chatNotifier.clearchatroomlist();
    
}

_removeallviewdcomment()
{
   CommentNotifier commentNotifier =
        Provider.of<CommentNotifier>(context, listen: false);
  commentNotifier.clearviewedcomment();
}
  //   double width = MediaQuery.of(context).size.width;
  //   
  //   Future<void> _refreshList() async {
  //     getTask(tasktestingNotifier);
  //     getUserData(authNotifier);
  //   }
@override

  Widget build(BuildContext context) {
    // print('build task testing screen');
    TaskTestingNotifier tasktestingNotifier =
        Provider.of<TaskTestingNotifier>(context);
 //   AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);

    return DefaultTabController(
       length: 1,
          child: Scaffold(
        appBar: AppBar( bottom: TabBar(
              tabs: [
                Tab(text:'Pending'),
                // Tab(text:'Ongoing'),
                // Tab(text: 'Complete',),
              ],
            ),
          title: Text(
            'Manage Task',
            //authNotifier.userList[0].name != null ? authNotifier.userList[0].name: "Feed",
          ),
          actions: [],
        ),
        drawer: AppDrawer(),
        body: TabBarView(
            children: [
             TaskListScreen(),
            //  TaskListOngoingScreen(),
            //  TaskListCompleteScreen(),
            ],
          ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            tasktestingNotifier.currentTaskTesting = null;
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              return TaskFormTesting(
                isUpdating: false,
              );
            }));
          },
          child: Icon(Icons.add),
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}
// ListTile(
//               leading: Image.network(
//                   tasktestingNotifier.tasktestingList[index].imageUrl != null
//                       ? tasktestingNotifier.tasktestingList[index].imageUrl
//                       : 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/600px-No_image_available.svg.png',
//                   width: 120,
//                   fit: BoxFit.fitWidth),
//               title: Text(tasktestingNotifier.tasktestingList[index].taskname),
//               subtitle:
//                   Text(tasktestingNotifier.tasktestingList[index].category),
//               onTap: () {
//                 //this gonna store which task is clicked, store current task
//                 tasktestingNotifier.currentTaskTesting =
//                     tasktestingNotifier.tasktestingList[index];
//                 Navigator.of(context)
//                     .push(MaterialPageRoute(builder: (BuildContext context) {
//                   return TaskDetailTestingScreen();
//                 }));
//               },
//             );
