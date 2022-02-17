import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp_project/notifier/chat_notifiier.dart';
import 'package:fyp_project/notifier/comment_notifier.dart';
import 'package:fyp_project/notifier/notification_notifier.dart';
import 'package:fyp_project/notifier/payment_notifier.dart';
import 'package:fyp_project/providers/chat.dart';
import 'package:fyp_project/providers/comment.dart';
import 'package:fyp_project/providers/notifications.dart';
import 'package:fyp_project/providers/payment.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/user.dart';
import '../notifier/auth_notifier.dart';
import 'package:fyp_project/notifier/task_testing_notifier.dart';
import 'package:fyp_project/providers/task_testing.dart';

//Authentication
Future signout(AuthNotifier authNotifier) async {
  await FirebaseAuth.instance
      .signOut()
      .catchError((error) => print(error.code));

  authNotifier.setUser(null);
}

//Initialize User
initializeCurrentUser(AuthNotifier authNotifier) async {
  FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

  if (firebaseUser != null) {
    authNotifier.setUser(firebaseUser);
  }
}

//get the login user info
getUserData(AuthNotifier authNotifier) async {
  var user = await FirebaseAuth.instance.currentUser();
  QuerySnapshot getuserdata =
      await Firestore.instance.collection('users').getDocuments();
  List<User> _userList = [];
  getuserdata.documents.forEach((document) {
    if (document['uid'] == user.uid) {
      // pass into the task_testing_notifier.dart list
      User user = User.fromMap(document.data);
      _userList.add(user);
    }
  });
  authNotifier.userList = _userList;
}

//getOtherProfile use in sp_taskdetailscreen
getOtherUser(
    AuthNotifier authNotifier, TaskTestingNotifier taskTestingNotifier) async {
  var otheruserid = taskTestingNotifier.currentTaskTesting.userid;
  QuerySnapshot getuserdata =
      await Firestore.instance.collection('users').getDocuments();

  List<User> _otherUserList = [];
  getuserdata.documents.forEach((document) {
    if (document['uid'] == otheruserid) {
      // pass into the task_testing_notifier.dart list
      User user = User.fromMap(document.data);
      _otherUserList.add(user);
    }
  });
  authNotifier.otherUserList = _otherUserList;
}

//getOtherProfile use in sp_taskdetailscreen
getSpDataFromUser(
    AuthNotifier authNotifier, TaskTestingNotifier taskTestingNotifier) async {
  var otherspid = taskTestingNotifier.currentTaskTesting.spid;
  QuerySnapshot getuserdata =
      await Firestore.instance.collection('users').getDocuments();

  List<User> _otherUserList = [];
  getuserdata.documents.forEach((document) {
    if (document['uid'] == otherspid) {
      // pass into the task_testing_notifier.dart list
      User user = User.fromMap(document.data);
      _otherUserList.add(user);
    }
  });
  authNotifier.otherUserList = _otherUserList;
}

//update user info
updateUserAndImage(User user, File localFile, Function onUserUploaded) async {
  // print('run updateUserAndImage in taskapi.dart');
  if (localFile != null) {
    print('Uploading Image');

    var fileExtension = path.extension(localFile.path);
    //create unique id
    var uuid = Uuid().v4();
    //accessfirebase storage
    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('users/images/$uuid$fileExtension');
    await firebaseStorageRef
        .putFile(localFile)
        .onComplete
        .catchError((onError) {
      print(onError);
      return false;
    });

    String url = await firebaseStorageRef.getDownloadURL();
    print('download url: $url');
    _updateUser(user, onUserUploaded, imageUrl: url);
  } else {
    print('....skipping image uplaod');
    _updateUser(user, onUserUploaded);
  }
}

//update customer profile
_updateUser(User user, Function onUserUploaded, {String imageUrl}) async {
  print('update user method is run');
  CollectionReference userRef = Firestore.instance.collection('users');

  //FirebaseUser currentuser = await FirebaseAuth.instance.currentUser();
  if (imageUrl != null) {
    user.imageUrl = imageUrl;
  }
  //update this data with the id to this map
  await userRef.document(user.uid).updateData(user.toMap());
  print('imageurl is print here');
  print(imageUrl);

//when user edit profile image, chatroom also updated
  if (user.accounttype == 'Service Partner') {
    QuerySnapshot getchatroom =
        await Firestore.instance.collection('chatroom').getDocuments();
    getchatroom.documents.forEach((document) async {
      if (document['spid'] == user.uid) {
        await Firestore.instance
            .collection('chatroom')
            .document(document.documentID)
            .updateData({'spimage': imageUrl});

        QuerySnapshot getcommentdata = await Firestore.instance
            .collection('chatroom')
            .document(document.documentID)
            .collection('chatlist')
            .getDocuments();

        var data = document.documentID;

        getcommentdata.documents.forEach((document) async {
          if (document['uid'] == user.uid) {
            await Firestore.instance
                .collection('chatroom')
                .document(data)
                .collection('chatlist')
                .document(document.documentID)
                .updateData({'imageUrl': imageUrl});
          }
        });
      }
    });
  } else {
    QuerySnapshot getchatroom =
        await Firestore.instance.collection('chatroom').getDocuments();
    getchatroom.documents.forEach((document) async {
      if (document['customerid'] == user.uid) {
        await Firestore.instance
            .collection('chatroom')
            .document(document.documentID)
            .updateData({'customerimage': imageUrl});

        QuerySnapshot getcommentdata = await Firestore.instance
            .collection('chatroom')
            .document(document.documentID)
            .collection('chatlist')
            .getDocuments();

        var data = document.documentID;

        getcommentdata.documents.forEach((document) async {
          if (document['uid'] == user.uid) {
            await Firestore.instance
                .collection('chatroom')
                .document(data)
                .collection('chatlist')
                .document(document.documentID)
                .updateData({'imageUrl': imageUrl});
          }
        });
      }
    });
  }
  onUserUploaded(user);
}

//fetch task
getTask(TaskTestingNotifier tasktestingNotifier) async {
  var user = await FirebaseAuth.instance.currentUser();
  QuerySnapshot snapshot =
      await Firestore.instance.collection('tasks').getDocuments();
  //create a list
  List<TaskTesting> _tasktestingList = [];
  //loop through the task
  snapshot.documents.forEach((document) {
    if (document['userid'] == user.uid) {
      // pass into the task_testing_notifier.dart list
      TaskTesting tasktesting = TaskTesting.fromMap(document.data);
      _tasktestingList.add(tasktesting);
    }
  });
  tasktestingNotifier.tasktestingList = _tasktestingList;
}

//fetch 'pending' task
getTaskPending(TaskTestingNotifier tasktestingNotifier) async {
  QuerySnapshot snapshot =
      await Firestore.instance.collection('tasks').getDocuments();
  List<TaskTesting> _tasktestingList = [];

  //loop through the task
  snapshot.documents.forEach((document) {
    if (document['status'] == 'Pending' && document['requestby'] == null) {
      // pass into the task_testing_notifier.dart list
      TaskTesting tasktesting = TaskTesting.fromMap(document.data);
      _tasktestingList.add(tasktesting);
    }
  });
  tasktestingNotifier.tasktestingList = _tasktestingList;
}

//fetch 'accepted' task
getAcceptedTask(TaskTestingNotifier tasktestingNotifier) async {
  var user = await FirebaseAuth.instance.currentUser();
  QuerySnapshot snapshot =
      await Firestore.instance.collection('tasks').getDocuments();
  //create a list
  List<TaskTesting> _acceptedtasktestingList = [];

  //loop through the task
  snapshot.documents.forEach((document) {
    if (document['spid'] == user.uid) {
      // pass into the task_testing_notifier.dart list
      TaskTesting tasktesting = TaskTesting.fromMap(document.data);
      _acceptedtasktestingList.add(tasktesting);
    }
  });
  tasktestingNotifier.acceptedtasktestingList = _acceptedtasktestingList;
}

//get filterring/sorting task
getfilterandsortingTask(TaskTestingNotifier tasktestingNotifier,
    String pricearrangement, String category, String district) async {
  if (district == 'DEFAULT') {
    district = null;
  }
  if (category == 'DEFAULT') {
    category = null;
  }
  if (pricearrangement == 'Low to High') {
    QuerySnapshot snapshot = await Firestore.instance
        .collection('tasks')
        .orderBy('price')
        .getDocuments();
    List<TaskTesting> _tasktestingList = [];

    //loop through the task
    snapshot.documents.forEach((document) {
      if (category != null && district != null) {
        if (document['status'] == 'Pending' &&
            document['requestby'] == null &&
            document['category'] == category &&
            document['district'] == district) {
          // pass into the task_testing_notifier.dart list
          TaskTesting tasktesting = TaskTesting.fromMap(document.data);
          _tasktestingList.add(tasktesting);
        }
      } else if (category == null && district != null) {
        if (document['status'] == 'Pending' &&
            document['requestby'] == null &&
            document['district'] == district) {
          // pass into the task_testing_notifier.dart list
          TaskTesting tasktesting = TaskTesting.fromMap(document.data);
          _tasktestingList.add(tasktesting);
        }
      } else if (category != null && district == null) {
        if (document['status'] == 'Pending' &&
            document['requestby'] == null &&
            document['category'] == category) {
          // pass into the task_testing_notifier.dart list
          TaskTesting tasktesting = TaskTesting.fromMap(document.data);
          _tasktestingList.add(tasktesting);
        }
      } else if (category == null ||
          category == 'DEFAULT' && district == null ||
          district == 'DEFAULT') {
        if (document['status'] == 'Pending' && document['requestby'] == null) {
          // pass into the task_testing_notifier.dart list
          TaskTesting tasktesting = TaskTesting.fromMap(document.data);
          _tasktestingList.add(tasktesting);
        }
      }
    });
    tasktestingNotifier.tasktestingList = _tasktestingList;
  } else if (pricearrangement == 'High to Low') {
    QuerySnapshot snapshot = await Firestore.instance
        .collection('tasks')
        .orderBy('price', descending: true)
        .getDocuments();
    List<TaskTesting> _tasktestingList = [];

    //loop through the task
    snapshot.documents.forEach((document) {
      if (category != null && district != null) {
        if (document['status'] == 'Pending' &&
            document['requestby'] == null &&
            document['category'] == category &&
            document['district'] == district) {
          // pass into the task_testing_notifier.dart list
          TaskTesting tasktesting = TaskTesting.fromMap(document.data);
          _tasktestingList.add(tasktesting);
        }
      } else if (category == null && district != null) {
        if (document['status'] == 'Pending' &&
            document['requestby'] == null &&
            document['district'] == district) {
          // pass into the task_testing_notifier.dart list
          TaskTesting tasktesting = TaskTesting.fromMap(document.data);
          _tasktestingList.add(tasktesting);
        }
      } else if (category != null && district == null) {
        if (document['status'] == 'Pending' &&
            document['requestby'] == null &&
            document['category'] == category) {
          // pass into the task_testing_notifier.dart list
          TaskTesting tasktesting = TaskTesting.fromMap(document.data);
          _tasktestingList.add(tasktesting);
        }
      } else if (category == null && district == null) {
        if (document['status'] == 'Pending' && document['requestby'] == null) {
          // pass into the task_testing_notifier.dart list
          TaskTesting tasktesting = TaskTesting.fromMap(document.data);
          _tasktestingList.add(tasktesting);
        }
      }
    });
    tasktestingNotifier.tasktestingList = _tasktestingList;
  } else {
    QuerySnapshot snapshot =
        await Firestore.instance.collection('tasks').getDocuments();
    List<TaskTesting> _tasktestingList = [];

    //loop through the task
    snapshot.documents.forEach((document) {
      if (category != null && district != null) {
        if (document['status'] == 'Pending' &&
            document['requestby'] == null &&
            document['category'] == category &&
            document['district'] == district) {
          // pass into the task_testing_notifier.dart list
          TaskTesting tasktesting = TaskTesting.fromMap(document.data);
          _tasktestingList.add(tasktesting);
        }
      } else if (category == null && district != null) {
        if (document['status'] == 'Pending' &&
            document['requestby'] == null &&
            document['district'] == district) {
          // pass into the task_testing_notifier.dart list
          TaskTesting tasktesting = TaskTesting.fromMap(document.data);
          _tasktestingList.add(tasktesting);
        }
      } else if (category != null ||
          category == 'DEFAULT' && district == null ||
          district == 'DEFAULT') {
        if (document['status'] == 'Pending' &&
            document['requestby'] == null &&
            document['category'] == category) {
          // pass into the task_testing_notifier.dart list
          TaskTesting tasktesting = TaskTesting.fromMap(document.data);
          _tasktestingList.add(tasktesting);
        }
      } else if (category == null ||
          category == 'DEFAULT' && district == null ||
          district == 'DEFAULT') {
        if (document['status'] == 'Pending' && document['requestby'] == null) {
          // pass into the task_testing_notifier.dart list
          TaskTesting tasktesting = TaskTesting.fromMap(document.data);
          _tasktestingList.add(tasktesting);
        }
      }
    });
    tasktestingNotifier.tasktestingList = _tasktestingList;
  }
}

//upload task's image into db
uploadTaskAndImage(TaskTesting tasktesting, bool isUpdating, File localFile,
    Function taskUploaded) async {
  if (localFile != null) {
    print('Uploading Image');

    var fileExtension = path.extension(localFile.path);
    //create unique id
    var uuid = Uuid().v4();
    //accessfirebase storage
    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('tasks/images/$uuid$fileExtension');
    await firebaseStorageRef
        .putFile(localFile)
        .onComplete
        .catchError((onError) {
      print(onError);
      return false;
    });

    String url = await firebaseStorageRef.getDownloadURL();
    print('download url: $url');
    _uploadTask(tasktesting, isUpdating, taskUploaded, imageUrl: url);
  } else {
    print('....skipping image uplaod');
    _uploadTask(tasktesting, isUpdating, taskUploaded);
  }
}

//upload task
_uploadTask(TaskTesting tasktesting, bool isUpdating, Function taskUploaded,
    {String imageUrl}) async {
  CollectionReference tasktestingRef = Firestore.instance.collection('tasks');

  FirebaseUser currentuser = await FirebaseAuth.instance.currentUser();
  if (imageUrl != null) {
    tasktesting.imageUrl = imageUrl;
  }
  if (isUpdating) {
    //update this data with the id to this map
    await tasktestingRef
        .document(tasktesting.id)
        .updateData(tasktesting.toMap());

    taskUploaded(tasktesting);
  } else {
    DocumentReference documentRef =
        await tasktestingRef.add(tasktesting.toMap());

    final userData = await Firestore.instance
        .collection('users')
        .document(currentuser.uid)
        .get();

    tasktesting.id = documentRef.documentID; //documentID shows the id in db
    tasktesting.userid = currentuser.uid;
    tasktesting.customername = userData['name'];
    tasktesting.customerimage = userData['imageUrl'];

    //merge with the existing data instead of overwriting all the other, just add the new data
    await documentRef.setData(tasktesting.toMap(), merge: true);

    taskUploaded(tasktesting);
  }
}

//delete task function
deleteTask(TaskTesting tasktesting, Function taskDeleted) async {
  if (tasktesting.imageUrl != null) {
    StorageReference storageReference = await FirebaseStorage.instance
        .getReferenceFromUrl(tasktesting.imageUrl);

    await storageReference.delete();
  }
//delete the document
  await Firestore.instance
      .collection('tasks')
      .document(tasktesting.id)
      .delete();
//callback function
  taskDeleted(tasktesting);
}

updateRequestBy(TaskTesting tasktesting, Function taskUpdateRequestBy) async {
  var user = await FirebaseAuth.instance.currentUser();
  final userData =
      await Firestore.instance.collection('users').document(user.uid).get();
  tasktesting.spid = user.uid;
  tasktesting.spname = userData['name'];
  tasktesting.spimage = userData['imageUrl'];
  tasktesting.status = 'Requested';

  await Firestore.instance
      .collection('tasks')
      .document(tasktesting.id)
      .setData(tasktesting.toMap(), merge: true);
  //merge with the existing data instead of overwriting all the other, just add the new data

  //push notification
  CollectionReference feedRef = Firestore.instance
      .collection('feed')
      .document(tasktesting.userid)
      .collection('feedItems');
  feedRef.add({
    'type': 'sendingrequest',
    'feedDate': Timestamp.now(),
    'FromId': user.uid,
    'FromName': userData['name'],
    'FromUrl': userData['imageUrl'],
    'ToId': tasktesting.userid,
    'content': userData['name'] + ' has sent a request to you',
  });

  taskUpdateRequestBy(tasktesting);
}

acceptRequest(TaskTesting tasktesting, Function taskUpdateRequestBy) async {
  var user = await FirebaseAuth.instance.currentUser();
  final userData =
      await Firestore.instance.collection('users').document(user.uid).get();
  tasktesting.status = 'Ongoing';

  await Firestore.instance
      .collection('tasks')
      .document(tasktesting.id)
      .setData(tasktesting.toMap(), merge: true);
  //merge with the existing data instead of overwriting all the other, just add the new data

//push notification
  CollectionReference feedRef = Firestore.instance
      .collection('feed')
      .document(tasktesting.spid)
      .collection('feedItems');
  feedRef.add({
    'type': 'acceptrequest',
    'feedDate': Timestamp.now(),
    'FromId': user.uid,
    'FromName': userData['name'],
    'FromUrl': userData['imageUrl'],
    'ToId': tasktesting.spid,
    'content': userData['name'] + ' has accepted your request',
  });

  taskUpdateRequestBy(tasktesting);
}

rejectRequest(TaskTesting tasktesting, Function taskUpdateRequestBy) async {
  var user = await FirebaseAuth.instance.currentUser();
  final userData =
      await Firestore.instance.collection('users').document(user.uid).get();
  //push notification
  CollectionReference feedRef = Firestore.instance
      .collection('feed')
      .document(tasktesting.spid)
      .collection('feedItems');
  feedRef.add({
    'type': 'rejectrequest',
    'feedDate': Timestamp.now(),
    'FromId': user.uid,
    'FromName': userData['name'],
    'FromUrl': userData['imageUrl'],
    'ToId': tasktesting.spid,
    'content': userData['name'] + ' has rejected your request',
  });

  tasktesting.status = 'Pending';
  tasktesting.spid = '';
  tasktesting.spname = '';
  tasktesting.spimage = '';

  await Firestore.instance
      .collection('tasks')
      .document(tasktesting.id)
      .setData(tasktesting.toMap(), merge: true);
  //merge with the existing data instead of overwriting all the other, just add the new data

  taskUpdateRequestBy(tasktesting);
}

//task status set into complete
updateComplete(TaskTesting tasktesting, Function taskUpdateRequestBy) async {
  var user = await FirebaseAuth.instance.currentUser();
  final userData =
      await Firestore.instance.collection('users').document(user.uid).get();
  tasktesting.status = 'Complete';
  tasktesting.statussp = 'Complete';

  await Firestore.instance
      .collection('tasks')
      .document(tasktesting.id)
      .setData(tasktesting.toMap(), merge: true);
  //merge with the existing data instead of overwriting all the other, just add the new data
//push notification
  CollectionReference feedRef = Firestore.instance
      .collection('feed')
      .document(tasktesting.userid)
      .collection('feedItems');
  feedRef.add({
    'type': 'completetask',
    'feedDate': Timestamp.now(),
    'FromId': user.uid,
    'FromName': userData['name'],
    'FromUrl': userData['imageUrl'],
    'ToId': tasktesting.userid,
    'content': userData['name'] + ' has complete the task',
  });

  taskUpdateRequestBy(tasktesting);
}

//////Chat/////////
//get user chat room
getChatRoom(ChatNotifier chatNotifier) async {
  var user = await FirebaseAuth.instance.currentUser();
  QuerySnapshot snapshot = await Firestore.instance
      .collection('chatroom')
      .orderBy('updatedAt', descending: true)
      .getDocuments();
  List<ChatRoom> _chatroomList = [];

  //loop through the task
  snapshot.documents.forEach((document) {
    if (document['customerid'] == user.uid || document['spid'] == user.uid) {
      // pass into the task_testing_notifier.dart list
      ChatRoom chatroom = ChatRoom.fromMap(document.data);
      _chatroomList.add(chatroom);

      //print(document.data);
    }
  });
  chatNotifier.chatroomList = _chatroomList;
}

getChatRoomFromChatButton(
    ChatNotifier chatNotifier, TaskTestingNotifier tasktestingNotifier) async {
  var user = await FirebaseAuth.instance.currentUser();
  QuerySnapshot snapshot =
      await Firestore.instance.collection('chatroom').getDocuments();

  List<ChatRoom> _currentchatroomfromchatbutton = [];

  //loop through the task
  snapshot.documents.forEach((document) {
    if (document['customerid'] == user.uid ||
        document['spid'] == user.uid &&
            document['taskid'] ==
                tasktestingNotifier.currentTaskTesting.userid) {
      // pass into the task_testing_notifier.dart list
      ChatRoom chatroom = ChatRoom.fromMap(document.data);
      _currentchatroomfromchatbutton.add(chatroom);
      print(document.data);
    }
  });
  chatNotifier.chatroomList = _currentchatroomfromchatbutton;
}

addComment(Comment comment, AuthNotifier authNotifier,
    Function addCommentIntoList) async {
  var user = await FirebaseAuth.instance.currentUser();
  CollectionReference userRef = Firestore.instance
      .collection('comments')
      .document(authNotifier.otherUserList[0].uid)
      .collection('commentlist');
  DocumentReference documentRef = userRef.document();
  documentRef.setData(comment.toMap());

  comment.ownerid = authNotifier.otherUserList[0].uid;
  comment.commentpeopleid = user.uid;
  comment.commentpeoplename = authNotifier.currentUser.name;
  comment.imageUrl = authNotifier.currentUser.imageUrl;
  comment.createdAt = Timestamp.now();
  comment.id = Uuid().v4();

  //merge with the existing data instead of overwriting all the other, just add the new data
  await documentRef.setData(comment.toMap(), merge: true);

  //push notification
  CollectionReference feedRef = Firestore.instance
      .collection('feed')
      .document(authNotifier.otherUserList[0].uid)
      .collection('feedItems');
  feedRef.add({
    'type': 'comment',
    'commentDate': Timestamp.now(),
    'commentpeopleid': user.uid,
    'commentpeoplename': authNotifier.currentUser.name,
    'commentpeopleurl': authNotifier.currentUser.imageUrl,
    'ownerid': authNotifier.otherUserList[0].uid,
    'text': comment.text,
    'content': authNotifier.currentUser.name + ' leave a comment on you',
  });
  addCommentIntoList(comment);
}

getOtherComment(AuthNotifier authNotifier, CommentNotifier commentNotifier,
    String userid) async {
  print('run getothercomment');
  print(userid);
  QuerySnapshot getcommentdata = await Firestore.instance
      .collection('comments')
      .document(userid)
      .collection('commentlist')
      .orderBy('createdAt', descending: true)
      .getDocuments();

  List<Comment> _otherCommentList = [];
  getcommentdata.documents.forEach((document) {
    // pass into the task_testing_notifier.dart list
    Comment comment = Comment.fromMap(document.data);
    _otherCommentList.add(comment);
  });
  commentNotifier.othercommentList = _otherCommentList;
}

getComment(AuthNotifier authNotifier, CommentNotifier commentNotifier) async {
  print('run getcomemnt');
  var user = await FirebaseAuth.instance.currentUser();
  QuerySnapshot getcommentdata = await Firestore.instance
      .collection('comments')
      .document(user.uid)
      .collection('commentlist')
      .orderBy('createdAt', descending: true)
      .getDocuments();

  List<Comment> _commentList = [];
  getcommentdata.documents.forEach((document) {
    // pass into the task_testing_notifier.dart list
    Comment comment = Comment.fromMap(document.data);
    _commentList.add(comment);
  });
  commentNotifier.commentList = _commentList;
}

completePayment(
    TaskTesting tasktesting, Payment payment, Function addPayment) async {
  var user = await FirebaseAuth.instance.currentUser();
  CollectionReference userRef = Firestore.instance
      .collection('payments')
      .document(user.uid)
      .collection('paymentlist');
  DocumentReference documentRef = userRef.document();
  documentRef.setData(payment.toMap());

  payment.paymentid = Uuid().v4();
  payment.taskid = tasktesting.id;
  payment.taskname = tasktesting.taskname;
  payment.spid = tasktesting.spid;
  payment.spname = tasktesting.spname;
  payment.customerid = tasktesting.userid;
  payment.customername = tasktesting.customername;
  payment.totalamount = tasktesting.additionalprice != null
      ? tasktesting.price + tasktesting.additionalprice
      : tasktesting.price;
  payment.completedAt = Timestamp.now();
  payment.paymentmethod = tasktesting.paymentmethod;
  payment.status = 'Unclear';
  payment.platformfee = payment.totalamount * 0.3;
  payment.totalpay = payment.totalamount - payment.platformfee;

  //merge with the existing data instead of overwriting all the other, just add the new data
  await documentRef.setData(payment.toMap(), merge: true);

  addPayment(payment);
}

getPayment(PaymentNotifier paymentNotifier) async {
  var user = await FirebaseAuth.instance.currentUser();
  QuerySnapshot getcommentdata = await Firestore.instance
      .collection('payments')
      .document(user.uid)
      .collection('paymentlist')
      .orderBy('completedAt', descending: true)
      .getDocuments();

  List<Payment> _paymentList = [];
  getcommentdata.documents.forEach((document) {
    // pass into the task_testing_notifier.dart list
    Payment payment = Payment.fromMap(document.data);
    _paymentList.add(payment);
  });
  paymentNotifier.paymentList = _paymentList;
}

getLeftAmount(
    PaymentNotifier paymentNotifier, Function accumulateunclearlist) async {
  var user = await FirebaseAuth.instance.currentUser();
  QuerySnapshot getcommentdata = await Firestore.instance
      .collection('payments')
      .document(user.uid)
      .collection('paymentlist')
      .getDocuments();

  List<Payment> _unclearList = [];
  getcommentdata.documents.forEach((document) {
    if (document['status'] == 'Unclear') {
      // pass into the task_testing_notifier.dart list
      Payment payment = Payment.fromMap(document.data);
      _unclearList.add(payment);
    }
  });
  paymentNotifier.unclearList = _unclearList;
  accumulateunclearlist();
}

getfilterandsortingPayment(
    PaymentNotifier paymentNotifier, String month) async {
  if (month == 'DEFAULT') {
    month = null;
  }
  var user = await FirebaseAuth.instance.currentUser();
  QuerySnapshot getcommentdata = await Firestore.instance
      .collection('payments')
      .document(user.uid)
      .collection('paymentlist')
      .getDocuments();

  List<Payment> _paymentList = [];

  //loop through the task
  getcommentdata.documents.forEach((document) {
    if (month != null) {
      if (document['completedAt'].toDate().month.toString() == month) {
        // pass into the task_testing_notifier.dart list
        Payment payment = Payment.fromMap(document.data);
        _paymentList.add(payment);
      }
    } else if (month == null) {
      // pass into the task_testing_notifier.dart list
      Payment payment = Payment.fromMap(document.data);
      _paymentList.add(payment);
    }
  });
  paymentNotifier.paymentList = _paymentList;
}

//customer press pay button to complete payment
customerpaymentdone(Payment payment, TaskTesting tasktesting) async {
  var user = await FirebaseAuth.instance.currentUser();
  final userData =
      await Firestore.instance.collection('users').document(user.uid).get();

  //push notification
  CollectionReference feedRef = Firestore.instance
      .collection('feed')
      .document(tasktesting.spid)
      .collection('feedItems');
  feedRef.add({
    'type': 'paymentsendbycustomer',
    'feedDate': Timestamp.now(),
    'FromId': user.uid,
    'FromName': userData['name'],
    'FromUrl': userData['imageUrl'],
    'ToId': tasktesting.spid,
    'content': userData['name'] + ' has complete the payment.',
  });

  CollectionReference userRef = Firestore.instance
      .collection('paymentforcustomer')
      .document(user.uid)
      .collection('paymentlist');
  DocumentReference documentRef = userRef.document();

  documentRef.setData(payment.toMap());

  payment.paymentid = Uuid().v4();
  payment.taskid = tasktesting.id;
  payment.taskname = tasktesting.taskname;
  payment.spid = tasktesting.spid;
  payment.spname = tasktesting.spname;
  payment.customerid = tasktesting.userid;
  payment.customername = tasktesting.customername;
  payment.totalamount = tasktesting.additionalprice != null
      ? tasktesting.price + tasktesting.additionalprice
      : tasktesting.price;
  payment.completedAt = Timestamp.now();
  payment.paymentmethod = tasktesting.paymentmethod;
  payment.platformfee =
      double.parse((payment.totalamount * 0.3).toStringAsFixed(2));
  payment.totalpay = payment.totalamount - payment.platformfee;
  payment.paymentmethod = tasktesting.paymentmethod;

  //merge with the existing data instead of overwriting all the other, just add the new data
  await documentRef.setData(payment.toMap(), merge: true);

  CollectionReference userRef2 = Firestore.instance
      .collection('paymentforsp')
      .document(tasktesting.spid)
      .collection('paymentlist');
  DocumentReference documentRef2 = userRef2.document();

  documentRef2.setData(payment.toMap());

  payment.paymentid = Uuid().v4();
  payment.taskid = tasktesting.id;
  payment.taskname = tasktesting.taskname;
  payment.spid = tasktesting.spid;
  payment.spname = tasktesting.spname;
  payment.customerid = tasktesting.userid;
  payment.customername = tasktesting.customername;
  payment.totalamount = tasktesting.additionalprice != null
      ? tasktesting.price + tasktesting.additionalprice
      : tasktesting.price;
  payment.completedAt = Timestamp.now();
  payment.paymentmethod = tasktesting.paymentmethod;
  payment.platformfee =
      double.parse((payment.totalamount * 0.3).toStringAsFixed(2));
  payment.totalpay = payment.totalamount - payment.platformfee;
  payment.paymentmethod = tasktesting.paymentmethod;

  tasktesting.statuscustomer = 'Complete';

  await Firestore.instance
      .collection('tasks')
      .document(tasktesting.id)
      .setData(tasktesting.toMap(), merge: true);
  //merge with the existing data instead of overwriting all the other, just add the new data
  await documentRef.setData(payment.toMap(), merge: true);
}

getCustomerPaymentRecord(PaymentNotifier paymentNotifier) async {
  var user = await FirebaseAuth.instance.currentUser();
  QuerySnapshot getcommentdata = await Firestore.instance
      .collection('paymentforcustomer')
      .document(user.uid)
      .collection('paymentlist')
      .orderBy('completedAt', descending: true)
      .getDocuments();

  List<Payment> _paymentList = [];
  getcommentdata.documents.forEach((document) {
    // pass into the task_testing_notifier.dart list
    Payment payment = Payment.fromMap(document.data);
    _paymentList.add(payment);
  });
  paymentNotifier.paymentList = _paymentList;
}

getfilterandsortingCustomerPayment(
    PaymentNotifier paymentNotifier, String month) async {
  if (month == 'DEFAULT') {
    month = null;
  }
  //print(month);
  var user = await FirebaseAuth.instance.currentUser();
  QuerySnapshot getcommentdata = await Firestore.instance
      .collection('paymentfromcustomer')
      .document(user.uid)
      .collection('paymentlist')
      .getDocuments();

  List<Payment> _paymentList = [];

  //loop through the task
  getcommentdata.documents.forEach((document) {
    if (month != null) {
      if (document['completedAt'].toDate().month.toString() == month) {
        // pass into the task_testing_notifier.dart list
        Payment payment = Payment.fromMap(document.data);
        _paymentList.add(payment);
      }
    } else if (month == null) {
      // pass into the task_testing_notifier.dart list
      Payment payment = Payment.fromMap(document.data);
      _paymentList.add(payment);
    }
  });
  paymentNotifier.paymentList = _paymentList;
}

getSpPaymentRecord(PaymentNotifier paymentNotifier) async {
  var user = await FirebaseAuth.instance.currentUser();
  QuerySnapshot getcommentdata = await Firestore.instance
      .collection('paymentforsp')
      .document(user.uid)
      .collection('paymentlist')
      .orderBy('completedAt', descending: true)
      .getDocuments();

  List<Payment> _paymentList = [];
  getcommentdata.documents.forEach((document) {
    // pass into the task_testing_notifier.dart list
    Payment payment = Payment.fromMap(document.data);
    _paymentList.add(payment);
  });
  paymentNotifier.paymentList = _paymentList;
}

updatepaymentstatusintoclear(Payment payment) async {
  var user = await FirebaseAuth.instance.currentUser();
  QuerySnapshot getcommentdata = await Firestore.instance
      .collection('payments')
      .document(user.uid)
      .collection('paymentlist')
      .where('status', isEqualTo: 'Unclear')
      .getDocuments();

  getcommentdata.documents.forEach((document) async {

    await Firestore.instance
        .collection('payments')
        .document(user.uid)
        .collection('paymentlist')
        .document(document.documentID)
        .updateData({'status': 'Clear'});
  });
}

cancelTaskBySp(TaskTesting tasktesting, Function taskUpdateRequestBy) async {
  var user = await FirebaseAuth.instance.currentUser();
  final userData =
      await Firestore.instance.collection('users').document(user.uid).get();
  //push notification
  CollectionReference feedRef = Firestore.instance
      .collection('feed')
      .document(tasktesting.userid)
      .collection('feedItems');
  feedRef.add({
    'type': 'canceltaskbysp',
    'feedDate': Timestamp.now(),
    'FromId': user.uid,
    'FromName': userData['name'],
    'FromUrl': userData['imageUrl'],
    'ToId': tasktesting.userid,
    'content': userData['name'] + ' has cancel the task',
  });

  tasktesting.status = 'Pending';
  tasktesting.spid = '';
  tasktesting.spname = '';
  tasktesting.spimage = '';

  await Firestore.instance
      .collection('tasks')
      .document(tasktesting.id)
      .setData(tasktesting.toMap(), merge: true);
  //merge with the existing data instead of overwriting all the other, just add the new data
  taskUpdateRequestBy(tasktesting);
}

cancelTaskByCustomer(
    TaskTesting tasktesting, Function taskUpdateRequestBy) async {
  var user = await FirebaseAuth.instance.currentUser();
  final userData =
      await Firestore.instance.collection('users').document(user.uid).get();
  //push notification
  CollectionReference feedRef = Firestore.instance
      .collection('feed')
      .document(tasktesting.spid)
      .collection('feedItems');
  feedRef.add({
    'type': 'canceltaskbycustomer',
    'feedDate': Timestamp.now(),
    'FromId': user.uid,
    'FromName': userData['name'],
    'FromUrl': userData['imageUrl'],
    'ToId': tasktesting.spid,
    'content': userData['name'] + ' has cancel the task',
  });

  tasktesting.status = 'Pending';
  tasktesting.spid = '';
  tasktesting.spname = '';
  tasktesting.spimage = '';

  await Firestore.instance
      .collection('tasks')
      .document(tasktesting.id)
      .setData(tasktesting.toMap(), merge: true);
  //merge with the existing data instead of overwriting all the other, just add the new data

  taskUpdateRequestBy(tasktesting);
}

//getNotificationlist
getNotification(NotificationNotifier notificationNotifier) async {
  print('object');
  var user = await FirebaseAuth.instance.currentUser();
  QuerySnapshot snapshot = await Firestore.instance
      .collection('feed')
      .document(user.uid)
      .collection('feedItems')
      .orderBy('feedDate', descending: true)
      .getDocuments();
  List<Notifications> _notificationList = [];

  //loop through the task
  snapshot.documents.forEach((document) {
    if (document['type'] != 'sendchat' && document['type'] != 'sendimage') {
      // pass into the task_testing_notifier.dart list
      Notifications notification = Notifications.fromMap(document.data);
      _notificationList.add(notification);
      print(document.data);
    }
  });
  notificationNotifier.notificationList = _notificationList;
}
