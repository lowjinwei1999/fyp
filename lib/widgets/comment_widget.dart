import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp_project/api/task_api.dart';
import 'package:fyp_project/notifier/auth_notifier.dart';
import 'package:fyp_project/notifier/comment_notifier.dart';
import 'package:fyp_project/screens/commentform_screen.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/date_symbols.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as tAgo;

class CommentWidget extends StatefulWidget {
  final bool isView;

  CommentWidget({@required this.isView});
  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  void initState() {
    if (widget.isView) {
      AuthNotifier authNotifier =
          Provider.of<AuthNotifier>(context, listen: false);
      CommentNotifier commentNotifier =
          Provider.of<CommentNotifier>(context, listen: false);
      //getOtherComment(authNotifier, commentNotifier);
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    CommentNotifier commentNotifier = Provider.of<CommentNotifier>(context);
    return widget.isView
        ? commentNotifier.othercommentList.isEmpty
            ? Center(
                child: Text('Wait for comment'),
              )
            : StreamBuilder(
                stream: Firestore.instance
                    .collection('comments')
                    .document(authNotifier.otherUserList[0].uid)
                    .collection('commentlist')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Container(
                      child: Column(children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                              padding:
                                  EdgeInsets.only(left: 20, right: 20, top: 7),
                              child: Container(
                                height: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  // color: Colors.deepPurple,
                                  color: Color.fromRGBO(55, 65, 100, 1)
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                      //backgroundColor: Colors.white,
                                      radius: 30,
                                      backgroundImage: NetworkImage(
                                        commentNotifier.othercommentList[index].imageUrl !=
                                            null
                                        ?  commentNotifier.othercommentList[index].imageUrl
                                        : 'https://cdn2.iconfinder.com/data/icons/facebook-51/32/FACEBOOK_LINE-01-512.png',
                                       
                                      )),
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        commentNotifier.othercommentList[index]
                                            .commentpeoplename,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      Text(
                                          tAgo.format(commentNotifier
                                              .othercommentList[index].createdAt
                                              .toDate()),
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.white)),
                                    ],
                                  ),
                                  subtitle: Text(
                                    widget.isView
                                        ? commentNotifier
                                            .othercommentList[index].text
                                        : commentNotifier
                                            .commentList[index].text,
                                    maxLines: 5,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  contentPadding: EdgeInsets.only(
                                      left: 16, right: 16, top: 10, bottom: 10),
                                ),
                              ));
                        },
                        itemCount: commentNotifier.othercommentList.length,
                      ),
                    )
                  ]));
                })
        : commentNotifier.commentList.isEmpty
            ? Center(
                child: Text('Wait for comment'),
              )
            : Container(
                child: Column(children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                          padding: EdgeInsets.only(left: 20, right: 20, top: 7),
                          child: Container(
                            height: 120,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromRGBO(55, 65, 100, 1)),
                            child: ListTile(
                              leading: CircleAvatar(
                                  //backgroundColor: Colors.white,
                                  radius: 30,
                                  backgroundImage: NetworkImage(
                                    commentNotifier.commentList[index].imageUrl,
                                  )),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    commentNotifier
                                        .commentList[index].commentpeoplename,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  Text(
                                      tAgo.format(commentNotifier
                                          .commentList[index].createdAt
                                          .toDate()),
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.white)),
                                ],
                              ),
                              subtitle: Text(
                                commentNotifier.commentList[index].text,
                                maxLines: 5,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              contentPadding: EdgeInsets.only(
                                  left: 16, right: 16, top: 10, bottom: 10),
                            ),
                          ));
                    },
                    itemCount: commentNotifier.commentList.length,
                  ),
                )
              ]));
  }
}
