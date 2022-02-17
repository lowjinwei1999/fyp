import 'package:flutter/material.dart';
import 'dart:io';
//import '../screens/auth_screen.dart';
import '../pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this.isLoading);

  final bool isLoading;
  final void Function(
    String email, 
    String password, 
    String username,
    File image,
    bool isLogin, 
    BuildContext ctx) submitFn;
  @override
  _AuthFormState createState() => _AuthFormState(); 
  
  String get username {
    return username;
  }
}



class _AuthFormState extends State<AuthForm> {
//to trigger all the validator together, use global key
  final _formKey = GlobalKey<FormState>();
//to use in change sign up or login moade
  var _isLogin = true;
//save all the value
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  File _userImageFile;

//receive the file from the user_image_picker.dart
  void _pickedImage(File image) {
    _userImageFile = image;
  }

//trigger all the validator
  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (_userImageFile == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(
        SnackBar(content: Text('Please pick an image!'),
        backgroundColor: Theme.of(context).errorColor,
        ),
      );
      //the other part(below part) will not execute
      return;
    }

    if (isValid) {
      _formKey.currentState.save();
      //this will go to all the textformfield to trigger all the onSaved function
      widget.submitFn(
        //trim() remove all the white space in the form
        _userEmail.trim(),
        _userName.trim(),
        _userPassword.trim(),
        _userImageFile,
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
          margin: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                //connect the key with the form
                key: _formKey,
                child:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  if (!_isLogin) UserImagePicker(_pickedImage),
                  TextFormField(
                    key: ValueKey('Email'),
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                    ),
                    onSaved: (value) {
                      _userEmail = value;
                    },
                  ),
                  //check is is not in login mode username column will disappear
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('Username'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 4) {
                          return 'Password must be at least 4 characters long';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'User Name'),
                      onSaved: (value) {
                        _userName = value;
                      },
                    ),
                  TextFormField(
                    key: ValueKey('Password'),
                    validator: (value) {
                      if (value.isEmpty || value.length < 7) {
                        return 'Password must be at least 7 characters long';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    onSaved: (value) {
                      _userPassword = value;
                    },
                  ),
                  SizedBox(height: 12),
                  if (widget.isLoading) CircularProgressIndicator(),

                  //if is not isloading mode show these buttons
                  if (!widget.isLoading)
                    RaisedButton(
                      child: Text(_isLogin ? 'Login' : 'SignUp'),
                      onPressed: _trySubmit,
                    ),
                  if (!widget.isLoading)
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      child: Text(_isLogin
                          ? 'Create new account'
                          : 'I already have an account'),
                      onPressed: () {
                        //setState use to change the UI
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                    )
                ]),
              ),
            ),
          )
          ),
    );
  }
}
