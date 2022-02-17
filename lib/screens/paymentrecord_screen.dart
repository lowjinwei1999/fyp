import 'package:flutter/material.dart';
import 'package:fyp_project/api/task_api.dart';
import 'package:fyp_project/notifier/payment_notifier.dart';
import 'package:fyp_project/widgets/app_drawer.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PaymentRecordScreen extends StatefulWidget {
   static const routeName = '/payment-record-screen';
  @override
  _PaymentRecordScreenState createState() => _PaymentRecordScreenState();
}

class _PaymentRecordScreenState extends State<PaymentRecordScreen> {
   bool isLoading = true;
    void initState() {
    PaymentNotifier paymentNotifier =
        Provider.of<PaymentNotifier>(context, listen: false);
    getCustomerPaymentRecord(paymentNotifier);
    setState(() {
      isLoading = false;
    });
    super.initState();
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
     return isLoading
        ? Scaffold(
            body: Center(
            child: CircularProgressIndicator(),
          ))
        : Scaffold(
            appBar: AppBar(
              title: Text('Payment Record'),
            ),
            drawer: AppDrawer(),
            body: Column(
              children: <Widget>[
                
                //Padding(),]
                Container(
                  padding: EdgeInsets.only(right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
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
                            getfilterandsortingCustomerPayment(paymentNotifier, month);
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
                                .add(new Duration(hours: 0))
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
                                                  .totalamount
                                                  .toStringAsFixed(2),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 19),
                                    ),
                                    title: Text(
                                      paymentNotifier
                                          .paymentList[index].spname,
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