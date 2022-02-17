import 'package:flutter/material.dart';
import 'package:fyp_project/api/task_api.dart';
import 'package:fyp_project/notifier/task_testing_notifier.dart';
import 'package:fyp_project/sp_payment/existing_cards.dart';
import 'package:fyp_project/sp_payment/services/payment_service.dart';
import 'package:fyp_project/providers/payment.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final double amounttt;

  HomePage({@required this.amounttt});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Payment _payment = Payment();
 
  onItemPress(BuildContext context, int index) async {
    switch (index) {
      case 0:
        //pay via new card
        payViaNewCard(context);

        break;

      case 1:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return ExistingCardsPage(widget.amounttt);
        }));
        break;
    }
  }

  payViaNewCard(BuildContext context) async {
    TaskTestingNotifier tasktestingNotifier =
        Provider.of<TaskTestingNotifier>(context, listen: false);
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(message: 'Please wait....');
    await dialog.show();
    // String amount =
    //     tasktestingNotifier.currentTaskTesting.additionalprice != null
    //         ? ((tasktestingNotifier.currentTaskTesting.additionalprice +
    //                     tasktestingNotifier.currentTaskTesting.price) *
    //                 100).toInt()
    //             .toString()
    //         : (tasktestingNotifier.currentTaskTesting.price*100).toInt().toString();
    var response = await StripeService.payWithNewCard(
        amount: ((widget.amounttt*100)*-1).toInt().toString(),
        currency: 'USD');
    await dialog.hide();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(response.message),
      duration:
          new Duration(milliseconds: response.success == true ? 1200 : 3000),
    ));
    if(response.success){
      updatepaymentstatusintoclear(_payment);
    }
  }

  @override
  void initState() {
    super.initState();
    StripeService.init();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Container(
          padding: EdgeInsets.all(20),
          child: ListView.separated(
            itemBuilder: (context, index) {
              Icon icon;
              Text text;

              switch (index) {
                case 0:
                  icon = Icon(
                    Icons.add_circle,
                    color: theme.primaryColor,
                  );
                  text = Text('Pay via new card');
                  break;

                case 1:
                  icon = Icon(
                    Icons.credit_card,
                    color: theme.primaryColor,
                  );
                  text = Text('Pay via existing card');
                  break;
              }
              return InkWell(
                  onTap: () {
                    onItemPress(context, index);
                  },
                  child: ListTile(
                    title: text,
                    leading: icon,
                  ));
            },
            separatorBuilder: (context, index) => Divider(
              color: theme.primaryColor,
            ),
            itemCount: 2,
          )),
    );
  }
}
