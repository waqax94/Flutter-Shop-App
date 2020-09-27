import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/main_drawer.dart';

class OrderPage extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  Future _orderFuture;

  Future _obtainFuture() {
    return Provider.of<Orders>(context, listen: false).getAndSetOrders();
  }

  @override
  void initState() {
    _orderFuture = _obtainFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text("Your Orders"),
        ),
        drawer: MainDrawer(),
        body: FutureBuilder(
          future: _orderFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
              );
            } else {
              if (snapshot.error != null) {
                return Center(
                  child: Text('Error occured'),
                );
              } else {
                return Consumer<Orders>(
                  builder: (ctx, orderData, child) {
                    return ListView.builder(
                      itemCount: orderData.orders.length,
                      itemBuilder: (context, index) => OrderItem(
                        orderData.orders[index],
                      ),
                    );
                  },
                );
              }
            }
          },
        ));
  }
}
