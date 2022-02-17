import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp_project/api/task_api.dart';
import 'package:fyp_project/notifier/auth_notifier.dart';
import 'package:fyp_project/notifier/chat_notifiier.dart';
import 'package:fyp_project/notifier/comment_notifier.dart';
import 'package:fyp_project/payment/homepage.dart';
import 'package:fyp_project/providers/task_testing.dart';
import 'package:fyp_project/screens/chatroom_screen.dart';
import 'package:fyp_project/screens/task_form_testing.dart';
import 'package:fyp_project/screens/user_management_screen.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';

import 'package:fyp_project/notifier/task_testing_notifier.dart';

class TaskDetailTestingScreen extends StatelessWidget {
  String spid;
  String taskid;
  String userid;
  @override
  Widget build(BuildContext context) {
    TaskTestingNotifier tasktestingNotifier =
        Provider.of<TaskTestingNotifier>(context);
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    ChatNotifier chatNotifier = Provider.of<ChatNotifier>(context);
    CommentNotifier commentNotifier = Provider.of<CommentNotifier>(context);

//delete task
    _onTaskDeleted(TaskTesting tasktesting) {
      Navigator.pop(context);
      tasktestingNotifier.deleteTask(tasktesting);
    }

//accept request
    _onTaskUpdateRequestBy(TaskTesting tasktesting) {
      tasktestingNotifier.taskUpdateRequestBy(tasktesting);
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                  title: Text('Success'),
                  content: Text('You have accept the request'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Okay'),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    )
                  ]));
    }

//reject request
    _onTaskUpdateReject(TaskTesting tasktesting) {
      tasktestingNotifier.taskUpdateRequestBy(tasktesting);
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                  title: Text('Success'),
                  content: Text('You have reject the request'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Okay'),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    )
                  ]));
    }

    _onTaskUpdateCancel(TaskTesting tasktesting) {
      tasktestingNotifier.taskUpdateRequestBy(tasktesting);
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                  title: Text('Success'),
                  content: Text('You have cancel the task'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Okay'),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/task-testing-screen');
                      },
                    )
                  ]));
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Task Detail'),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // SizedBox(height: 15),
                Image.network(
                  tasktestingNotifier.currentTaskTesting.imageUrl != null
                      ? tasktestingNotifier.currentTaskTesting.imageUrl
                      : 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/600px-No_image_available.svg.png',
                  fit: BoxFit.fill,
                  width: double.maxFinite,
                  height: 300,
                ),

                Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    tasktestingNotifier.currentTaskTesting.taskname,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                            Text(
                              tasktestingNotifier.currentTaskTesting.category,
                            ),
                          ]),
                          SizedBox(
                            height: 5,
                          ),
                          Row(children: <Widget>[
                            Icon(
                              Icons.date_range_rounded,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 5),
                            Text(tasktestingNotifier.currentTaskTesting.date),
                          ]),
                          SizedBox(
                            height: 5,
                          ),
                          Row(children: <Widget>[
                            Icon(
                              Icons.location_on,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 5),
                            Text('Johor'),
                          ]),
                          SizedBox(
                            height: 5,
                          ),
                          Row(children: <Widget>[
                            Icon(
                              Icons.restore_page,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 5),
                            Text(tasktestingNotifier.currentTaskTesting.status),
                          ]),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 1,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(children: <Widget>[
                            Icon(
                              Icons.attach_money,
                              color: Colors.grey,
                            ),
                            
                            Text(
                              tasktestingNotifier
                                          .currentTaskTesting.additionalprice !=
                                      null
                                  ? (tasktestingNotifier
                                              .currentTaskTesting.price +
                                          tasktestingNotifier.currentTaskTesting
                                              .additionalprice)
                                      .toString()
                                  : tasktestingNotifier.currentTaskTesting.price
                                      .toString(),
                              // style: TextStyle(
                              //     fontWeight: FontWeight.bold,
                              //     fontSize: 27),
                            ),
                          ]),
                          SizedBox(
                            height: 5,
                          ),
                          Row(children: <Widget>[
                            Icon(
                              Icons.access_time_rounded,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 5),
                            Text(tasktestingNotifier.currentTaskTesting.time),
                          ]),
                          SizedBox(
                            height: 5,
                          ),
                          Row(children: <Widget>[
                            Icon(
                              Icons.location_city,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 5),
                            Text(tasktestingNotifier
                                .currentTaskTesting.district),
                          ]),
                          SizedBox(
                            height: 5,
                          ),
                          Row(children: <Widget>[
                            Icon(
                              Icons.atm,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 5),
                            Text(tasktestingNotifier
                                .currentTaskTesting.paymentmethod),
                          ]),
                          
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(children: <Widget>[
                        Icon(
                          Icons.location_city_rounded,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 5),
                        Text('Address'),
                      ]),
                      Text(tasktestingNotifier.currentTaskTesting.address)
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Divider(
                  color: Colors.grey,
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.only(left: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(children: <Widget>[
                        Icon(
                          Icons.file_copy,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 5),
                        Text('Description'),
                      ]),
                      Text(
                        tasktestingNotifier.currentTaskTesting.description,
                      )
                    ],
                  ),
                ),
                Divider(color: Colors.grey,),
                SizedBox(height: 15),

                tasktestingNotifier.currentTaskTesting.status != 'Pending'
                    ? Container(
                        child: Column(
                        children: <Widget>[
                            tasktestingNotifier.currentTaskTesting.status == 'Ongoing'? GFButton(
                            onPressed: () {
                              cancelTaskByCustomer(
                                  tasktestingNotifier.currentTaskTesting,
                                  _onTaskUpdateCancel);
                            },
                            text: "Cancel  ",
                            icon: Icon(Icons.cancel, color: Colors.white),
                            shape: GFButtonShape.pills,
                            color: Color.fromRGBO(170, 33, 33, 1),
                            size: GFSize.LARGE,
                          ):Container(),
                          SizedBox(height: 1, width: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                             
                              GFButton(
                                onPressed: () {
                                  spid = tasktestingNotifier
                                      .currentTaskTesting.spid;
                                  userid = tasktestingNotifier
                                      .currentTaskTesting.spid;
                                  getSpDataFromUser(
                                      authNotifier, tasktestingNotifier);
                                  getOtherComment(
                                      authNotifier, commentNotifier, userid);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return UserManagementScreen(
                                      isView: true,
                                    );
                                  }));
                                },
                                text: "View  ",
                                icon: Icon(Icons.people_rounded,
                                    color: Colors.white),
                                shape: GFButtonShape.pills,
                                color: Color.fromRGBO(170, 33, 33, 1),
                                size: GFSize.LARGE,
                              ),
                              SizedBox(
                                height: 1,
                                width: 10,
                              ),
                              GFButton(
                                onPressed: () {
                                  getChatRoomFromChatButton(
                                      chatNotifier, tasktestingNotifier);
                                  //this userid is the customer id and task id
                                  //userid = tasktestingNotifier.currentTaskTesting.userid;
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return ChatRoomScreen(
                                      isChat: true,
                                    );
                                  }));
                                },
                                text: "Chat  ",
                                icon: Icon(Icons.message, color: Colors.white),
                                shape: GFButtonShape.pills,
                                color: Colors.deepPurple,
                                size: GFSize.LARGE,
                              ),SizedBox(
                                height: 1,
                                width: 10,
                              ),
                               tasktestingNotifier.currentTaskTesting.status == 'Ongoing' &&tasktestingNotifier.currentTaskTesting.paymentmethod== 'Online Banking'?
                              GFButton(
                                onPressed: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return HomePage(
                                     
                                    );
                                  }));
                                },
                                text: "Pay  ",
                                icon: Icon(Icons.money,
                                    color: Colors.white),
                                shape: GFButtonShape.pills,
                                color: Color.fromRGBO(170, 33, 33, 1),
                                size: GFSize.LARGE,
                              ):Container(),
                              SizedBox(
                                height: 1,
                                width: 10,
                              ),
                            ],
                          ),
                          tasktestingNotifier.currentTaskTesting.status ==
                                  'Requested'
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    GFButton(
                                      onPressed: () {
                                        rejectRequest(
                                            tasktestingNotifier
                                                .currentTaskTesting,
                                            _onTaskUpdateReject);
                                      },
                                      text: "Reject  ",
                                      icon: Icon(Icons.cancel,
                                          color: Colors.white),
                                      shape: GFButtonShape.pills,
                                      color: Color.fromRGBO(170, 33, 33, 1),
                                      size: GFSize.LARGE,
                                    ),
                                    SizedBox(height: 1, width: 10),
                                    GFButton(
                                      onPressed: () {
                                        acceptRequest(
                                            tasktestingNotifier
                                                .currentTaskTesting,
                                            _onTaskUpdateRequestBy);
                                      },
                                      text: "Accept  ",
                                      icon:
                                          Icon(Icons.done, color: Colors.white),
                                      shape: GFButtonShape.pills,
                                      color: Colors.deepPurple,
                                      size: GFSize.LARGE,
                                    ),
                                  ],
                                )
                              : Container()
                        ],
                      ))
                    : Container()
              ],
            ),
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Visibility(
              visible:
                  tasktestingNotifier.currentTaskTesting.status != 'Complete' &&
                          tasktestingNotifier.currentTaskTesting.status !=
                              'Requested'
                      ? true
                      : false,
              child: FloatingActionButton(
                heroTag: 'Button1',
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return TaskFormTesting(
                      isUpdating: true,
                    );
                  }));
                },
                child: Icon(Icons.edit),
                foregroundColor: Colors.white,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Visibility(
              visible:
                  tasktestingNotifier.currentTaskTesting.status != 'Complete' &&
                          tasktestingNotifier.currentTaskTesting.status !=
                              'Requested'&& tasktestingNotifier.currentTaskTesting.status !='Ongoing'
                      ? true
                      : false,
              child: FloatingActionButton(
                heroTag: 'Button2',
                onPressed: () => deleteTask(
                    tasktestingNotifier.currentTaskTesting, _onTaskDeleted),
                child: Icon(Icons.delete),
                backgroundColor:Color.fromRGBO(170, 33, 33, 1),
                foregroundColor: Colors.white,
              ),
            )
          ],
        ));
  }
}
