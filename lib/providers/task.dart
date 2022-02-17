
import 'package:flutter/foundation.dart';

class Task with ChangeNotifier {
  final String id;
  final String taskname;
  final String category;
  final double price;
  final String description;
  final String address;
  final String time;
  final String date;
  // final String customerId;
  // final String spId;
  final String status;
  final String imageUrl;
  

  Task({
    @required this.id,
    @required this.taskname,
    @required this.category,
    @required this.price,
    @required this.description,
    @required this.address,
    @required this.time,
    @required this.date,
    // @required this.customerId,
    // @required this.spId,
    @required this.status,
    @required this.imageUrl,
    
  });

}
