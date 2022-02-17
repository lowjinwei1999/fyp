import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:fyp_project/providers/chat.dart';

class ChatNotifier with ChangeNotifier
{
  List<ChatRoom> _chatroomList = [];

  List<ChatRoom> _currentchatroomfromchatbuttonList = [];

  ChatRoom _currentChatRoom;

  UnmodifiableListView<ChatRoom> get chatroomList =>
      UnmodifiableListView(_chatroomList);

      UnmodifiableListView<ChatRoom> get currentchatroomfromchatbuttonList =>
      UnmodifiableListView(_currentchatroomfromchatbuttonList);

 ChatRoom get currentChatRoom => _currentChatRoom;

    set chatroomList(List<ChatRoom> chatroomList) {
    _chatroomList = chatroomList;
    //notify the apps that have change
    notifyListeners();
  }

  set currentChatRoom(ChatRoom chatroom) {
    _currentChatRoom = chatroom;
    //notify the apps that have change
    notifyListeners();
  }

   set currentchatroomfromchatbuttonList(List<ChatRoom> currentchatroomfromchatbuttonList) {
    _currentchatroomfromchatbuttonList = currentchatroomfromchatbuttonList;
    //notify the apps that have change
    notifyListeners();
  }

clearchatroomlist() {
   _chatroomList.clear();
   _currentchatroomfromchatbuttonList.clear();
   _currentChatRoom = null;

  }

  addChat(ChatRoom chatRoom) {
    final prodIndex = _chatroomList.indexWhere((_chatroom) => _chatroom.chatroomid == chatRoom.chatroomid);
    if(prodIndex>=0){
    _chatroomList[prodIndex] = chatRoom;
    notifyListeners();
    }else{
    _chatroomList.add(chatRoom);
    notifyListeners();
    }
  }
}