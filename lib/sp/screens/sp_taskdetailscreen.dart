import 'package:flutter/material.dart';
import 'package:fyp_project/api/task_api.dart';
import 'package:fyp_project/notifier/auth_notifier.dart';
import 'package:fyp_project/notifier/chat_notifiier.dart';
import 'package:fyp_project/notifier/comment_notifier.dart';
import 'package:fyp_project/notifier/payment_notifier.dart';
import 'package:fyp_project/providers/payment.dart';
import 'package:fyp_project/providers/task_testing.dart';
import 'package:fyp_project/sp/screens/sp_chatroomscreen.dart';
import 'package:fyp_project/sp/screens/sp_usermanagementscreen.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';

import 'package:fyp_project/notifier/task_testing_notifier.dart';

class SpTaskDetailScreen extends StatelessWidget {
  String userid;
  String taskid;
  Payment _payment = Payment();
  @override
  Widget build(BuildContext context) {
    TaskTestingNotifier tasktestingNotifier =
        Provider.of<TaskTestingNotifier>(context);

    ChatNotifier chatNotifier = Provider.of<ChatNotifier>(context);

    CommentNotifier commentNotifier = Provider.of<CommentNotifier>(context);

    PaymentNotifier paymentNotifier = Provider.of<PaymentNotifier>(context);

    _onTaskUpdateRequestBy(TaskTesting tasktesting) {
      tasktestingNotifier.taskUpdateRequestBy(tasktesting);
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                  title: Text('Success'),
                  content: Text(
                      'Your Request Have Been Sent. Wait For Confirmation'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Okay'),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/sp_main');
                      },
                    )
                  ]));
    }

    //cancel request
    _onTaskUpdateCancel(TaskTesting tasktesting) {
      tasktestingNotifier.taskUpdateRequestBy(tasktesting);
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                  title: Text('Success'),
                  content: Text('You have cancel the request'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Okay'),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/sp_taskmanagescreen');
                      },
                    )
                  ]));
    }

//set task status to complete
    _onTaskUpdateComplete(TaskTesting tasktesting) {
      tasktestingNotifier.taskUpdateRequestBy(tasktesting);
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                  title: Text('Success'),
                  content: Text('Task Has Complete'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Okay'),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/sp_taskmanagescreen');
                      },
                    )
                  ]));
    }

    _onAddPayment(Payment payment) {
      paymentNotifier.addPayment(payment);
    }

    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    String isPending = tasktestingNotifier.currentTaskTesting.status;
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
                            SizedBox(width: 5),
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
                            Text(
                              tasktestingNotifier
                                  .currentTaskTesting.paymentmethod,
                            )
                          ]),
                          SizedBox(
                            height: 1,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
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
                  padding: EdgeInsets.only(left: 8),
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
                SizedBox(height: 15),
                Divider(
                  color: Colors.grey,
                ),
                tasktestingNotifier.currentTaskTesting.status == 'Ongoing'
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GFButton(
                            onPressed: () {
                              cancelTaskBySp(
                                  tasktestingNotifier.currentTaskTesting,
                                  _onTaskUpdateCancel);
                            },
                            text: "Cancel  ",
                            icon: Icon(Icons.cancel, color: Colors.white),
                            shape: GFButtonShape.pills,
                            color: Colors.red,
                            size: GFSize.LARGE,
                          ),
                          SizedBox(height: 1, width: 5),
                          GFButton(
                            onPressed: () {
                              updateComplete(
                                  tasktestingNotifier.currentTaskTesting,
                                  _onTaskUpdateComplete);
                              completePayment(
                                  tasktestingNotifier.currentTaskTesting,
                                  _payment,
                                  _onAddPayment);
                            },
                            text: "Done  ",
                            icon: Icon(Icons.done, color: Colors.white),
                            shape: GFButtonShape.pills,
                            color: Colors.deepPurple,
                            size: GFSize.LARGE,
                          ),
                        ],
                      )
                    : tasktestingNotifier.currentTaskTesting.status ==
                            'Requested'
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              GFButton(
                                onPressed: () {
                                  rejectRequest(
                                      tasktestingNotifier.currentTaskTesting,
                                      _onTaskUpdateCancel);
                                },
                                text: "Cancel Request  ",
                                icon: Icon(Icons.cancel, color: Colors.white),
                                shape: GFButtonShape.pills,
                                color: Colors.red,
                                size: GFSize.LARGE,
                              ),
                              SizedBox(height: 1)
                            ],
                          )
                        : tasktestingNotifier.currentTaskTesting.status ==
                                'Pending'
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  GFButton(
                                    onPressed: () {
                                      updateRequestBy(
                                          tasktestingNotifier
                                              .currentTaskTesting,
                                          _onTaskUpdateRequestBy);
                                    },
                                    text: "Send Request  ",
                                    icon: Icon(Icons.hail, color: Colors.white),
                                    shape: GFButtonShape.pills,
                                    color: Colors.deepPurple,
                                    size: GFSize.LARGE,
                                  ),
                                  SizedBox(height: 1)
                                ],
                              )
                            : SizedBox(),
              ],
            ),
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton.extended(
              heroTag: 'Button1',
              onPressed: () {
                userid = tasktestingNotifier.currentTaskTesting.userid;
                getOtherUser(authNotifier, tasktestingNotifier);
                getOtherComment(authNotifier, commentNotifier, userid);
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return SpUserManagementScreen(
                    isView: true,
                  );
                }));
              },
              icon: Icon(Icons.people_rounded),
              label: Text("View"),
              foregroundColor: Colors.white,
            ),
            SizedBox(height: 5),
            FloatingActionButton.extended(
              heroTag: 'Button2',
              onPressed: () {
                getChatRoomFromChatButton(chatNotifier, tasktestingNotifier);
                //this userid is the customer id and task id
                //userid = tasktestingNotifier.currentTaskTesting.userid;
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return SpChatRoomScreen(
                    isChat: true,
                  );
                }));
              },
              icon: Icon(Icons.chat),
              label: Text('Chat'),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ],
        ));
  }
}
