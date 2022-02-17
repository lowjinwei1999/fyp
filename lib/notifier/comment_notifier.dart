import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'dart:collection';

import '../providers/comment.dart';

class CommentNotifier with ChangeNotifier {
  List<Comment> _commentList = [];

  List<Comment> _othercommentList = [];

  UnmodifiableListView<Comment> get commentList =>
      UnmodifiableListView(_commentList);

  //pass the data into the list
  UnmodifiableListView<Comment> get othercommentList =>
      UnmodifiableListView(_othercommentList);

  set commentList(List<Comment> commentList) {
    _commentList = commentList;
    //notify the apps that have change
    notifyListeners();
  }

  set othercommentList(List<Comment> othercommentList) {
    _othercommentList = othercommentList;
    //notify the apps that have change
    notifyListeners();
  }

  clearviewedcomment() {
    _othercommentList.clear();
    _commentList.clear();
  }

  addcommentintolocallist(Comment comment) {
    _othercommentList.insert(0, comment);
    notifyListeners();
  }
}
