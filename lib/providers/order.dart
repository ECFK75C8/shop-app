import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../providers/cart.dart';
import '../models/deleted_order.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    this.id,
    this.amount,
    this.products,
    this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders => [..._orders];

  Future<void> loadOrders() async {
    const url = 'https://shop-app-ba750.firebaseio.com/orders.json';

    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if(responseData == null) return;
      List<OrderItem> loadedOrders = [];
      responseData.forEach((orderId, orderData) {
        loadedOrders.add(OrderItem(
            id: orderId,
            amount: orderData['amount'],
            products: orderData['products'],
            dateTime: orderData['dateTime']));
      });
      _orders = loadedOrders;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addOrder(List<CartItem> items, double total) async {
    const url = 'https://shop-app-ba750.firebaseio.com/orders.json';

    try {
      var timestamp = DateTime.now();
      final response = await http.post(url,
          body: json.encode({
            'amount': total,
            'dateTime': timestamp.toIso8601String(),
            'products': items.map((ct)=>{
              'id': ct.id,
              'title': ct.title,
              'price': ct.price,
              'quantity': ct.quantity,
            }).toList()
          }));
      _orders.insert(
          0,
          OrderItem(
              id: json.decode(response.body)['name'],
              amount: total,
              products: items,
              dateTime: timestamp));
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  void returnDeleted(DeletedOrder item) {
    _orders.insert(item.index, item.orderItem);
    notifyListeners();
  }

  DeletedOrder deleteOrder(String id) {
    var index = _orders.indexWhere((ord) => ord.id == id);
    var item = _orders.removeAt(index);
    notifyListeners();
    return DeletedOrder(index, item);
  }
}
