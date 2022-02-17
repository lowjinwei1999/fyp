import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:fyp_project/api/task_api.dart';
import 'package:fyp_project/providers/payment.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:stripe_payment/stripe_payment.dart';
import '../../notifier/task_testing_notifier.dart';

  
class StripeTransactionResponse {
  String message;
  bool success;
  StripeTransactionResponse({this.message, this.success});
}

class StripeService {
 
  static String apiBase = 'https://api.stripe.com/v1';
  static String payemntApiUrl = '${StripeService.apiBase}/payment_intents';
  static String secret =
      'sk_test_51HsUZTL7n0XSuhvJ2jGHE7AHNKUWrEwZJS1SeJ5ZCeFAIDzAPgEkO7k3E6sTZqwQKPC6lE5HmE8SJ2XdrbaJYaLm00RZopqRN1';
  static Map<String, String> headers = {
    'Authorization': 'Bearer ${StripeService.secret}',
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  static init() {
    StripePayment.setOptions(StripeOptions(
        publishableKey:
            "pk_test_51HsUZTL7n0XSuhvJTEnvA7WUndHiVJFsmk9TphQeqes43xvWGKMnqXwqprsEs8Lae8Nu82Oee7PQIQjR1a0i1sVR0037rcZE0x",
        merchantId: "Test",
        androidPayMode: 'test'));
  }

  static Future<StripeTransactionResponse> payViaExistingCard(
      {String amount, String currency, CreditCard card}) async {
         
    try {
      var paymentMethod = await StripePayment.createPaymentMethod(
          PaymentMethodRequest(card: card));
      var paymentIntent =
          await StripeService.createPaymentIntent(amount, currency);

      var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
        clientSecret: paymentIntent['client_secret'],
        paymentMethodId: paymentMethod.id,
      ));
      if (response.status == 'succeeded') { 
        
        return new StripeTransactionResponse(
            message: 'Transaction Success', success: true);
         
      } else {
        return new StripeTransactionResponse(
            message: 'Transaction Failed', success: false);
      }
    } on PlatformException catch (err) {
      return StripeService.getPlatformExceptionErrorResult(err);
    } catch (err) {
      return new StripeTransactionResponse(
          message: 'Transactin Failed:${err.toString()}', success: false);
    }
  }

  static Future<StripeTransactionResponse> payWithNewCard(
      {String amount, String currency}) async {
    try {
      var paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest());
      var paymentIntent =
          await StripeService.createPaymentIntent(amount, currency);

      var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
        clientSecret: paymentIntent['client_secret'],
        paymentMethodId: paymentMethod.id,
      ));
      if (response.status == 'succeeded') {
        
        return new StripeTransactionResponse(
            message: 'Transactin Success', success: true);
          
      } else {
        return new StripeTransactionResponse(
            message: 'Transactin Failed', success: false);
      }
    } on PlatformException catch (err) {
      return StripeService.getPlatformExceptionErrorResult(err);
    } catch (err) {
      return new StripeTransactionResponse(
          message: 'Transactin Failed:${err.toString()}', success: false);
    }
  }

  static getPlatformExceptionErrorResult(err) {
    String message = 'Something went wrong';
    if (err.code == 'cancelled') {
      message = 'Transaction Cancelled';
    }
    return new StripeTransactionResponse(
      message: message,
      success: false,
    );
  }

  static Future<Map<String, dynamic>> createPaymentIntent(
      String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(StripeService.payemntApiUrl,
          body: body, headers: StripeService.headers);
      return jsonDecode(response.body);
    } catch (err) {
      print('err charing user: ${err.toString()}');
    }
    return null;
  }
}
