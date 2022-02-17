import 'dart:collection';
import 'package:flutter/material.dart';

import '../providers/task_testing.dart';

class TaskTestingNotifier with ChangeNotifier {
  List<TaskTesting> _tasktestingList = [];

  List<TaskTesting> _acceptedtasktestingList = [];

  TaskTesting _currentTaskTesting;

//pass the data into the list
  UnmodifiableListView<TaskTesting> get tasktestingList =>
      UnmodifiableListView(_tasktestingList);

  UnmodifiableListView<TaskTesting> get acceptedtasktestingList =>
      UnmodifiableListView(_acceptedtasktestingList);

  TaskTesting get currentTaskTesting => _currentTaskTesting;

  set tasktestingList(List<TaskTesting> tasktestingList) {
    _tasktestingList = tasktestingList;
    //notify the apps that have change
    notifyListeners();
  }

  set acceptedtasktestingList(List<TaskTesting> acceptedtasktestingList) {
    _acceptedtasktestingList = acceptedtasktestingList;
    //notify the apps that have change
    notifyListeners();
  }

  set currentTaskTesting(TaskTesting tasktesting) {
    _currentTaskTesting = tasktesting;
    //notify the apps that have change
    notifyListeners();
  }

  addTask(TaskTesting tasktesting) {
    final prodIndex = _tasktestingList
        .indexWhere((_tasktesting) => _tasktesting.id == tasktesting.id);
    if (prodIndex >= 0) {
      _tasktestingList[prodIndex] = tasktesting;
      notifyListeners();
    } else {
      _tasktestingList.add(tasktesting);
      notifyListeners();
    }
  }

  deleteTask(TaskTesting tasktesting) {
    _tasktestingList
        .removeWhere((_tasktesting) => _tasktesting.id == tasktesting.id);
    notifyListeners();
  }

  taskUpdateRequestBy(TaskTesting tasktesting) {
    final prodIndex = _tasktestingList
        .indexWhere((_tasktesting) => _tasktesting.id == tasktesting.id);
    if (prodIndex >= 0) {
      _tasktestingList[prodIndex] = tasktesting;
      notifyListeners();
    }
  }

  clearfiltertaskresult() {
    _tasktestingList.clear();
  }
}
