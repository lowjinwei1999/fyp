
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fyp_project/api/task_api.dart';
import 'package:fyp_project/providers/chat.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp_project/notifier/auth_notifier.dart';
import 'package:fyp_project/notifier/chat_notifiier.dart';
import 'package:fyp_project/notifier/task_testing_notifier.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class NewMessages extends StatefulWidget {
  @override
  _NewMessagesState createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
//button on enable to press when there are message entered
  var _enteredMessage = '';
  File _imageFile;
  ChatRoom _chatRoom= ChatRoom();
//clear the textfield after send messagea
  final _controller = new TextEditingController();

  void _sendMessage({String imageUrl}) async {
    FocusScope.of(context).unfocus();
    TaskTestingNotifier tasktestingNotifier =
        Provider.of<TaskTestingNotifier>(context, listen: false);
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    ChatNotifier chatNotifier =
        Provider.of<ChatNotifier>(context, listen: false);
    //access the currently login user
    final user = await FirebaseAuth.instance.currentUser();
    //fetch whenever we create a new message
    final userData =
        await Firestore.instance.collection('users').document(user.uid).get();

    if (chatNotifier.currentChatRoom == null &&
        chatNotifier.currentchatroomfromchatbuttonList.isEmpty) {
      if (userData['accounttype'] != 'Customer') {
        Firestore.instance
            .collection('chatroom')
            .document(tasktestingNotifier.currentTaskTesting.id)
            .setData({
          'updatedAt': Timestamp.now(),
          'spid': userData['uid'],
          'spname': userData['name'],
          'spimage': userData['imageUrl'],
          'customerid': chatNotifier.currentChatRoom == null
              ? tasktestingNotifier.currentTaskTesting.userid
              : chatNotifier.currentChatRoom.customerid,
          'customername': chatNotifier.currentChatRoom == null
              ? tasktestingNotifier.currentTaskTesting.customername
              : chatNotifier.currentChatRoom.customername,
          'customerimage': chatNotifier.currentChatRoom == null
              ? tasktestingNotifier.currentTaskTesting.customerimage
              : chatNotifier.currentChatRoom.customerimage,
          'taskid': chatNotifier.currentChatRoom == null
              ? tasktestingNotifier.currentTaskTesting.id
              : chatNotifier.currentChatRoom.taskid,
          'latestmessage': imageUrl != null ? '[ Photo ]' : _enteredMessage,
          'chatroomid':Uuid().v4(),
          'customerseen':'No',
          'spseen':'Yes',


          //uid is the current id which hold by firebase
        });
      } else {
        print('this1');
        Firestore.instance
            .collection('chatroom')
            .document(tasktestingNotifier.currentTaskTesting.id)
            .setData({
          'updatedAt': Timestamp.now(),
          'spid': tasktestingNotifier.currentTaskTesting.spid,
          'spname': tasktestingNotifier.currentTaskTesting.spname,
          'spimage': tasktestingNotifier.currentTaskTesting.spimage,
          'customerid': chatNotifier.currentChatRoom == null
              ? tasktestingNotifier.currentTaskTesting.userid
              : chatNotifier.currentChatRoom.customerid,
          'customername': chatNotifier.currentChatRoom == null
              ? tasktestingNotifier.currentTaskTesting.customername
              : chatNotifier.currentChatRoom.customername,
          'customerimage': chatNotifier.currentChatRoom == null
              ? tasktestingNotifier.currentTaskTesting.customerimage
              : chatNotifier.currentChatRoom.customerimage,
          'taskid': chatNotifier.currentChatRoom == null
              ? tasktestingNotifier.currentTaskTesting.id
              : chatNotifier.currentChatRoom.taskid,
          'latestmessage': imageUrl != null ? '[ Photo ]' : _enteredMessage,
          'chatroomid':Uuid().v4(),
          'spseen':'No',
          'customerseen':'Yes',

          //uid is the current id which hold by firebase
        });
      }

      Firestore.instance
          .collection('chatroom')
          .document(chatNotifier.currentChatRoom == null
              ? tasktestingNotifier.currentTaskTesting.id
              : chatNotifier.currentChatRoom.taskid)
          .collection('chatlist')
          .document()
          .setData({
        'text': imageUrl == null ? _enteredMessage : imageUrl,
        'createdAt': Timestamp.now(),
        'uid': user.uid,
        'name': userData['name'],
        'imageUrl': userData['imageUrl'],
        'documenttype': imageUrl == null ? 'text' : 'image',
      });

      //push notification
      if (userData['accounttype'] == 'Customer') {
        CollectionReference feedRef = Firestore.instance
            .collection('feed')
            .document(chatNotifier.currentChatRoom == null
                ? tasktestingNotifier.currentTaskTesting.spid
                : chatNotifier.currentChatRoom.spid)
            .collection('feedItems');
        feedRef.add({
          'type': imageUrl == null ? 'sendchat' : 'sendimage',
          'feedDate': Timestamp.now(),
          'FromId': user.uid,
          'FromName': userData['name'],
          'FromUrl': userData['imageUrl'],
          'ToId': chatNotifier.currentChatRoom == null
              ? tasktestingNotifier.currentTaskTesting.spid
              : chatNotifier.currentChatRoom.spid,
          'text': imageUrl == null ? _enteredMessage : imageUrl,
          
        });
      } else {
        CollectionReference feedRef = Firestore.instance
            .collection('feed')
            .document(chatNotifier.currentChatRoom == null
                ? tasktestingNotifier.currentTaskTesting.userid
                : chatNotifier.currentChatRoom.customerid)
            .collection('feedItems');
        feedRef.add({
          'type': imageUrl == null ? 'sendchat' : 'sendimage',
          'feedDate': Timestamp.now(),
          'FromId': user.uid,
          'FromName': userData['name'],
          'FromUrl': userData['imageUrl'],
          'ToId': chatNotifier.currentChatRoom == null
              ? tasktestingNotifier.currentTaskTesting.userid
              : chatNotifier.currentChatRoom.customerid,
          'text': imageUrl == null ? _enteredMessage : imageUrl,
        });
      }
    }

//
    else if (chatNotifier.currentchatroomfromchatbuttonList.isNotEmpty) { 
      print('this2');
      Firestore.instance
          .collection('chatroom')
          .document(chatNotifier.currentchatroomfromchatbuttonList[0].taskid)
          .collection('chatlist')
          .document()
          .setData({
        'text': imageUrl == null ? _enteredMessage : imageUrl,
        'createdAt': Timestamp.now(),
        'uid': user.uid,
        'name': userData['name'],
        'imageUrl': userData['imageUrl'],
        'documenttype': imageUrl == null ? 'text' : 'image'
      });
      if(userData['accounttype']=='Customer'){
         Firestore.instance
          .collection('chatroom')
          .document(chatNotifier.currentchatroomfromchatbuttonList[0].taskid)
          .updateData({
        'updatedAt': Timestamp.now(),
        'latestmessage': imageUrl != null ? '[Photo]' : _enteredMessage,
       'spseen':'No',
        
      });
      }else{
         Firestore.instance
          .collection('chatroom')
          .document(chatNotifier.currentchatroomfromchatbuttonList[0].taskid)
          .updateData({
        'updatedAt': Timestamp.now(),
        'latestmessage': imageUrl != null ? '[Photo]' : _enteredMessage,
       'customerseen':'No',
        
      });
      }
     

//push notification
      if (userData['accounttype'] == 'Customer') {
        CollectionReference feedRef = Firestore.instance
            .collection('feed')
            .document(chatNotifier.currentchatroomfromchatbuttonList[0].spid)
            .collection('feedItems');
        feedRef.add({
          'type': imageUrl == null ? 'sendchat' : 'sendimage',
          'feedDate': Timestamp.now(),
          'FromId': user.uid,
          'FromName': userData['name'],
          'FromUrl': userData['imageUrl'],
          'ToId': chatNotifier.currentchatroomfromchatbuttonList[0].spid,
          'text': imageUrl == null ? _enteredMessage : imageUrl,
        });
      } else {
        print('this3');
        CollectionReference feedRef = Firestore.instance
            .collection('feed')
            .document(
                chatNotifier.currentchatroomfromchatbuttonList[0].customerid)
            .collection('feedItems');
        feedRef.add({
          'type': imageUrl == null ? 'sendchat' : 'sendimage',
          'feedDate': Timestamp.now(),
          'FromId': user.uid,
          'FromName': userData['name'],
          'FromUrl': userData['imageUrl'],
          'ToId': chatNotifier.currentchatroomfromchatbuttonList[0].customerid,
          'text': imageUrl == null ? _enteredMessage : imageUrl,
        });
      }
    } else {
      Firestore.instance
          .collection('chatroom')
          .document(chatNotifier.currentChatRoom == null
              ? tasktestingNotifier.currentTaskTesting.id
              : chatNotifier.currentChatRoom.taskid)
          .collection('chatlist')
          .document()
          .setData({
        'text': imageUrl == null ? _enteredMessage : imageUrl,
        'createdAt': Timestamp.now(),
        'uid': user.uid,
        'name': userData['name'],
        'imageUrl': userData['imageUrl'],
        'documenttype': imageUrl == null ? 'text' : 'image'
      });

    if(userData['accounttype']=='Customer'){
         Firestore.instance
          .collection('chatroom')
          .document(chatNotifier.currentChatRoom == null
              ? tasktestingNotifier.currentTaskTesting.id
              : chatNotifier.currentChatRoom.taskid)
          .updateData({
        'updatedAt': Timestamp.now(),
        'latestmessage': imageUrl != null ? '[Photo]' : _enteredMessage,
       'spseen':'No',
        
      });
      }else{
         Firestore.instance
          .collection('chatroom')
          .document(chatNotifier.currentChatRoom == null
              ? tasktestingNotifier.currentTaskTesting.id
              : chatNotifier.currentChatRoom.taskid)
          .updateData({
        'updatedAt': Timestamp.now(),
        'latestmessage': imageUrl != null ? '[Photo]' : _enteredMessage,
       'customerseen':'No',
        
      });
      }


      //push notification
      if (userData['accounttype'] == 'Customer') {
        CollectionReference feedRef = Firestore.instance
            .collection('feed')
            .document(chatNotifier.currentChatRoom == null
                ? tasktestingNotifier.currentTaskTesting.spid
                : chatNotifier.currentChatRoom.spid)
            .collection('feedItems');
        feedRef.add({
          'type': imageUrl == null ? 'sendchat' : 'sendimage',
          'feedDate': Timestamp.now(),
          'FromId': user.uid,
          'FromName': userData['name'],
          'FromUrl': userData['imageUrl'],
          'ToId': chatNotifier.currentChatRoom == null
              ? tasktestingNotifier.currentTaskTesting.spid
              : chatNotifier.currentChatRoom.spid,
          'text': imageUrl == null ? _enteredMessage : imageUrl,
        });
      } else {
        CollectionReference feedRef = Firestore.instance
            .collection('feed')
            .document(chatNotifier.currentChatRoom == null
                ? tasktestingNotifier.currentTaskTesting.userid
                : chatNotifier.currentChatRoom.customerid)
            .collection('feedItems');
        feedRef.add({
          'type': imageUrl == null ? 'sendchat' : 'sendimage',
          'feedDate': Timestamp.now(),
          'FromId': user.uid,
          'FromName': userData['name'],
          'FromUrl': userData['imageUrl'],
          'ToId': chatNotifier.currentChatRoom == null
              ? tasktestingNotifier.currentTaskTesting.userid
              : chatNotifier.currentChatRoom.customerid,
          'text': imageUrl == null ? _enteredMessage : imageUrl,
        });
      }
    }
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    _getLocalImage() async {
      File imageFile = await ImagePicker.pickImage(
          source: ImageSource.gallery, imageQuality: 100, maxWidth: 400);

      if (imageFile != null) {
        setState(() async {
          _imageFile = imageFile;
          print('Uploading Image');

          var fileExtension = path.extension(_imageFile.path);
          print(fileExtension);

          //create unique id
          var uuid = Uuid().v4();

          //accessfirebase storage
          final StorageReference firebaseStorageRef = FirebaseStorage.instance
              .ref()
              .child('chats/images/$uuid$fileExtension');
          await firebaseStorageRef
              .putFile(_imageFile)
              .onComplete
              .catchError((onError) {
            print(onError);
            return false;
          });

          String url = await firebaseStorageRef.getDownloadURL();
          print('download url: $url');
          _sendMessage(imageUrl: url);
        });
      }
    }

    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Send a mesages...'),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          _controller.text.isEmpty
              ? IconButton(
                  color: Theme.of(context).primaryColor,
                  icon: Icon(Icons.image),
                  onPressed:
                      _enteredMessage.trim().isNotEmpty ? null : _getLocalImage)
              : IconButton(
                  color: Theme.of(context).primaryColor,
                  icon: Icon(Icons.send),
                  onPressed:
                      _enteredMessage.trim().isEmpty ? null : _sendMessage),
        ],
      ),
    );
  }
}
