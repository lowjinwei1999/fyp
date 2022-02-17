import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:fyp_project/api/task_api.dart';
import 'package:fyp_project/notifier/task_testing_notifier.dart';
import 'package:fyp_project/sp_payment/services/payment_service.dart';
import 'package:fyp_project/providers/payment.dart';
import 'package:fyp_project/providers/task_testing.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ExistingCardsPage extends StatefulWidget {
  final double amounttt;
  ExistingCardsPage(this.amounttt);
  @override
  _ExistingCardsPageState createState() => _ExistingCardsPageState();
}

class _ExistingCardsPageState extends State<ExistingCardsPage> {
  Payment _payment = Payment();
  List cards = [
    {
      'cardNumber': '4242424242424242',
      'expiryDate': '04/24',
      'cardHolderName': 'Muhammad Ahsan Ayaz',
      'cvvCode': '424',
      'showBackView': false,
    },
    {
      'cardNumber': '555555555554444',
      'expiryDate': '04/23',
      'cardHolderName': 'Tracer',
      'cvvCode': '123',
      'showBackView': false,
    }
  ];

  payViaExistingCard(BuildContext context, card) async {
    TaskTestingNotifier tasktestingNotifier =
        Provider.of<TaskTestingNotifier>(context, listen: false);

    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(message: 'Please wait....');
    await dialog.show();
    var expiryArr = card['expiryDate'].split('/');
    // String amount =
    //     tasktestingNotifier.currentTaskTesting.additionalprice != null
    //         ? ((tasktestingNotifier.currentTaskTesting.additionalprice +
    //                     tasktestingNotifier.currentTaskTesting.price) *
    //                 100).toInt()
    //             .toString()
    //         : (tasktestingNotifier.currentTaskTesting.price*100).toInt().toString();
    CreditCard stripeCard = CreditCard(
      number: card['cardNumber'],
      expMonth: int.parse(expiryArr[0]),
      expYear: int.parse(expiryArr[1]),
    );
    //print(amount);
    var response = await StripeService.payViaExistingCard(
        amount:((widget.amounttt*100)*-1).toInt().toString(), currency: 'USD', card: stripeCard);
    await dialog.hide();
    Scaffold.of(context)
        .showSnackBar(SnackBar(
          content: Text(response.message),
          duration: new Duration(milliseconds: 1200),
        ))
        .closed
        .then((_) {
      Navigator.pop(context);
    });
    if(response.success){
      updatepaymentstatusintoclear(_payment);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Existing Card'),
      ),
      body: Container(
          padding: EdgeInsets.all(20),
          child: ListView.builder(
            itemCount: cards.length,
            itemBuilder: (BuildContext context, int index) {
              var card = cards[index];
              return InkWell(
                onTap: () {
                  payViaExistingCard(context, card);
                },
                child: CreditCardWidget(
                  cardNumber: card['cardNumber'],
                  expiryDate: card['expiryDate'],
                  cardHolderName: card['cardHolderName'],
                  cvvCode: card['cvvCode'],
                  showBackView:
                      false, //true when you want to show cvv(back) view
                ),
              );
            },
          )),
    );
  }
}
