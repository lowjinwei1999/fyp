import 'dart:collection';
import 'package:flutter/material.dart';

import '../providers/payment.dart';

class PaymentNotifier with ChangeNotifier {
  List<Payment> _paymentList = [];

  List<Payment> _unclearList = [];

  UnmodifiableListView<Payment> get paymentList =>
      UnmodifiableListView(_paymentList);

  set paymentList(List<Payment> paymentList) {
    _paymentList = paymentList;
    //notify the apps that have change
    notifyListeners();
  }

  UnmodifiableListView<Payment> get unclearList =>
      UnmodifiableListView(_unclearList);

  set unclearList(List<Payment> unclearList) {
    _unclearList = unclearList;
    //notify the apps that have change
    notifyListeners();
  }

  addPayment(Payment payment) {
    _paymentList.add(payment);
    notifyListeners();
  }
 

  double debitamount;
 double get sdebitamount => debitamount;
  accumulateunclearList() {
    double debitamount = 0;
    for (int i = 0; i < _unclearList.length; i++) {
      if(_unclearList[i].paymentmethod =='Online Banking')
      {
         debitamount = debitamount + _unclearList[i].totalpay;
      }
      else if(_unclearList[i].paymentmethod =='Cash'){
          debitamount = debitamount - _unclearList[i].platformfee;
      }
    
    }
     print(debitamount);
  }

  clearfiltertaskresult()
{
  _paymentList.clear();
}




}
