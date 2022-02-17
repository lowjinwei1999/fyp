import 'package:cloud_firestore/cloud_firestore.dart';

class Chat{
  String name;
  String senderid;
  String receiverid;
  String taskid;
  String text;
  String imageUrl;
  String createdAt;

  Chat();

  Chat.fromMap(Map<String,dynamic>data)
  {
     name = data['name'];
     senderid = data['senderuid'];
     receiverid = data['receiverid'];
     taskid = data['taskid'];
     text = data['text'];
     imageUrl = data['imageUrl'];
     createdAt = data['createdAt'];
     
  }

   Map<String,dynamic> toMap(){
     return{
       'name':name,
       'senderid':senderid,
       'receiverid':receiverid,
       'taskid':taskid,
       'text':text,
       'imageUrl':imageUrl,
       'createdAt':createdAt,
      
     };
   }
}

class ChatRoom{
  String customerid;
  String spid;
  String taskid;
  String spname;
  String customername;
  String customerimage;
  String spimage;
  Timestamp updatedAt;
  String latestmessage;
  String customerseen;
  String spseen;
  String chatroomid;
  //String pushToken;

  ChatRoom();

  ChatRoom.fromMap(Map<String,dynamic>data)
  {
     customerid = data['customerid'];
     spid = data['spid'];
     taskid = data['taskid'];
     customerimage = data['customerimage'];
     spimage = data['spimage'];
     updatedAt = data['updatedAt'];
     spname = data['spname'];
     customername = data['customername'];
     latestmessage = data['latestmessage'];
     customerseen = data['customerseen'];
     spseen = data['spseen'];
     chatroomid = data['chatroomid'];
    // pushToken = data['pushToken'];
     
  }

   Map<String,dynamic> toMap(){
     return{
       'customerid':customerid,
       'spid':spid,
       'taskid':taskid,
       'spimage':spimage,
       'customerimage':customerimage,
       'updatedAt':updatedAt,
       'spname':spname,
       'customername':customername,
       'latestmessage' : latestmessage,
       'customerseen': customerseen,
       'spseen': spseen,
       'chatroomid':chatroomid,
      // 'pushToken':pushToken,
      
     };
   }
}


