import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:fyp_project/widgets/create_agreement.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp_project/api/task_api.dart';
import 'package:fyp_project/notifier/task_testing_notifier.dart';
import 'package:fyp_project/providers/task_testing.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/task_testing.dart';
import 'package:checkbox_formfield/checkbox_formfield.dart';

class TaskFormTesting extends StatefulWidget {
  final bool isUpdating;

  TaskFormTesting({@required this.isUpdating});

  @override
  _TaskFormTestingState createState() => _TaskFormTestingState();
}

class _TaskFormTestingState extends State<TaskFormTesting> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController dateCtl = TextEditingController();
  TextEditingController timeCtl = TextEditingController();
  //here current task will be different from the tasknteting notifier
  TaskTesting _currentTaskTesting;
  String _imageUrl;
  File _imageFile;
  //this is use for subingredient if no nid just put //
  // List _subingredients = [];
  // TextEditingController subingredientController = new TextEditingController();

//auto ran b4 we build the widget tree
  @override
  void initState() {
    super.initState();
    TaskTestingNotifier tasktestingNotifier =
        Provider.of<TaskTestingNotifier>(context, listen: false);

    //it gonna be current task or new instance of task
    if (tasktestingNotifier.currentTaskTesting != null) {
      _currentTaskTesting = tasktestingNotifier.currentTaskTesting;
    } else {
      _currentTaskTesting = new TaskTesting();
    }
    // _subingredient.addAll(_currentTaskTesting.subingredient);
    _imageUrl = _currentTaskTesting.imageUrl;
    dateCtl.text = _currentTaskTesting.date;
    timeCtl.text = _currentTaskTesting.time;
  }

  _showImage() {
    if (_imageFile == null && _imageUrl == null) {
      return Text('Image From Placeholder');
    } else if (_imageFile != null) {
      print('Showing Image From Local File');

      return Column(
        ///alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.file(
            _imageFile,
            fit: BoxFit.cover,
            height: 200,
          ),
          FlatButton.icon(
              textColor: Theme.of(context).primaryColor,
              icon: Icon(Icons.edit),
              label: Text('Change Image'),
              onPressed: () => _getLocalImage(context)),
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
          Container(
            alignment: Alignment.center,
            // decoration: BoxDecoration(
            //     border: Border.all(color: Colors.blueAccent)),
            width: 200,
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 30.5),
            child: FlatButton.icon(
                textColor: Theme.of(context).primaryColor,
                icon: Icon(Icons.edit),
                label: Text('Edit Image'),
                onPressed: () => _getLocalImage(context)),
          ),
        ],
      );
    }
  }

//to get the image from local gallery
  _getLocalImage(context) async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });

    // if (imageFile != null) {
    //   setState(() {
    //     _imageFile = imageFile;
    //   });
    // }
  }

  void _imgFromGallery() async {
    final imageFile = await ImagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
        maxWidth: 300,
        maxHeight: 300);
    if (imageFile != null) {
      setState(() {
        _imageFile = imageFile;
      });
    }
  }

  void _imgFromCamera() async {
    final imageFile = await ImagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
        maxWidth: 300,
        maxHeight: 300);
    if (imageFile != null) {
      setState(() {
        _imageFile = imageFile;
      });
    }
  }

  _saveTask() {
    //print('save task call');
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    uploadTaskAndImage(
        _currentTaskTesting, widget.isUpdating, _imageFile, _onTaskUploaded);
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
              decoration: InputDecoration(labelText: "Task Name"),
              initialValue: _currentTaskTesting.taskname,
              keyboardType: TextInputType.text,
              style: TextStyle(fontSize: 16),
              validator: (String value) {
                if (value.isEmpty) {
                  return "Name is required";
                }
                if (value.length < 3 || value.length > 20) {
                  return "Name must more than three or less than 20";
                }
                return null;
              },
              onSaved: (String value) {
                _currentTaskTesting.taskname = value;
              },
            ),
          ),
        ],
      ),
    );
  }

  List<String> _locations = [
    "INSTALLATION",
    "PLUMBING",
    "ELECTRICAL WIRING",
    "HOME REPAIR",
    "PAINTING",
    "LANDSCAPE",
  ];

  Widget _buildcategoryField() {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Icon(
              Icons.search,
              color: Colors.grey,
            ),
          ),
          SizedBox(width: 7),
          Flexible(
            child: DropdownButtonFormField(
              decoration: InputDecoration(labelText: 'Category'),
              //hint: Text('Please choose a location'), // Not necessary for Option 1
              value: _currentTaskTesting.category,
              onSaved: (String value) {
                _currentTaskTesting.category = value;
              },
              onChanged: (newValue) {
                setState(() {
                  _currentTaskTesting.category = newValue;
                });
              },
              items: _locations.map((location) {
                return DropdownMenuItem(
                  child: new Text(location),
                  value: location,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  List<String> _district = [
    "Johor Bahru",
    "Kulai",
    "Batu Pahat",
    "Kluang",
    "Kota Tinggi",
    "Mersing",
    "Muar",
    "Pontian",
    "Segamat",
    "Tangkak"
  ];

  Widget _builddistrictField() {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Icon(
              Icons.location_searching,
              color: Colors.grey,
            ),
          ),
          SizedBox(width: 7),
          Flexible(
            child: DropdownButtonFormField(
              decoration: InputDecoration(labelText: 'District'),
              //hint: Text('Please choose a location'), // Not necessary for Option 1
              value: _currentTaskTesting.district,
              onSaved: (String value) {
                _currentTaskTesting.district = value;
              },
              onChanged: (newValue) {
                setState(() {
                  _currentTaskTesting.district = newValue;
                });
              },
              items: _district.map((district) {
                return DropdownMenuItem(
                  child: new Text(district),
                  value: district,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildpriceField() {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Icon(
              Icons.attach_money_rounded,
              color: Colors.grey,
            ),
          ),
          SizedBox(width: 7),
          Flexible(
            child: TextFormField(
              readOnly: _currentTaskTesting.status == 'Ongoing' ? true : false,
              decoration: InputDecoration(labelText: "Price"),
              initialValue: _currentTaskTesting.price == null
                  ? ''
                  : _currentTaskTesting.price.toString(),
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 16),
              validator: (value) {
                if (value == '') {
                  return 'Please enter a price.';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number.';
                }
                if (double.parse(value) <= 0) {
                  return 'Please enter a number greater than zero.';
                }
                if (double.parse(value) > 2000) {
                  return 'The maximum price range is 2000';
                }
                return null;
              },
              onSaved: (value) {
                _currentTaskTesting.price = double.parse(value);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildadditionalpriceField() {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Icon(
              Icons.add,
              color: Colors.grey,
            ),
          ),
          SizedBox(width: 7),
          Flexible(
            child: TextFormField(
              decoration: InputDecoration(labelText: "Additional Price"),
              initialValue: _currentTaskTesting.additionalprice == null
                  ? ''
                  : _currentTaskTesting.additionalprice.toString(),
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 16),
              validator: (value) {
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number.';
                }
                if (double.parse(value) <= 0) {
                  return 'Please enter a number greater than zero.';
                }
                return null;
              },
              onSaved: (value) {
                _currentTaskTesting.additionalprice = double.parse(value);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildaddressField() {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Icon(
              Icons.location_city_rounded,
              color: Colors.grey,
            ),
          ),
          SizedBox(width: 7),
          Flexible(
            child: TextFormField(
              decoration: InputDecoration(labelText: "Address"),
              initialValue: _currentTaskTesting.address,
              keyboardType: TextInputType.text,
              style: TextStyle(fontSize: 16),
              validator: (String value) {
                if (value.isEmpty) {
                  return "Address is required";
                }
                return null;
              },
              onSaved: (String value) {
                _currentTaskTesting.address = value;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _builddescriptionField() {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Icon(
              Icons.file_copy,
              color: Colors.grey,
            ),
          ),
          SizedBox(width: 7),
          Flexible(
            child: TextFormField(
              decoration: InputDecoration(labelText: "Description"),
              initialValue: _currentTaskTesting.description,
              keyboardType: TextInputType.text,
              style: TextStyle(fontSize: 16),
              validator: (String value) {
                if (value.isEmpty) {
                  return "Description is required";
                }
                return null;
              },
              onSaved: (String value) {
                _currentTaskTesting.description = value;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildstatusField() {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Icon(
              Icons.stairs,
              color: Colors.grey,
            ),
          ),
          SizedBox(width: 7),
          Flexible(
            child: TextFormField(
              readOnly: true,
              decoration: InputDecoration(labelText: "Status"),
              initialValue: _currentTaskTesting.status != null
                  ? _currentTaskTesting.status
                  : 'Pending',
              keyboardType: TextInputType.text,
              style: TextStyle(fontSize: 16),
              onSaved: (String value) {
                _currentTaskTesting.status = value;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _builddateField() {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Icon(
              Icons.date_range_rounded,
              color: Colors.grey,
            ),
          ),
          SizedBox(width: 7),
          Flexible(
            child: TextFormField(
              controller: dateCtl,
              decoration: InputDecoration(
                labelText: "Date",
                hintText: "Ex. Insert your task date",
              ),
              onTap: () async {
                DateTime date = DateTime(1900);

                date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100));

                // dateCtl.text = date.toIso8601String();
                dateCtl.text = DateFormat("yyyy-MM-dd").format(date);
                // dateCtl.text = new DateFormat("yyyy-MM-dd").format({date});
              },
               validator: (value) {
                if (value.isEmpty) {
                  return 'Please choose a date';
                }
                return null;
              },
              onSaved: (String value) {
                _currentTaskTesting.date = value;
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildtimeField() {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Icon(
              Icons.access_time_rounded,
              color: Colors.grey,
            ),
          ),
          SizedBox(width: 7),
          Flexible(
            child: TextFormField(
              controller: timeCtl,
              decoration: InputDecoration(
                labelText: "Time",
                hintText: "Ex. Insert your task time",
              ),
              onTap: () async {
                TimeOfDay time = TimeOfDay.now();
                TimeOfDay picked =
                    await showTimePicker(context: context, initialTime: time);

                if (picked != null && picked != time) {
                  timeCtl.text = picked.toString(); // add this line.
                  setState(() {
                    time = picked;
                  });
                }
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please choose a time';
                }
                return null;
              },
              onSaved: (String value) {
                _currentTaskTesting.time = value;
              },
            ),
          )
        ],
      ),
    );
  }

  List<String> _paymentmethod = [
    "Cash",
    "Online Banking",
  ];

  Widget _buildpaymentmethodField() {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Icon(
              Icons.atm,
              color: Colors.grey,
            ),
          ),
          SizedBox(width: 7),
          Flexible(
            child: DropdownButtonFormField(
              decoration: InputDecoration(labelText: 'Payment Method'),
              //hint: Text('Please choose a location'), // Not necessary for Option 1
              value: _currentTaskTesting.paymentmethod,
              
              onSaved: (String value) {
                _currentTaskTesting.paymentmethod = value;
              },
              onChanged: (newValue) {
                setState(() {
                  _currentTaskTesting.paymentmethod = newValue;
                });
              },
              items: _paymentmethod.map((location) {
                return DropdownMenuItem(
                  child: new Text(location),
                  value: location,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildtermsandcondition() {
    return CheckboxListTileFormField(
      title: Text.rich(
        TextSpan(
            text: 'I  agree to ',
            style: TextStyle(fontSize: 13),
            children: <TextSpan>[
              TextSpan(
                  text: 'Terms and Condition',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return CreateAgreement();
                      }));
                    })
            ]),
      ),
      onSaved: (bool value) {},
      validator: (bool value) {
        if (value) {
          return null;
        } else {
          return 'You Are Required To Thick';
        }
      },
    );
  }

  _onTaskUploaded(TaskTesting tasktesting) {
    TaskTestingNotifier tasktestingNotifier =
        Provider.of<TaskTestingNotifier>(context, listen: false);
    tasktestingNotifier.addTask(tasktesting);
    Navigator.pop(context);
  }

  // _buildSubingredientField() {
  //   return SizedBox(
  //     width: 200,
  //     child: TextField(
  //       controller: subingredientController,
  //       keyboardType: TextInputType.text,
  //       decoration: InputDecoration(labelText: 'Subingredient'),
  //       style: TextStyle(fontSize: 20),
  //     ),
  //   );
  // }

  // _addSubingredient(String text){
  //   if(text.isNotEmpty){
  //     setState(() {
  //       _subingredients.add(text);
  //     });
  //     subingredientController.clear();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isUpdating ? "Edit Task" : 'Create Task',
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(28),
        child: Form(
          key: _formKey,
          //autovalidate: true,
          child: Column(
            children: <Widget>[
              _showImage(),
              SizedBox(height: 5),
              Text(
                widget.isUpdating ? "Edit Task" : 'Create Task',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
              SizedBox(height: 2),
              _imageFile == null && _imageUrl == null
                  ? Container(
                      alignment: Alignment.center,
                      // decoration: BoxDecoration(
                      //     border: Border.all(color: Colors.blueAccent)),
                      width: 200,
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 30.5),
                      child: FlatButton.icon(
                        textColor: Theme.of(context).primaryColor,
                        icon: Icon(Icons.image),
                        label: Text('Add Image'),
                        onPressed: () => _getLocalImage(context),
                      ))
                  : SizedBox(
                      height: 0,
                    ),
              _buildnameField(),
              _buildcategoryField(),
              _buildpriceField(),

              _currentTaskTesting.status == 'Ongoing'
                  ? _buildadditionalpriceField()
                  : Container(),
              _buildaddressField(),
              _builddistrictField(),
              _builddescriptionField(),
              _builddateField(),
              _buildtimeField(),
              _buildpaymentmethodField(),
              _buildstatusField(),
               widget.isUpdating ?Container():
              _buildtermsandcondition(),
              //_buildUseridField(),
              SizedBox(
                height: 0,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: <Widget>[
              //     _buildSubingredientField(),
              //     ButtonTheme(
              //       child: RaisedButton(
              //         child:
              //             Text('Add', style: TextStyle(color: Colors.white)),
              //         onPressed: () {
              //           _addSubingredient(subingredientController.text);
              //         },
              //       ),
              //     )
              //   ],
              // )
              // GridView.count(
              //   shrinkWrap: true,
              //   scrollDirection: Axis.vertical,
              //   padding: EdgeInsets.all(8),
              //   crossAxisCount: 3,
              //   crossAxisSpacing: 4,
              //   mainAxisSpacing: 4,
              //   children: _subingredients
              //       .map(
              //         (ingredient) => Card(
              //           color: Colors.black54,
              //           child: Center(
              //             child: Text(
              //               ingredient,
              //               style: TextStyle(color: Colors.white, fontSize: 16),
              //             ),
              //           ),
              //         ),
              //       )
              //       .toList(),
              // )
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
