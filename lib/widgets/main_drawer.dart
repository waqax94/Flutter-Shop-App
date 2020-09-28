import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/order_page.dart';
import '../pages/user_product_page.dart';
import '../providers/auth.dart';
import '../helpers/custom_route.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void openPage(String pageRoute) {
      Navigator.of(context).pushReplacementNamed(pageRoute);
      //Navigator.of(context).pushReplacement(CustomRoute(builder: (context) => OrderPage(),),);
    }

    Widget buildDrawerTile(String title, String pageRoute, IconData icon) {
      return ListTile(
        leading: Icon(
          icon,
          color: Theme.of(context).primaryColor,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        onTap: () {
          openPage(pageRoute);
        },
      );
    }

    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Let\'s Shop!'),
            automaticallyImplyLeading: false,
          ),
          buildDrawerTile("Shop", '/', Icons.shop),
          buildDrawerTile("My Orders", OrderPage.routeName, Icons.payment),
          buildDrawerTile(
              "Manage Products", UserProductPage.routeName, Icons.edit),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              "Logout",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
