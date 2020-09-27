import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './cart.dart';

class OrderItem {
  final String id;
  final List<CartItem> products;
  final double total;
  final DateTime dateTime;

  OrderItem({
    this.id,
    this.products,
    this.total,
    this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String token;
  final String userId;

  Orders(this.token, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> getAndSetOrders() async {
    final url =
        'https://flutter-shop-app-42d9f.firebaseio.com/orders/$userId.json?auth=$token';

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<OrderItem> loadedOrders = [];
      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(
          OrderItem(
            id: orderId,
            dateTime: DateTime.parse(
              orderData['dateTime'],
            ),
            total: orderData['total'],
            products: (orderData['products'] as List<dynamic>)
                .map(
                  (item) => CartItem(
                    id: item['id'],
                    price: item['price'],
                    quantity: item['quantity'],
                    title: item['title'],
                  ),
                )
                .toList(),
          ),
        );
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addOrder(double total, List<CartItem> products) async {
    final url =
        'https://flutter-shop-app-42d9f.firebaseio.com/orders/$userId.json?auth=$token';
    final timeStamp = DateTime.now();

    try {
      final response = await http.post(url,
          body: json.encode({
            'dateTime': timeStamp.toIso8601String(),
            'total': total,
            'products': products
                .map((cartItem) => {
                      'id': cartItem.id,
                      'price': cartItem.price,
                      'title': cartItem.title,
                      'quantity': cartItem.quantity,
                    })
                .toList(),
          }));

      _orders.insert(
          0,
          OrderItem(
            id: json.decode(response.body)['name'],
            dateTime: timeStamp,
            total: total,
            products: products,
          ));
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }
}
