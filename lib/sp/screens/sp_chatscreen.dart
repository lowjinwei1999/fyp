import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fyp_project/notifier/chat_notifiier.dart';
import 'package:fyp_project/screens/chatroomlist_screen.dart';
import 'package:fyp_project/sp/screens/sp_chatroomlistscreen.dart';
import 'package:fyp_project/sp/widgets/sp_appdrawer.dart';
import 'package:fyp_project/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

import '../../api/task_api.dart';

class SpChatScreen extends StatefulWidget {
  static const routeName = '/sp-chat-screen';
  @override
  _SpChatScreenState createState() => _SpChatScreenState();
}

class _SpChatScreenState extends State<SpChatScreen> {
  void initState() {
    ChatNotifier chatNotifier = Provider.of<ChatNotifier>(context,listen: false);
    getChatRoom(chatNotifier);
    setState(() {
        //  isLoading = false;
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ChatNotifier chatNotifier =
    //     Provider.of<ChatNotifier>(context);

         return Scaffold(
        appBar: AppBar( 
          title: Text(
            'Chat',
            //authNotifier.userList[0].name != null ? authNotifier.userList[0].name: "Feed",
          ),
          actions: [],
        ),
        drawer: SpAppDrawer(),
        body: SpChatRoomListScreen()
      );
  }
}
