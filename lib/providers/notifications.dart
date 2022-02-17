import 'package:cloud_firestore/cloud_firestore.dart';

class Notifications{
  String fromid;
  String fromname;
  String fromurl;
  String toid;
  Timestamp feeddate;
  String content;
  String type;

  Notifications();

  Notifications.fromMap(Map<String,dynamic>data)
  {
     fromid = data['FromId'];
     fromname = data['FromName'];
     fromurl = data['FromUrl'];
     toid = data['ToId'];
     feeddate = data['feedDate'];
     content = data['content'];
     type = data['type'];
     
  }

   Map<String,dynamic> toMap(){
     return{
       'fromid':fromid,
       'fromname':fromname,
       'fromurl':fromurl,
       'toid':toid,
       'feeddate':feeddate,
       'content':content,
       'type':type,
      
     };
   }
}
