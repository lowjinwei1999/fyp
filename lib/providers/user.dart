import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  String email;
  String password;
  String name;
  String uid;
  String address;
  String tel;
  String bankname;
  String accountnumber;
  String holdername;
  String personincharge;
  String servicearea;
  String accounttype;
  String imageUrl;
  String token;

  User();

  User.fromMap(Map<String,dynamic>data)
  {
     email = data['email'];
     password = data['password'];
     name = data['name'];
     uid = data['uid'];
     address = data['address'];
     tel = data['tel'];
     bankname = data['bankname'];
     accountnumber = data['accountnumber'];
     holdername = data['holdername'];
     personincharge = data['personincharge'];
     servicearea = data['servicearea'];
     accounttype = data['accounttype'];
     imageUrl = data['imageUrl'];
     token = data['token'];
  }

   Map<String,dynamic> toMap(){
     return{
       'email':email,
       'password':password,
       'name':name,
       'uid':uid,
       'address':address,
       'tel':tel,
       'bankname':bankname,
       'accountnumber':accountnumber,
       'holdername':holdername,
       'personincharge':personincharge,
       'servicearea':servicearea,
       'accounttype':accounttype,
       'imageUrl':imageUrl,
       'token':token,
     };
   }
}