import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/pages/auth_page.dart';

import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/auth.dart';
import './pages/splash_page.dart';
import './pages/products_overview_page.dart';
import './pages/product_details_page.dart';
import './pages/cart_page.dart';
import './pages/order_page.dart';
import './pages/user_product_page.dart';
import './pages/edit_product_page.dart';
import './pages/auth_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: null,
          update: (ctx, auth, previousProducts) => Products(
            auth.token,
            auth.userId,
            previousProducts == null ? [] : previousProducts.items,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: null,
          update: (context, auth, previousOrders) => Orders(
            auth.token,
            auth.userId,
            previousOrders == null ? [] : previousOrders.orders,
          ),
        ),
      ],
      child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Flutter Shop App',
                theme: ThemeData(
                  primarySwatch: Colors.brown,
                  accentColor: Colors.lightGreen,
                  fontFamily: 'Lato',
                  backgroundColor: Colors.brown[100],
                ),
                home: auth.isAuth
                    ? ProductsOverviewPage()
                    : FutureBuilder(
                        future: auth.tryAutoLogin(),
                        builder: (context, snapshot) =>
                            snapshot.connectionState == ConnectionState.waiting
                                ? SplashPage()
                                : AuthPage(),
                      ),
                routes: {
                  ProductDetailPage.routeName: (ctx) => ProductDetailPage(),
                  CartPage.routeName: (ctx) => CartPage(),
                  OrderPage.routeName: (ctx) => OrderPage(),
                  UserProductPage.routeName: (ctx) => UserProductPage(),
                  EditProductpage.routeName: (ctx) => EditProductpage(),
                },
              )),
    );
  }
}
