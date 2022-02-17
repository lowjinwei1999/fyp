import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp_project/screens/task_detail_testing_screen.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../notifier/auth_notifier.dart';
import 'package:fyp_project/notifier/task_testing_notifier.dart';
import '../api/task_api.dart';

class TaskListScreen extends StatefulWidget {
  static const routeName = '/tasklist-screeen';

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  // var isLoading = false;

  @override

//initState use to retirev the data when the state first build
  // void initState() {
  //   // AuthNotifier authNotifier =
  //   //     Provider.of<AuthNotifier>(context, listen: false);
  //   // getUserData(authNotifier);
  //   // TaskTestingNotifier tasktestingNotifier =
  //   //     Provider.of<TaskTestingNotifier>(context, listen: false);

  //   // setState(() {getTask(tasktestingNotifier);
  //   //     //  isLoading = false;
  //   //     });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    TaskTestingNotifier tasktestingNotifier =
        Provider.of<TaskTestingNotifier>(context);
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);

    Future<void> _refreshList() async {
      getTask(tasktestingNotifier);
      getUserData(authNotifier);
    }

    return new RefreshIndicator(
      child: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              //this gonna store which task is clicked, store current task
              tasktestingNotifier.currentTaskTesting =
                  tasktestingNotifier.tasktestingList[index];
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return TaskDetailTestingScreen();
              }));
            },
            child: Container(
              width: width,
              height: 385,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 13),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.7),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                ),
                elevation: 4,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Image.network(
                        tasktestingNotifier.tasktestingList[index].imageUrl !=
                                null
                            ? tasktestingNotifier
                                .tasktestingList[index].imageUrl
                            : 'https://previews.123rf.com/images/pavelstasevich/pavelstasevich1811/pavelstasevich181101027/112815900-no-image-available-icon-flat-vector.jpg',
                        height: 220,
                        width: double.maxFinite,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Container(
                        width: double.maxFinite,
                        padding: EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(children: <Widget>[
                                  Icon(
                                    Icons.search,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 5),
                                  Text(tasktestingNotifier
                                      .tasktestingList[index].category),
                                ]),
                                SizedBox(height: 8),
                                Row(children: <Widget>[
                                  Icon(
                                    Icons.atm,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 5),
                                  Text(tasktestingNotifier
                                      .tasktestingList[index].paymentmethod),
                                ]),
                                SizedBox(height: 8),
                                Row(children: <Widget>[
                                  Icon(
                                    Icons.location_city,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 5),
                                  Text(tasktestingNotifier
                                      .tasktestingList[index].district),
                                ]),
                                SizedBox(height: 8),
                                Row(children: <Widget>[
                                  Icon(
                                    Icons.stairs,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 5),
                                  Text(tasktestingNotifier
                                      .tasktestingList[index].status),
                                ]),
                              ],
                            ),
                            Row(children: <Widget>[
                              Icon(
                                Icons.attach_money,
                                color: Colors.grey,
                              ),
                              Text(
                                tasktestingNotifier.tasktestingList[index]
                                            .additionalprice !=
                                        null
                                    ? (tasktestingNotifier
                                                .tasktestingList[index].price +
                                            tasktestingNotifier
                                                .tasktestingList[index]
                                                .additionalprice)
                                        .toString()
                                    : tasktestingNotifier
                                        .tasktestingList[index].price.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 27),
                              ),
                            ]),
                          ],
                        )),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: tasktestingNotifier.tasktestingList.length,
        separatorBuilder: (BuildContext context, int index) {
          return Divider(color: Colors.transparent);
        },
      ),
      onRefresh: _refreshList,
    );
  }
}
