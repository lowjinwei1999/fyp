import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp_project/notifier/comment_notifier.dart';
import 'package:fyp_project/sp/screens/sp_editprofilescreen.dart';
import 'package:fyp_project/widgets/comment_widget.dart';

import 'package:provider/provider.dart';

import 'package:fyp_project/utils/custom_clipper.dart';
import '../../api/task_api.dart';
import 'package:fyp_project/notifier/auth_notifier.dart';

class SpUserProfile extends StatefulWidget {
  
  @override
  _SpUserProfileState createState() => _SpUserProfileState();
}

class _SpUserProfileState extends State<SpUserProfile> {
 AuthResult authResult;
  String userId;
  String username;
  String userImage;
  var isInit = true;
  var isLoading;

  @override
  void initState() {
    if (isInit) {
      setState(() {
        isLoading = true;
      });
      print('run initState in user_profile.dart');
      AuthNotifier authNotifier =
          Provider.of<AuthNotifier>(context, listen: false);
      getUserData(authNotifier);
      CommentNotifier commentNotifier = Provider.of<CommentNotifier>(context,listen: false);
      getComment(authNotifier,commentNotifier);
      setState(() {
        //username = authNotifier.userList[0].name;
        isLoading = false;
      });
    }
    isInit = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            body: 
            Container(
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
                                authNotifier.userList[0].imageUrl != null
                                    ? authNotifier.userList[0].imageUrl
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
                            authNotifier.userList[0].name != null
                                ? authNotifier.userList[0].name
                                : '',
                            style: TextStyle(
                                fontSize: 19.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[500]),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          // decoration: BoxDecoration(
                          //     border: Border.all(color: Colors.blueAccent)),
                          width: 200,
                          padding: EdgeInsets.symmetric(
                              vertical: 0, horizontal: 30.5),
                          child: FlatButton.icon(
                              textColor: Theme.of(context).primaryColor,
                              icon: Icon(Icons.edit),
                              label: Text('Edit Profile'),
                              onPressed: () {
                                authNotifier.currentUser =
                                    authNotifier.userList[0];
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return SpEditProfileScreen();
                                }));
                              }),
                        ),
                        SizedBox(height: 40),
                        Expanded(child: CommentWidget(isView: false,)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
    //  });
    // });
  }
}