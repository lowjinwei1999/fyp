

import 'package:cloud_firestore/cloud_firestore.dart';

class Payment{
   String paymentid;
   String taskid;
   String taskname;
   double totalamount;
   String customerid;
   String customername;
   String spid;
   String spname;
   Timestamp completedAt;
   String paymentmethod;
   String status;
   double totalpay;
   double platformfee;

   Payment();

   Payment.fromMap(Map<String,dynamic>data)
   {
     paymentid = data['paymentid'];
     taskid = data['taskid'];
     taskname = data['taskname'];
     totalamount = data['totalamount'];
     customerid = data['customerid'];
     customername = data['customername'];
     spid = data['spid'];
     spname = data['spname'];
     completedAt = data['completedAt'];
     paymentmethod = data['paymentmethod'];
     status = data['status'];
     totalpay = data['totalpay'];
     platformfee = data['platformfee'];
     //the name after the data should match the field name from db
   } 

   //use for upload the task, uploaded in a map
   Map<String,dynamic> toMap(){
     return{
       'paymentid':paymentid,
       'taskid':taskid,
       'taskname':taskname,
       'totalamount':totalamount,
       'customerid':customerid,
       'customername':customername,
       'spid':spid,
       'spname':spname,
       'completedAt':completedAt,
       'paymentmethod':paymentmethod,
       'status':status,
       'totalpay':totalpay,
       'platformfee':platformfee,
     };
   }

}