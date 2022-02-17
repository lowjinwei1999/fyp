import 'dart:collection';

import 'package:flutter/cupertino.dart';

import 'package:fyp_project/providers/notifications.dart';

class NotificationNotifier with ChangeNotifier
{
   List<Notifications> _notificationList = [];

    UnmodifiableListView<Notifications> get notificationList =>
      UnmodifiableListView(_notificationList);

       set notificationList(List<Notifications> notificationList) {
    _notificationList = notificationList;
    //notify the apps that have change
    notifyListeners();
  }

  clearcnotificationlist() {
   _notificationList.clear();

  }

}