import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import './my_dismissible.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;

  CartItem(
    this.id,
    this.productId,
    this.title,
    this.price,
    this.quantity,
  );

  @override
  Widget build(BuildContext context) {
    return MyDismissible(
      id: id,
      onDismissedHandler: (){
        Provider.of<Cart>(context, listen: false).deleteItem(productId);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(
          vertical: 4.0,
          horizontal: 5.0,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: FittedBox(child: Text('\$$price')),
              ),
            ),
            title: Text(
              title,
              style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 18.0),
            ),
            subtitle: Text('Total: \$${(price * quantity).toStringAsFixed(2)}'),
            trailing: Text('x$quantity'),
          ),
        ),
      ),
    );
  }
}
