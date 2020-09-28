import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../providers/product.dart';

class ProductDetailPage extends StatelessWidget {
  static const routeName = '/product-details';

  @override
  Widget build(BuildContext context) {
    final String productId = ModalRoute.of(context).settings.arguments;
    final Product loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findByid(productId);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      // appBar: AppBar(
      //   title: Text(loadedProduct.title),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                color: Theme.of(context).primaryColor.withOpacity(0.7),
                child: Text(loadedProduct.title),
              ),
              background: Hero(
                tag: loadedProduct.id,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(
                  height: 10,
                ),
                Text(
                  '\$${loadedProduct.price}',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Text(
                    loadedProduct.description,
                    style: TextStyle(fontSize: 16),
                    softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 1000,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
