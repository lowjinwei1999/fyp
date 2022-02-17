import 'package:flutter/material.dart';
import 'package:fyp_project/api/task_api.dart';
import 'package:fyp_project/notifier/notification_notifier.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as tAgo;

class NotificationScreenList extends StatefulWidget {
  @override
  _NotificationScreenListState createState() => _NotificationScreenListState();
}

class _NotificationScreenListState extends State<NotificationScreenList> {
  @override
  Widget build(BuildContext context) {
     NotificationNotifier notificationNotifier = Provider.of<NotificationNotifier>(context);

    Future<void> _refreshList() async {
      getNotification(notificationNotifier);
    }

                    
       
        return RefreshIndicator(
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {

             return Container(
    
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(2),
                      decoration:
                          BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(
                          notificationNotifier.notificationList[index].fromurl != null
                              ? notificationNotifier.notificationList[index].fromurl
                              : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.66,
                      padding: EdgeInsets.only(
                        left: 20,
                      ),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                   notificationNotifier.notificationList[index].fromname,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                tAgo.format(notificationNotifier
                                                  .notificationList[index].feeddate
                                                  .toDate()),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                               notificationNotifier.notificationList[index].content,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
              
            },
            itemCount: notificationNotifier.notificationList.length,
          ),
          onRefresh: _refreshList,
        );
      
    
  }
}