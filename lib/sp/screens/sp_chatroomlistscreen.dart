import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp_project/api/task_api.dart';
import 'package:fyp_project/notifier/chat_notifiier.dart';
import 'package:fyp_project/sp/screens/sp_chatroomscreen.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as tAgo;

class SpChatRoomListScreen extends StatefulWidget {
  @override
  _SpChatRoomListScreenState createState() => _SpChatRoomListScreenState();
}

class _SpChatRoomListScreenState extends State<SpChatRoomListScreen> {
  @override
  Widget build(BuildContext context) {
    ChatNotifier chatNotifier = Provider.of<ChatNotifier>(context);

    Future<void> _refreshList() async {
      getChatRoom(chatNotifier);
    }

    return StreamBuilder(
      stream:  Firestore.instance
                    .collection('chatroom')
                    .document().snapshots(),
                    
         builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
        return RefreshIndicator(
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(onTap: () {
                chatNotifier.currentChatRoom =
                          chatNotifier.chatroomList[index];
                 Navigator.of(context)
                          .push(MaterialPageRoute(builder: (BuildContext context) {
                        return SpChatRoomScreen(isChat: false,);
                      })).then((_)=>_refreshList());
                
              },

              child: Container(
                 decoration: BoxDecoration(
                      color:
                          chatNotifier.chatroomList[index].spseen == 'No'
                              ? Colors.deepPurple[300]
                              : Colors.white,
                    ),
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
                          chatNotifier.chatroomList[index].customerimage != null
                              ? chatNotifier.chatroomList[index].customerimage
                              : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.65,
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
                                    chatNotifier.chatroomList[index].customername,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                tAgo.format(chatNotifier
                                                  .chatroomList[index].updatedAt
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
                               chatNotifier.chatroomList[index].latestmessage,
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
              ),
              );
            },
            itemCount: chatNotifier.chatroomList.length,
          ),
          onRefresh: _refreshList,
        );
      }
    );
  }
}

