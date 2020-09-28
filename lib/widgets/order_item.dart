import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as orderModel;

class OrderItem extends StatefulWidget {
  final orderModel.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  @override
  void initState() {}
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title:
                Text('Order Total: \$${widget.order.total.toStringAsFixed(2)}'),
            subtitle: Text(DateFormat('MMMM dd, yyyy  hh:mm')
                .format(widget.order.dateTime)),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            height: _expanded ? min(widget.order.products.length * 23.0 + 10, 100) : 0,
            child: ListView(
              children: widget.order.products
                  .map((prod) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            prod.title,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor),
                          ),
                          Text(
                            '\$${prod.price.toStringAsFixed(2)} X ${prod.quantity}',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
