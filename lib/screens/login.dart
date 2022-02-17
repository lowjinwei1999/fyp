import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/auth_notifier.dart';
import '../api/task_api.dart';
import '../providers/user.dart';
import '../Animation/fadeanimation.dart';

enum AuthMode { Signup, Login }

class Login extends StatefulWidget {
  static const routeName = '/login-screen';
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = new TextEditingController();
  AuthMode _authMode = AuthMode.Login;
  String selected;
  String _errormessage;

  User _user = User();

  @override
  void initState() {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    initializeCurrentUser(authNotifier);
    super.initState();
  }

signup(User user, AuthNotifier authNotifier) async {
  AuthResult authResult = await FirebaseAuth.instance
      .createUserWithEmailAndPassword(
          email: user.email, password: user.password)

      .catchError((error) => print(error.code));

  showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                  title: Text('Success'),
                  content: Text('You are login'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Okay'),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    )
                  ]));
          

  CollectionReference userRef = Firestore.instance.collection('users');

  DocumentReference documentRef = userRef.document(authResult.user.uid);
  documentRef.setData(user.toMap());

  user.uid = authResult.user.uid;

  //merge with the existing data instead of overwriting all the other, just add the new data
  await documentRef.setData(user.toMap(), merge: true);
}

  login(User user, AuthNotifier authNotifier) async {
  AuthResult authResult = await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: user.email, password: user.password)
      .catchError((error) => setState(() {
        _errormessage = error.message;
       showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                  title: Text('Alert'),
                  content: Text(_errormessage),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Okay'),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    )
                  ]));
      })
    
    );

  if (authResult != null) {
    FirebaseUser firebaseUser = authResult.user;
    if (firebaseUser != null) {
      // print("Log In: $firebaseUser");
      authNotifier.setUser(firebaseUser);
    }
  }
}

  void _submitForm() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
   
      if (_authMode == AuthMode.Login) {

          login(_user, authNotifier);

      } else {
        signup(_user, authNotifier);
      }

  }

  Widget _buildEmailField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Email",
        border: InputBorder.none,
        labelStyle: TextStyle(color: Colors.grey),
      ),
      keyboardType: TextInputType.emailAddress,
      initialValue: 'sp4@gmail.com',
      style: TextStyle(
        fontSize: 15,
      ),
      //initialValue: 'julian@food.com',

      validator: (String value) {
        if (value.isEmpty) {
          return 'Email is required';
        }

        if (!RegExp(
                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Please enter a valid email address';
        }

        return null;
      },
      onSaved: (String value) {
        _user.email = value;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      decoration: InputDecoration(
        border: InputBorder.none,
        labelText: "Password",
        labelStyle: TextStyle(color: Colors.grey),
      ),
      style: TextStyle(
        fontSize: 15,
      ),
      //cursorColor: Colors.white,
      obscureText: true,
      controller: _passwordController,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Password is required';
        }

        if (value.length < 5 || value.length > 20) {
          return 'Password must be betweem 5 and 20 characters';
        }

        return null;
      },
      onSaved: (String value) {
        _user.password = value;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      decoration: InputDecoration(
        border: InputBorder.none,
        labelText: "Confirm Password",
        labelStyle: TextStyle(color: Colors.grey),
      ),
      style: TextStyle(fontSize: 15),
      obscureText: true,
      validator: (String value) {
        if (_passwordController.text != value) {
          return 'Passwords do not match';
        }

        return null;
      },
    );
  }

  Widget _buildnameField() {
    return TextFormField(
      decoration: InputDecoration(
        border: InputBorder.none,
        labelText: "Name",
        labelStyle: TextStyle(color: Colors.grey),
      ),
      style: TextStyle(
        fontSize: 15,
      ),
      //cursorColor: Colors.white,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name is required';
        }

        return null;
      },
      onSaved: (String value) {
        _user.name = value;
      },
    );
  }

  List<String> _locations = ["Customer", "Service Partner"];
  //
  Widget _buildtypeField() {
    // String _selectedLocation= _currentUser.bankname;
    return DropdownButtonFormField(
      decoration: InputDecoration(labelText: 'Account Type'),
      //hint: Text('Please choose a location'), // Not necessary for Option 1
      value: selected,
      onSaved: (String value) {
        _user.accounttype = value;
      },
      onChanged: (newValue) {
        setState(() {
          selected = newValue;
        });
      },
      items: _locations.map((location) {
        return DropdownMenuItem(
          child: new Text(location),
          value: location,
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    //print("Building login screen");
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          // autovalidate: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 200,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: -40,
                      height: 200,
                      width: width,
                      child: FadeAnimation(
                          1,
                          Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/background.png'),
                                    fit: BoxFit.fill)),
                          )),
                    ),
                    Positioned(
                      height: 200,
                      width: width + 20,
                      child: FadeAnimation(
                          1.3,
                          Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/background-2.png'),
                                    fit: BoxFit.fill)),
                          )),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FadeAnimation(
                        1.5,
                        Text(
                          "WE DO",
                          style: TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        )),
                    SizedBox(
                      height: 30,
                    ),
                    FadeAnimation(
                        1.7,
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(196, 135, 198, .3),
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                )
                              ]),
                          child: Column(
                            children: <Widget>[
                              Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey[200]))),
                                  child: _buildEmailField()),
                              Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey[200]))),
                                  child: _buildPasswordField()),
                              _authMode == AuthMode.Signup
                                  ? Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]))),
                                      child: _buildConfirmPasswordField())
                                  : Container(),
                              _authMode == AuthMode.Signup
                                  ? Container(
                                      padding: EdgeInsets.all(10),
                                      child: Column(children: <Widget>[
                                        _buildnameField(),
                                        Divider(),
                                        _buildtypeField(),
                                      ]))
                                  : Container(),
                            ],
                          ),
                        )),
                    SizedBox(
                      height: 15,
                    ),
                    FadeAnimation(
                        1.9,
                        Container(
                          height: 50,
                          margin: EdgeInsets.symmetric(horizontal: 60),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Color.fromRGBO(49, 39, 79, 1),
                          ),
                          child: Center(
                            child: RaisedButton(
                              color: Color.fromRGBO(49, 39, 79, 1),
                              padding: EdgeInsets.all(10.0),
                              onPressed: () => _submitForm(),
                              child: Text(
                                _authMode == AuthMode.Login
                                    ? 'Login'
                                    : 'Signup',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ),
                          ),
                        )),
                    SizedBox(
                      height: 1,
                    ),
                    FadeAnimation(
                        2,
                        Center(
                          child: FlatButton.icon(
                            textColor: Theme.of(context).primaryColor,
                            icon: Icon(Icons.edit),
                            label: Text(_authMode == AuthMode.Login
                                ? 'Create Account'
                                : 'Back To Login'),
                            onPressed: () {
                              setState(() {
                                _authMode = _authMode == AuthMode.Login
                                    ? AuthMode.Signup
                                    : AuthMode.Login;
                              });
                            },
                          ),
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
} // child: Form(
//   autovalidate: true,
//   key: _formKey,
//   child: SingleChildScrollView(
//     child: Padding(
//       padding: EdgeInsets.fromLTRB(32, 96, 32, 0),
//       child: Column(
//         children: <Widget>[
//           Text(
//             "Please Sign In",
//             textAlign: TextAlign.center,
//             style: TextStyle(fontSize: 36, color: Colors.white),
//           ),
//           SizedBox(height: 32),

//           _buildEmailField(),
//           _buildPasswordField(),
//           _authMode == AuthMode.Signup ? _buildConfirmPasswordField() : Container(),
//           SizedBox(height: 32),
//           ButtonTheme(
//             minWidth: 200,
//             child: RaisedButton(
//               padding: EdgeInsets.all(10.0),
//               child: Text(
//                 'Switch to ${_authMode == AuthMode.Login ? 'Signup' : 'Login'}',
//                 style: TextStyle(fontSize: 20, color: Colors.white),
//               ),
//               onPressed: () {
//                 setState(() {
//                   _authMode =
//                       _authMode == AuthMode.Login ? AuthMode.Signup : AuthMode.Login;
//                 });
//               },
//             ),
//           ),
//           SizedBox(height: 16),
//           ButtonTheme(
//             minWidth: 200,
//             child: RaisedButton(
//               padding: EdgeInsets.all(10.0),
//               onPressed: () => _submitForm(),
//               child: Text(
//                 _authMode == AuthMode.Login ? 'Login' : 'Signup',
//                 style: TextStyle(fontSize: 20, color: Colors.white),
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   ),
// ),
