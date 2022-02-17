import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fyp_project/api/task_api.dart';
import 'package:fyp_project/notifier/auth_notifier.dart';
import 'package:provider/provider.dart';
import '../providers/user.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {


  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  User _currentUser;
  String _imageUrl;
  File _imageFile;

 @override
    void initState() {
    super.initState();
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    //it gonna be current task or new instance of task
    if (authNotifier.currentUser != null) {
      _currentUser = authNotifier.currentUser;
    } else {
      _currentUser = new User();
    }
    _imageUrl = _currentUser.imageUrl;
  }

  _showImage() {
    if (_imageFile == null && _imageUrl == null) {
      return CircleAvatar(
        radius: 60,
        backgroundColor: Colors.white,
        backgroundImage: NetworkImage(
            'https://cdn2.iconfinder.com/data/icons/facebook-51/32/FACEBOOK_LINE-01-512.png'),
      );
    } else if (_imageFile != null) {
      print('Showing Image From Local File');

      return Column(
       // alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.file(
            _imageFile,
            fit: BoxFit.cover,
            height: 250,
          ),
             ButtonTheme(
                      child: FlatButton.icon(
                        textColor: Theme.of(context).primaryColor,
                        icon: Icon(Icons.image),
                        onPressed: () => _getLocalImage(),
                        label: Text('Change Image'),
                      ),
                    )
        ],
      );
    } else if (_imageUrl != null) {
      print('showing image from url');

      return Column(
        //alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.network(
            _imageUrl,
            fit: BoxFit.cover,
            height: 200,
          ),
         ButtonTheme(
                      child: FlatButton.icon(
                        textColor: Theme.of(context).primaryColor,
                        icon: Icon(Icons.image),
                        onPressed: () => _getLocalImage(),
                        label: Text('Change Image'),
                      ),
                    )
        ],
      );
    }
  }

//to get the image from local gallery
  _getLocalImage() async {
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 400);

    if (imageFile != null) {
      setState(() {
        _imageFile = imageFile;
      });
    }
  }

  _saveForm() {
    //print('Update User call');
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    //print('form saved');
    //_currentTaskTesting.subIngredient = _subIngredient;
    updateUserAndImage(_currentUser,  _imageFile, _onUserUploaded);

    // print("name: ${_currentUser.name}");
    // print("Tel: ${_currentUser.tel}");
    // //print("subingredients ${_currentTaskTesting.subIngredient.toString()}");
    // print("_imageFile: ${_imageFile.toString()}");
    // print("_imageUrl: $_imageUrl");
  }

  _onUserUploaded(User user){
   AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
          // tasktestingNotifier.updateTask(tasktesting);
          // Navigator.pop(context);
      authNotifier.updateUser(user);
      print('onUserUploaded is running');
      Navigator.pop(context);
      
  }

  Widget _buildnameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Name"),
      initialValue: _currentUser.name,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 14),
      onSaved: (String value) {
        _currentUser.name = value;
      },
    );
  }

  Widget _buildemailField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Email"),
      readOnly: true,
      initialValue: _currentUser.email,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 14),
      onSaved: (String value) {
        _currentUser.email = value;
      },
    );
  }

  Widget _buildtelField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Phone Number"),
      initialValue: _currentUser.tel,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 14),
      onSaved: (String value) {
        _currentUser.tel = value;
      },
    );
  }

  Widget _buildaddressField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Address"),
      initialValue: _currentUser.address,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 14),
      onSaved: (String value) {
        _currentUser.address = value;
      },
    );
  }

  List<String> _locations = [
    "MAYBANK / MAYBANK ISLAMIC",
    "CIMB BANK BERHAD",
    "HONG LEONG BANK",
    "CITIBANK BERHAD",
    "PUBLIC BANK",
    "RHB BANK",
    "OCBC BANK(MALAYSIA) BHD",
    "HSBC BNK MALAYSIA BERHAD",
    "AmBANK BERHAD",
    "BANK ISLAMIC MALAYSIA",
    "MBSB BANK",
  ]; // Option 2
 
  Widget _buildbanknameField() { 
   // String _selectedLocation= _currentUser.bankname;
    return DropdownButtonFormField(
      decoration: InputDecoration(labelText: 'Bank Name'),
      //hint: Text('Please choose a location'), // Not necessary for Option 1
      value: _currentUser.bankname,
     onSaved: (String value) {
        _currentUser.bankname = value;
      },
      onChanged: (newValue) {
        setState(() {
          _currentUser.bankname = newValue;
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

  Widget _buildaccountnumberField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Bank Account Number"),
      initialValue: _currentUser.accountnumber,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 14),
      onSaved: (String value) {
        _currentUser.accountnumber = value;
      },
    );
  }

  Widget _buildholdernameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Bank Account Holder Name"),
      initialValue: _currentUser.holdername,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 14),
      onSaved: (String value) {
        _currentUser.holdername = value;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('build Edit Profile Screen');
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          autovalidate: true,
          child: Column(
            children: <Widget>[
              _showImage(),
              SizedBox(height: 0),
              _imageFile == null && _imageUrl == null
                  ? ButtonTheme(
                      child: FlatButton.icon(
                        textColor: Theme.of(context).primaryColor,
                        icon: Icon(Icons.image),
                        onPressed: () => _getLocalImage(),
                        label: Text('Add Image'),
                      ),
                    )
                  : SizedBox(
                      height: 0,
                    ),
              _buildemailField(),
              _buildnameField(),
              _buildtelField(),
              _buildaddressField(),
              _buildbanknameField(),
              _buildaccountnumberField(),
              _buildholdernameField(),
            ],
          ),
        ),
      ),
       floatingActionButton: FloatingActionButton(
        onPressed: () => _saveForm(),
        child: Icon(Icons.save),
        foregroundColor: Colors.white,
      ),
    );
  }
}
