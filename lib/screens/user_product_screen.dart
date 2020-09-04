import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';
import '../widgets/edit_product.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-product';

  void _showModal(BuildContext context, [String id]) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => EditProductScreen(id));
  }

  Future<void> _refreshHandler(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSave();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showModal(context),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshHandler(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer<Products>(
            builder: (context, products, child) => ListView.builder(
              itemCount: products.items.length,
              itemBuilder: (_, index) => Column(
                children: <Widget>[
                  UserProductItem(
                      products.items[index].id,
                      products.items[index].title,
                      products.items[index].imageUrl,
                      _showModal),
                  Divider(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
