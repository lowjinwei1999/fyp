import 'package:flutter/material.dart';
import 'package:fyp_project/notifier/auth_notifier.dart';
import 'package:fyp_project/notifier/comment_notifier.dart';
import 'package:fyp_project/providers/comment.dart';
import 'package:provider/provider.dart';
import '../api/task_api.dart';

class CommentFormScreen extends StatefulWidget {
  @override
  _CommentFormScreenState createState() => _CommentFormScreenState();
}

class _CommentFormScreenState extends State<CommentFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController commetctl = new TextEditingController();
  Comment _comment = Comment();
  _saveTask() {
    //print('save task call');
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    addComment(_comment, authNotifier, _addCommentIntoList);
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
                title: Text('Success'),
                content: Text('Your Comment Has Added'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Okay'),
                    onPressed: () {
                      var nav = Navigator.of(context);
                      nav.pop();
                      nav.pop();
                      commetctl.clear();
                    },
                  )
                ]));
  }

  // uploadTaskAndImage(
  //     _currentTaskTesting, widget.isUpdating, _imageFile, _onTaskUploaded);
  _addCommentIntoList(Comment comment) {
    CommentNotifier commentNotifier =
        Provider.of<CommentNotifier>(context, listen: false);
    commentNotifier.addcommentintolocallist(comment);
  }

  Widget _buildnameField() {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Icon(
              Icons.article_outlined,
              color: Colors.grey,
            ),
          ),
          SizedBox(width: 7),
          Flexible(
            child: TextFormField(
              controller: commetctl,
              decoration: InputDecoration(labelText: "Drop Your Comment Here"),
              keyboardType: TextInputType.text,
              style: TextStyle(fontSize: 16),
              validator: (String value) {
                if (value.isEmpty) {
                  return "Comment is required";
                }
                if (value.length < 3) {
                  return "Comment must more than three";
                }
                return null;
              },
              onSaved: (String value) {
                _comment.text = value;
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Comment'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(28),
        child: Form(
          key: _formKey,
          //autovalidate: true,
          child: Column(
            children: <Widget>[
              _buildnameField(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _saveTask(),
        child: Icon(Icons.save),
        foregroundColor: Colors.white,
      ),
    );
  }
}
