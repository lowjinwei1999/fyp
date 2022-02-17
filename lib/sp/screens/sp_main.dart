import 'package:flutter/material.dart';
import 'package:fyp_project/api/task_api.dart';
import 'package:fyp_project/notifier/auth_notifier.dart';
import 'package:fyp_project/notifier/chat_notifiier.dart';
import 'package:fyp_project/notifier/comment_notifier.dart';
import 'package:fyp_project/notifier/task_testing_notifier.dart';
import 'package:fyp_project/providers/comment.dart';
import 'package:fyp_project/sp/screens/sp_tasklistscreen.dart';
import 'package:fyp_project/sp/widgets/sp_appdrawer.dart';
import 'package:provider/provider.dart';

class SpMain extends StatefulWidget {
  static const routeName = '/sp_main';

  @override
  _SpMainState createState() => _SpMainState();
}

class _SpMainState extends State<SpMain> {
bool init = true;

void didChangeDependency()
{
  if(init)
  {
    CommentNotifier commentNotifier =
        Provider.of<CommentNotifier>(context, listen: false);
        commentNotifier.clearviewedcomment();
    _removeallchatroomlist();
  }
  setState(() {
    init = false;
  });
  
}


  void initState() {
    CommentNotifier commentNotifier =
        Provider.of<CommentNotifier>(context, listen: false);
        commentNotifier.clearviewedcomment();
    _removeallchatroomlist();
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    getUserData(authNotifier);
    TaskTestingNotifier tasktestingNotifier =
        Provider.of<TaskTestingNotifier>(context, listen: false);
    getTaskPending(tasktestingNotifier);
    ChatNotifier chatNotifier =
        Provider.of<ChatNotifier>(context, listen: false);
    
      

    setState(() {
      //  isLoading = false;
    });
    super.initState();
  }

  _removeallchatroomlist() {
    ChatNotifier chatNotifier =
        Provider.of<ChatNotifier>(context, listen: false);
    chatNotifier.clearchatroomlist();
    chatNotifier.clearchatroomlist();
  }

  List<String> _locations = [
    "DEFAULT",
    "INSTALLATION",
    "PLUMBING",
    "ELECTRICAL WIRING",
    "HOME REPAIR",
    "PAINTING",
    "LANDSCAPE",
  ];
  List<String> _district = [
    "DEFAULT",
    "Johor Bahru",
    "Kulai",
    "Batu Pahat",
    "Kluang",
    "Kota Tinggi",
    "Mersing",
    "Muar",
    "Pontin",
    "Segamat",
    "Tangkak"
  ];
  List<String> _pricearrangement = [
    "Low to High",
    "High to Low",
  ];
  String category;
  String district;
  String pricearrangement;

  Widget _buildcategoryField() {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(
          //crossAxisAlignment: CrossAxisAlignment.,
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  DropdownButton(
                    hint: Text('Filter By Category'),
                    value: category,
                    items: _locations.map((value) {
                      return DropdownMenuItem(
                        child: Text(value),
                        value: value,
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        category = value;
                        TaskTestingNotifier tasktestingNotifier =
                            Provider.of<TaskTestingNotifier>(context,
                                listen: false);
                        tasktestingNotifier.clearfiltertaskresult();
                        getfilterandsortingTask(tasktestingNotifier,
                            pricearrangement, category, district);
                        //filter new list of task data
                      });
                    },
                  ),
                  DropdownButton(
                    hint: Text('Filter By District'),
                    value: district,
                    // style: TextStyle(color: Colors.white),
                    items: _district.map((value) {
                      return DropdownMenuItem(
                        child: Text(value),
                        value: value,
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        district = value;
                        TaskTestingNotifier tasktestingNotifier =
                            Provider.of<TaskTestingNotifier>(context,
                                listen: false);
                        tasktestingNotifier.clearfiltertaskresult();
                        getfilterandsortingTask(tasktestingNotifier,
                            pricearrangement, category, district);
                      });
                    },
                  ),
                ]),
            DropdownButton(
              hint: Text('Sort by Price'),
              value: pricearrangement,
              // style: TextStyle(color: Colors.white),
              items: _pricearrangement.map((value) {
                return DropdownMenuItem(
                  child: Text(value),
                  value: value,
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  pricearrangement = value;
                  if (pricearrangement == 'Low to High') {
                    TaskTestingNotifier tasktestingNotifier =
                        Provider.of<TaskTestingNotifier>(context,
                            listen: false);
                    tasktestingNotifier.clearfiltertaskresult();
                    getfilterandsortingTask(tasktestingNotifier,
                        pricearrangement, category, district);
                  } else if (pricearrangement == 'High to Low') {
                    TaskTestingNotifier tasktestingNotifier =
                        Provider.of<TaskTestingNotifier>(context,
                            listen: false);
                    tasktestingNotifier.clearfiltertaskresult();
                    getfilterandsortingTask(tasktestingNotifier,
                        pricearrangement, category, district);
                  }
                });
              },
            ),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('WE DO'), elevation: 0),
      drawer: SpAppDrawer(),
      body: Column(children: <Widget>[
        _buildcategoryField(),
        Expanded(child: SpTaskListScreen())
      ]),
    );
  }
}
