import 'package:cloud_firestore/cloud_firestore.dart';

class Comment
{
  String id;
  String ownerid;
  String commentpeopleid;
  String commentpeoplename;
  String imageUrl;
  Timestamp createdAt;
  String text;

  Comment();

  Comment.fromMap(Map<String,dynamic>data)
  {
     id = data['id'];
     ownerid = data['ownerid'];
     commentpeopleid = data['commentpeopleid'];
     commentpeoplename = data['commentpeoplename'];
     imageUrl = data['imageUrl'];
     text = data['text'];
     createdAt = data['createdAt'];
  }

   Map<String,dynamic> toMap(){
     return{
       'id':id,
       'ownerid':ownerid,
       'commentpeopleid':commentpeopleid,
       'commentpeoplename':commentpeoplename,
       'imageUrl':imageUrl,
       'text':text,
       'createdAt':createdAt,
     };
   }
}