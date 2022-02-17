import 'package:flutter/material.dart';
import 'package:fyp_project/api/task_api.dart';
import 'package:fyp_project/notifier/auth_notifier.dart';
import 'package:fyp_project/notifier/payment_notifier.dart';
import 'package:fyp_project/sp_payment/homepage.dart';
import 'package:fyp_project/sp/widgets/sp_appdrawer.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SpDebitScreen extends StatefulWidget {
  static const routeName = '/sp-debit-screen';
  @override
  _SpDebitScreenState createState() => _SpDebitScreenState();
}

class _SpDebitScreenState extends State<SpDebitScreen> {
  double amount;
  double test = 0;
  bool isLoading = true;
  String debitamounttoprint;
  void initState() {
    PaymentNotifier paymentNotifier =
        Provider.of<PaymentNotifier>(context, listen: false);
    getPayment(paymentNotifier);
    getLeftAmount(paymentNotifier, _onaccumulateunclearList);
    setState(() {
      isLoading = false;
    });
    super.initState();
  }

  _onaccumulateunclearList() {
    //amount =0;
    PaymentNotifier paymentNotifier =
        Provider.of<PaymentNotifier>(context, listen: false);
    double debitamount = 0;
    for (int i = 0; i < paymentNotifier.unclearList.length; i++) {
      if(paymentNotifier.unclearList[i].paymentmethod =='Online Banking'&&paymentNotifier.unclearList[i].status =='Unclear')
      {
         debitamount = debitamount + paymentNotifier.unclearList[i].totalpay;
      }
      else if(paymentNotifier.unclearList[i].paymentmethod =='Cash'&&paymentNotifier.unclearList[i].status =='Unclear'){
          debitamount = debitamount - paymentNotifier.unclearList[i].platformfee;
      }
    }
    
    amount = debitamount;
    debitamounttoprint = debitamount.toStringAsFixed(2);
  }

  String month;
  List<String> _month = [
    "DEFAULT",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12",
  ];

  @override
  Widget build(BuildContext context) {
    PaymentNotifier paymentNotifier = Provider.of<PaymentNotifier>(context);
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);

    return isLoading
        ? Scaffold(
            body: Center(
            child: CircularProgressIndicator(),
          ))
        : Scaffold(
            appBar: AppBar(
              title: Text('Debit/Credit'),
            ),
            drawer: SpAppDrawer(),
            body: Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(
                        left: 20, top: 10, right: 20, bottom: 10),
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(55, 65, 104, 1),
                          // gradient: LinearGradient(
                          //     colors: [Colors.deepPurple[900], Colors.deepPurple]),
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Total Left Debit',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              debitamounttoprint ?? "Calculate...",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 42),
                            ),
                          ],
                        ),
                      ),
                    )),
                //Padding(),]
                Container(
                  padding: EdgeInsets.only(right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[

                      (amount??test)<0.0?
                      GFButton(
                                onPressed: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return HomePage(
                                     amounttt:amount
                                    );
                                  }));
                                },
                                text: "Pay  ",
                                icon: Icon(Icons.money,
                                    color: Colors.white),
                                shape: GFButtonShape.pills,
                                color: Colors.red,
                                size: GFSize.LARGE,
                              )
                              :Container(),
                              SizedBox(width:10),
                      DropdownButton(
                        hint: Text('Filter By Month'),
                        value: month,
                        // style: TextStyle(color: Colors.white),
                        items: _month.map((value) {
                          return DropdownMenuItem(
                            child: Text(value),
                            value: value,
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            month = value;
                            PaymentNotifier paymentNotifier =
                                Provider.of<PaymentNotifier>(context,
                                    listen: false);
                            paymentNotifier.clearfiltertaskresult();
                            getfilterandsortingPayment(paymentNotifier, month);
                          });
                        },
                      ),
                    ],
                  ),
                ),

                paymentNotifier.paymentList.isEmpty
                    ? Center(
                        child: Text(
                          'No Transaction Here',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            // you have time in utc
                            var myDateTime = DateTime.parse(paymentNotifier
                                .paymentList[index].completedAt
                                .toDate()
                                .add(new Duration(hours: 8))
                                .toString());

                            String formattedDateTime =
                                DateFormat('yyyy-MM-dd – kk:mm')
                                    .format(myDateTime);

                            return Padding(
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, top: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color.fromRGBO(55, 65, 104, 1)),
                                  child: ExpansionTile(
                                    childrenPadding: EdgeInsets.only(
                                        left: 16,
                                        right: 16,
                                        top: 10,
                                        bottom: 10),
                                    trailing: Text(
                                      paymentNotifier.paymentList[index]
                                                  .paymentmethod ==
                                              'Online Banking'
                                          ? '+ ' +
                                              paymentNotifier
                                                  .paymentList[index].totalpay
                                                  .toStringAsFixed(2)
                                          : '- ' +
                                              paymentNotifier.paymentList[index]
                                                  .platformfee
                                                  .toStringAsFixed(2),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 19),
                                    ),
                                    title: Text(
                                      paymentNotifier
                                          .paymentList[index].customername,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    subtitle: Text(
                                      formattedDateTime,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    children: <Widget>[
                                      Container(
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    'Task ID : ',
                                                    style: TextStyle(
                                                        color: Colors.white70),
                                                  ),
                                                  Text(
                                                    paymentNotifier
                                                        .paymentList[index]
                                                        .taskid,
                                                    style: TextStyle(
                                                        color:
                                                            Colors.grey[100]),
                                                  ),
                                                ]),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    paymentNotifier
                                                                .paymentList[
                                                                    index]
                                                                .paymentmethod !=
                                                            'Online Banking'
                                                        ? 'Total Pay : '
                                                        : 'PF : ',
                                                    style: TextStyle(
                                                        color: Colors.white70),
                                                  ),
                                                  Text(
                                                    paymentNotifier
                                                                .paymentList[
                                                                    index]
                                                                .paymentmethod !=
                                                            'Online Banking'
                                                        ? paymentNotifier
                                                            .paymentList[index]
                                                            .totalpay
                                                            .toStringAsFixed(2)
                                                        : paymentNotifier
                                                            .paymentList[index]
                                                            .platformfee
                                                            .toStringAsFixed(2),
                                                    style: TextStyle(
                                                        color:
                                                            Colors.grey[100]),
                                                  ),
                                                ]),
                                            // Row(children: <Widget>[
                                            //   Text('Payment ID : '),
                                            //   Text(paymentNotifier
                                            //       .paymentList[index].paymentid),
                                            // ]),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    'Total Amount : ',
                                                    style: TextStyle(
                                                        color: Colors.white70),
                                                  ),
                                                  Text(
                                                    paymentNotifier
                                                        .paymentList[index]
                                                        .totalamount
                                                        .toStringAsFixed(2),
                                                    style: TextStyle(
                                                        color:
                                                            Colors.grey[100]),
                                                  ),
                                                ]),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    'Payment Method : ',
                                                    style: TextStyle(
                                                        color: Colors.white70),
                                                  ),
                                                  Text(
                                                    paymentNotifier
                                                        .paymentList[index]
                                                        .paymentmethod,
                                                    style: TextStyle(
                                                        color:
                                                            Colors.grey[100]),
                                                  ),
                                                ]),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ));
                          },
                          itemCount: paymentNotifier.paymentList.length,
                        ),
                      )
              ],
            ),
          );
  }
}
