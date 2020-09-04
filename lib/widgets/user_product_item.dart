import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final Function modalHandler;

  UserProductItem(this.id, this.title, this.imageUrl, this.modalHandler);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);

    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            color: Theme.of(context).primaryColor,
            onPressed: () => modalHandler(context, id),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            color: Theme.of(context).errorColor,
            onPressed: () async {
              try {
                await Provider.of<Products>(context, listen: false)
                    .deleteProduct(id);
              } catch (error) {
                scaffold
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                    content: Text('Deleting failed!'),
                  ));
              }
            },
          )
        ],
      ),
    );
  }
}
