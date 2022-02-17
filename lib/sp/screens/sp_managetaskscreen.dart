import 'package:flutter/material.dart';
import 'package:fyp_project/notifier/auth_notifier.dart';
import 'package:fyp_project/notifier/task_testing_notifier.dart';
import 'package:fyp_project/sp/screens/sp_acceptedtasklist.dart';
import 'package:fyp_project/sp/widgets/sp_appdrawer.dart';
import 'package:fyp_project/api/task_api.dart';
import 'package:provider/provider.dart';

class SpTaskManageScreen extends StatefulWidget {
  static const routeName = '/sp_taskmanagescreen';
  @override
  _SpTaskManageScreenState createState() => _SpTaskManageScreenState();
}

class _SpTaskManageScreenState extends State<SpTaskManageScreen> {

void initState() {
    TaskTestingNotifier tasktestingNotifier =
        Provider.of<TaskTestingNotifier>(context, listen: false);
    getAcceptedTask(tasktestingNotifier);
    setState(() { 
        //  isLoading = false;
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TaskTestingNotifier tasktestingNotifier =
        Provider.of<TaskTestingNotifier>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Task'),
      ),
      drawer: SpAppDrawer(),
     body: 
     SpAcceptedTaskList(),
      
    );
  }
}