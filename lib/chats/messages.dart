import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp_project/notifier/auth_notifier.dart';
import 'package:fyp_project/notifier/chat_notifiier.dart';
import 'package:provider/provider.dart';

import 'message_bubble.dart';

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  bool isLoading = true;
  void initState() {
    if(isLoading)
    {
      updateRead();
    }
    setState(() {
      isLoading=false;
    });
    super.initState();
  }

  updateRead() async {
    ChatNotifier chatNotifier = Provider.of<ChatNotifier>(context,listen: false);
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context,listen:false);
  if(authNotifier.userList[0].accounttype=='Customer')
  {
 await Firestore.instance
        .collection('chatroom')
        .document(chatNotifier.currentChatRoom.taskid)
        .updateData({'customerseen': 'Yes'});
  }else{
await Firestore.instance
        .collection('chatroom')
        .document(chatNotifier.currentChatRoom.taskid)
        .updateData({'spseen':'Yes'});
  }
    
  }

  @override
  Widget build(BuildContext context) {
    ChatNotifier chatNotifier = Provider.of<ChatNotifier>(context);
    return Expanded(
      child: FutureBuilder(
          future: FirebaseAuth.instance.currentUser(),
          builder: (ctx, futureSnapshot) {
            if (futureSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return StreamBuilder(
                //retrieve the snapshot of chat message from firebase
                stream: chatNotifier.currentChatRoom != null
                    ? Firestore.instance
                        .collection('chatroom')
                        .document(chatNotifier.currentChatRoom.taskid)
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
                  if (chatSnapshot.connectionState == ConnectionState.waiting) {
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
                        chatDocs[index]['uid'] == futureSnapshot.data.uid,
                        key: ValueKey(chatDocs[index].documentID)),

                    //Text(chatDocs[index]['text']),
                  );
                });
          }),
    );
  }
}
