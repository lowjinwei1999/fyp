import 'package:flutter/material.dart';
import 'package:fyp_project/api/task_api.dart';
import 'package:fyp_project/notifier/auth_notifier.dart';
import 'package:fyp_project/notifier/task_testing_notifier.dart';
import 'package:fyp_project/sp/screens/sp_taskdetailscreen.dart';
import 'package:provider/provider.dart';

class SpAcceptedTaskList extends StatefulWidget {
  @override
  _SpAcceptedTaskListState createState() => _SpAcceptedTaskListState();
}

class _SpAcceptedTaskListState extends State<SpAcceptedTaskList> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    TaskTestingNotifier tasktestingNotifier =
        Provider.of<TaskTestingNotifier>(context);

    Future<void> _refreshList() async {
      getAcceptedTask(tasktestingNotifier);
    }

    return tasktestingNotifier.acceptedtasktestingList.isEmpty
        ? Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.network(
                    'https://icons-for-free.com/iconfiles/png/512/Close+Remove+Circle+Cross+Delete-131983793801478052.png',
                    height: 100,
                  ),
                  Text(
                    "You have no task yet",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )
                ]),
          )
        : new RefreshIndicator(
            child: ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    //this gonna store which task is clicked, store current task
                    tasktestingNotifier.currentTaskTesting =
                        tasktestingNotifier.acceptedtasktestingList[index];
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return SpTaskDetailScreen();
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
                              tasktestingNotifier.acceptedtasktestingList[index]
                                          .imageUrl !=
                                      null
                                  ? tasktestingNotifier
                                      .acceptedtasktestingList[index].imageUrl
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(children: <Widget>[
                                        Icon(
                                          Icons.search,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(width: 5),
                                        Text(tasktestingNotifier
                                            .acceptedtasktestingList[index]
                                            .category),
                                      ]),
                                      SizedBox(height: 8),
                                      Row(children: <Widget>[
                                        Icon(
                                          Icons.atm,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(width: 5),
                                        Text(tasktestingNotifier
                                            .acceptedtasktestingList[index]
                                            .paymentmethod),
                                      ]),
                                      SizedBox(height: 8),
                                      Row(children: <Widget>[
                                        Icon(
                                          Icons.location_city,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(width: 5),
                                        Text(tasktestingNotifier
                                            .acceptedtasktestingList[index]
                                            .district),
                                      ]),
                                      SizedBox(height: 8),
                                      Row(children: <Widget>[
                                        Icon(
                                          Icons.stairs,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(width: 5),
                                        Text(tasktestingNotifier
                                                        .acceptedtasktestingList[
                                                            index]
                                                        .requestby !=
                                                    null &&
                                                tasktestingNotifier
                                                        .acceptedtasktestingList[
                                                            index]
                                                        .spid ==
                                                    null
                                            ? 'Requested'
                                            : tasktestingNotifier
                                                .acceptedtasktestingList[index]
                                                .status),
                                      ]),
                                    ],
                                  ),
                                  Row(children: <Widget>[
                                    Icon(
                                      Icons.attach_money,
                                      color: Colors.grey,
                                    ),
                                    Text(
                                      tasktestingNotifier
                                                  .acceptedtasktestingList[
                                                      index]
                                                  .additionalprice !=
                                              null
                                          ? (tasktestingNotifier
                                                      .acceptedtasktestingList[
                                                          index]
                                                      .price +
                                                  tasktestingNotifier
                                                      .acceptedtasktestingList[
                                                          index]
                                                      .additionalprice)
                                              .toString()
                                          : tasktestingNotifier
                                              .acceptedtasktestingList[index]
                                              .price
                                              .toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 27),
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
              itemCount: tasktestingNotifier.acceptedtasktestingList.length,
              separatorBuilder: (BuildContext context, int index) {
                return Divider(color: Colors.transparent);
              },
            ),
            onRefresh: _refreshList,
          );
  }
}
