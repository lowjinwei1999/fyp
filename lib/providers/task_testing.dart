

class TaskTesting{
   String id;
   String taskname;
   String category;
   double price;
   double additionalprice;
   String description;
   String address;
   String state;
   String district;
   String time;
   String date;
   String userid; 
   String customername;
   String customerimage;
   String spid;
   String spname;
   String spimage;
   String requestby;
   String status;
   String imageUrl;
   String paymentmethod;
   String statuscustomer;
   String statussp;

   TaskTesting();

   TaskTesting.fromMap(Map<String,dynamic>data)
   {
     id = data['id'];
     taskname = data['taskname'];
     category = data['category'];
     price = data['price'];
     additionalprice = data['additionalprice'];
     description = data['description'];
     address = data['address'];
     state = data['state'];
     district = data['district'];
     time = data['time'];
     date = data['date'];
     userid = data['userid'];
     customername = data['customername'];
     customerimage = data['customerimage'];
     spid = data['spid'];
     spname = data['spname'];
     spimage = data['spimage'];
     requestby = data['requestby'];
     status = data['status'];
     imageUrl = data['imageUrl'];
     paymentmethod = data['paymentmethod'];
     statuscustomer = data['statuscustomer'];
     statussp=data['statussp'];
     //the name after the data should match the field name from db
   } 

   //use for upload the task, uploaded in a map
   Map<String,dynamic> toMap(){
     return{
       'id':id,
       'taskname':taskname,
       'category':category,
       'price':price,
       'additionalprice':additionalprice,
       'description':description,
       'address':address,
       'state':state,
       'district':district,
       'time':time,
       'date':date,
       'userid':userid,
       'customername':customername,
       'customerimage':customerimage,
       'spid':spid,
       'spname':spname,
       'spimage':spimage,
       'requestby':requestby,
       'status':status,
       'imageUrl':imageUrl,
       'paymentmethod':paymentmethod,
       'statuscustomer':statuscustomer,
       'statussp':statussp,
     };
   }

}