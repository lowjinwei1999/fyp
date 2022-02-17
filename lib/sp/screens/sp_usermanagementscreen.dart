import 'package:flutter/material.dart';
import 'package:fyp_project/api/task_api.dart';
import 'package:fyp_project/notifier/auth_notifier.dart';
import 'package:fyp_project/notifier/comment_notifier.dart';
import 'package:fyp_project/notifier/task_testing_notifier.dart';
import 'package:fyp_project/providers/user.dart';
import 'package:fyp_project/screens/commentform_screen.dart';
import 'package:fyp_project/sp/screens/sp_editprofilescreen.dart';
import 'package:fyp_project/sp/widgets/sp_appdrawer.dart';
import 'package:fyp_project/sp/widgets/sp_userprofile.dart';
import 'package:fyp_project/utils/custom_clipper.dart';
import 'package:fyp_project/widgets/comment_widget.dart';
import 'package:provider/provider.dart';

class SpUserManagementScreen extends StatefulWidget {
  static const routeName = '/sp_usermanagement_screen';
  final bool isView;

  SpUserManagementScreen({@required this.isView});
  @override
  _SpUserManagementScreenState createState() => _SpUserManagementScreenState();
}

class _SpUserManagementScreenState extends State<SpUserManagementScreen> {
  void iniState() {
    if (widget.isView) {
      _onRemoveViewedUserData();
      TaskTestingNotifier tasktestingNotifier =
          Provider.of<TaskTestingNotifier>(context);

      AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
      getOtherUser(authNotifier, tasktestingNotifier);

      CommentNotifier commentNotifier = Provider.of<CommentNotifier>(context);
      // getOtherComment(authNotifier, commentNotifier);
    }
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    getUserData(authNotifier);

    setState(() {});
    super.initState();
  }

  _onRemoveViewedUserData() {
    // print('run onRemoveViewdUserData');
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    CommentNotifier commentNotifier =
        Provider.of<CommentNotifier>(context, listen: false);

    // tasktestingNotifier.updateTask(tasktesting);
    // Navigator.pop(context);

    authNotifier.clearvieweduser();
    commentNotifier.clearviewedcomment();
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    CommentNotifier commentNotifier = Provider.of<CommentNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        elevation: 0,
      ),
      drawer: widget.isView == null
          ? Center(child: CircularProgressIndicator())
          : widget.isView
              ? null
              : SpAppDrawer(),

      body: widget.isView
          ? authNotifier.otherUserList.isEmpty
              ? Center(
                  child: new CircularProgressIndicator(),
                )
              : Container(
                  child: Stack(
                    children: <Widget>[
                      Container(),
                      ClipPath(
                        clipper: MyCustomClipper(),
                        child: Container(
                          height: 150.0,
                          color: Colors.deepPurple,
                          // decoration: BoxDecoration(
                          //   image: DecorationImage(image: NetworkImage("https://picsum.photos/200"),
                          //   fit: BoxFit.cover,
                          //   )
                          // ),
                        ),
                      ),
                      Container(
                        width: double.maxFinite,
                        //decoration:
                        //BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: double.maxFinite,
                              margin: EdgeInsets.only(top: 30),
                              //decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                              child: CircleAvatar(
                                radius: 55,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.white,
                                  backgroundImage: NetworkImage(
                                    authNotifier.otherUserList[0].imageUrl !=
                                            null
                                        ? authNotifier.otherUserList[0].imageUrl
                                        : 'https://cdn2.iconfinder.com/data/icons/facebook-51/32/FACEBOOK_LINE-01-512.png',
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Container(
                              width: double.maxFinite,
                              alignment: Alignment.center,
                              //decoration: BoxDecoration(
                              //border: Border.all(color: Colors.blueAccent)),
                              child: Text(
                                authNotifier.otherUserList[0].name != null
                                    ? authNotifier.otherUserList[0].name
                                    : '',
                                style: TextStyle(
                                    fontSize: 19.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[500]),
                              ),
                            ),
                            // Container(
                            //   alignment: Alignment.center,
                            //   // decoration: BoxDecoration(
                            //   //     border: Border.all(color: Colors.blueAccent)),
                            //   width: 200,
                            //   padding: EdgeInsets.symmetric(
                            //       vertical: 0, horizontal: 30.5),
                            //   child: FlatButton.icon(
                            //       textColor: Theme.of(context).primaryColor,
                            //       icon: Icon(Icons.edit),
                            //       label: Text('Edit Profile'),
                            //       onPressed: () {

                            //       }),
                            // ),
                            SizedBox(height: 40),
                            Container(
                              alignment: Alignment.center,
                              // decoration: BoxDecoration(
                              //     border: Border.all(color: Colors.blueAccent)),
                              width: 300,
                              //padding: EdgeInsets.symmetric(vertical: 0, horizontal: 1),
                              child: FlatButton.icon(
                                  textColor: Theme.of(context).primaryColor,
                                  icon: Icon(Icons.add),
                                  label: Text(
                                    'Add New Comment',
                                    style: TextStyle(fontSize: 19),
                                  ),
                                  onPressed: () {
                                    authNotifier.currentUser =
                                        authNotifier.userList[0];
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) {
                                      return CommentFormScreen();
                                    }));
                                  }),
                            ),
                            Expanded(
                                child: Container(
                                    child: CommentWidget(
                              isView: true,
                            ))),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
          : SpUserProfile(),
      // floatingActionButton: FloatingActionButton(onPressed: getCurrentUser,),
    );
  }
}
