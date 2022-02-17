import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fyp_project/api/task_api.dart';
import 'package:fyp_project/chats/message_bubble.dart';
import 'package:fyp_project/notifier/chat_notifiier.dart';
import 'package:fyp_project/notifier/task_testing_notifier.dart';
import 'package:fyp_project/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

import '../chats/messages.dart';
import '../chats/new_messages.dart';

class ChatRoomScreen extends StatefulWidget {
  static const routeName = '/chatroom-screen';
  final bool isChat;

  ChatRoomScreen({@required this.isChat});
  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  var isInit = true;
  var isLoading;

  @override
  void initState()  {
    

    // final fbm = FirebaseMessaging();

    // fbm.requestNotificationPermissions();

    // fbm.configure(onMessage: (msg) {
    //   print(msg);
    //   return;
    // }, onLaunch: (msg) {
    //   print(msg);
    //   return;
    // }, onResume: (msg) {
    //   print(msg);
    //   return;
    // });

    // fbm.getToken().then((deviceToken) {
    //   print('Deivce token: $deviceToken');
      
     
    // });

    //get token to send the notification
    //fbm.getToken();
    // fbm.subscribeToTopic('chatfornotification');

    if (isInit) {
      setState(() {
        isLoading = true;
      });
      if (widget.isChat) {
        ChatNotifier chatNotifier =
            Provider.of<ChatNotifier>(context, listen: false);
        TaskTestingNotifier tasktestingNotifier =
            Provider.of<TaskTestingNotifier>(context, listen: false);
        getChatRoomFromChatButton(chatNotifier, tasktestingNotifier);
        setState(() {
          isLoading = false;
        });
      }
    }
    isInit = false;
    super.initState();
  }

  Widget build(BuildContext context) {
    ChatNotifier chatNotifier =
        Provider.of<ChatNotifier>(context, listen: true);
    TaskTestingNotifier tasktestingNotifier =
        Provider.of<TaskTestingNotifier>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        actions: [],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            widget.isChat
                ? Expanded(
                    child: FutureBuilder(
                        future: FirebaseAuth.instance.currentUser(),
                        builder: (ctx, futureSnapshot) {
                          if (futureSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return StreamBuilder(
                              //retrieve the snapshot of chat message from firebase
                              stream: chatNotifier
                                      .currentchatroomfromchatbuttonList.isEmpty
                                  ? Firestore.instance
                                      .collection('chatroom')
                                      .document(tasktestingNotifier
                                          .currentTaskTesting.id)
                                      .collection('chatlist')
                                      .orderBy('createdAt', descending: true)
                                      .snapshots()
                                  : Firestore.instance
                                      .collection('chatroom')
                                      .document()
                                      .collection('chatlist')
                                      .orderBy('createdAt', descending: true)
                                      .snapshots(),
                              builder: (ctx, chatSnapshot) {
                                if (chatSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                final chatDocs = chatSnapshot.data.documents;
                                return ListView.builder(
                                  reverse: true,
                                  itemCount: chatSnapshot.data.documents.length,
                                  itemBuilder: (ctx, index) => MessageBubble(
                                     chatDocs[index]['documenttype'],
                                      chatDocs[index]['text'],
                                      chatDocs[index]['name'],
                                      chatDocs[index]['imageUrl'],
                                      chatDocs[index]['uid'] ==
                                          futureSnapshot.data.uid,
                                      key:
                                          ValueKey(chatDocs[index].documentID)),

                                  //Text(chatDocs[index]['text']),
                                );
                              });
                        }))
                : Messages(),
            NewMessages(),
          ],
        ),
      ),
    );
  }
}
