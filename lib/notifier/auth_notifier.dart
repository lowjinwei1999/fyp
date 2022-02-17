import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'dart:collection';

import '../providers/user.dart';

class AuthNotifier with ChangeNotifier {
  FirebaseUser _user;

  FirebaseUser get user => _user;

   List<User> _userList = [];

  User _currentUser;

  List<User> _otherUserList = [];

  List<User> _currentaccounttype = [];


  UnmodifiableListView<User> get currentaccounttype =>
      UnmodifiableListView(_currentaccounttype);

//pass the data into the list
  UnmodifiableListView<User> get userList =>
      UnmodifiableListView(_userList);

      //pass the data into the list
  UnmodifiableListView<User> get otherUserList =>
      UnmodifiableListView(_otherUserList);

  User get currentUser => _currentUser;

   set userList(List<User> userList) {
    _userList = userList;
    //notify the apps that have change
    notifyListeners();
  }

     set otherUserList(List<User> otherUserLit) {
    _otherUserList = otherUserLit;
    //notify the apps that have change
    notifyListeners();
  }

    set currentUser(User user) {
    _currentUser = user;
    //notify the apps that have change
    notifyListeners();
  }

   set currentaccounttype(List<User> currentaccounttype) {
    _currentaccounttype = currentaccounttype;
    //notify the apps that have change
    notifyListeners();
  }

    updateUser(User user) {
    final prodIndex = _userList.indexWhere((_user) => _user.uid == _user.uid);
    if(prodIndex>=0){
    _userList[prodIndex] = user;
    print(user.imageUrl);
    notifyListeners();
    }
  }

  void setUser(FirebaseUser user) {
    _user = user;
    notifyListeners();
  }
  

clearvieweduser() {
   _otherUserList.clear();
  //  print('remove here');
  //  print(_otherUserList);

  }
}

  