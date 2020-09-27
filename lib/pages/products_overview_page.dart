import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/products.dart';
import '../widgets/badge.dart';
import '../widgets/products_grid.dart';
import '../widgets/main_drawer.dart';
import './cart_page.dart';

enum ItemsDisplay {
  Favorite,
  All,
}

class ProductsOverviewPage extends StatefulWidget {
  @override
  _ProductsOverviewPageState createState() => _ProductsOverviewPageState();
}

class _ProductsOverviewPageState extends State<ProductsOverviewPage> {
  bool _showFavorite = false;
  bool _isLoading = true;

  @override
  void initState() {
    //---First approach works only with Provider----//
    Provider.of<Products>(context, listen: false)
        .getAndSetProducts()
        .catchError((error) {
      print(error);
      setState(() {
        _isLoading = false;
      });
    }).then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    //----Second approach works for all of(context) scenarios in initState() method----//
    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Products>(context, listen: false)
    //     .getAndSetProducts();
    // });
    //----Alternatively, use helper isInit variable with didDependenciesChange() method----//
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text("My Shop"),
          actions: <Widget>[
            PopupMenuButton(
              onSelected: (selectedOption) {
                setState(() {
                  if (selectedOption == ItemsDisplay.Favorite) {
                    _showFavorite = true;
                  } else {
                    _showFavorite = false;
                  }
                });
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: Text('Show Favorite'),
                  value: ItemsDisplay.Favorite,
                ),
                PopupMenuItem(
                  child: Text('Show All'),
                  value: ItemsDisplay.All,
                ),
              ],
            ),
            Consumer<Cart>(
              builder: (_, cart, child) => Badge(
                child: child,
                value: cart.itemCount.toString(),
              ),
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartPage.routeName);
                },
              ),
            )
          ],
        ),
        drawer: MainDrawer(),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                ),
              )
            : ProductsGrid(_showFavorite));
  }
}
