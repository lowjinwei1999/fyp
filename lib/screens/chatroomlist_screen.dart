import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp_project/api/task_api.dart';
import 'package:fyp_project/notifier/chat_notifiier.dart';
import 'package:fyp_project/screens/chatroom_screen.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as tAgo;

class ChatRoomListScreen extends StatefulWidget {
  @override
  _ChatRoomListScreenState createState() => _ChatRoomListScreenState();
}

class _ChatRoomListScreenState extends State<ChatRoomListScreen> {
  @override
  @override
  Widget build(BuildContext context) {
    ChatNotifier chatNotifier = Provider.of<ChatNotifier>(context);

    Future<void> _refreshList() async {
      getChatRoom(chatNotifier);
    }

    return RefreshIndicator(
      child: StreamBuilder(
          stream:
              Firestore.instance.collection('chatroom').document().snapshots(),
          builder: (context, snapshots) {
            if (snapshots.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    chatNotifier.currentChatRoom =
                        chatNotifier.chatroomList[index];
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return ChatRoomScreen(
                        isChat: false,
                      );
                    })).then((_) => _refreshList());
                  },
                  // => Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (_) => ChatScreen(
                  //       user: chat.sender,
                  //     ),
                  //   ),

                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          chatNotifier.chatroomList[index].customerseen == 'No'
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
                              // chat.unread
                              //     ? BoxDecoration(
                              //         borderRadius: BorderRadius.all(Radius.circular(40)),
                              //         border: Border.all(
                              //           width: 2,
                              //           color: Theme.of(context).primaryColor,
                              //         ),
                              //         // shape: BoxShape.circle,
                              //         boxShadow: [
                              //           BoxShadow(
                              //             color: Colors.grey.withOpacity(0.5),
                              //             spreadRadius: 2,
                              //             blurRadius: 5,
                              //           ),
                              //         ],
                              //       )
                              // :
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
                              chatNotifier.chatroomList[index].spimage != null
                                  ? chatNotifier.chatroomList[index].spimage
                                  : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.68,
                          padding: EdgeInsets.only(
                            left: 20,
                          ),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        chatNotifier.chatroomList[index].spname,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      // chat.sender.isOnline
                                      //     ? Container(
                                      //         margin: const EdgeInsets.only(left: 5),
                                      //         width: 7,
                                      //         height: 7,
                                      //         decoration: BoxDecoration(
                                      //           shape: BoxShape.circle,
                                      //           color: Theme.of(context).primaryColor,
                                      //         ),
                                      //       )
                                      //     : Container(
                                      //         child: null,
                                      //       ),
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
                                  chatNotifier
                                      .chatroomList[index].latestmessage,
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
              // separatorBuilder: (BuildContext context, int index) {
              //   return Divider(
              //     color: Colors.transparent,
              //   );
              // },
            );
          }),
      onRefresh: _refreshList,
    );
  }
}
