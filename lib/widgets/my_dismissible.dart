import 'package:flutter/material.dart';

class MyDismissible extends StatelessWidget {
  final String id;
  final Widget child;
  final Function onDismissedHandler;

  MyDismissible({this.id, this.child, this.onDismissedHandler});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 4.0,
          horizontal: 5.0,
        ),
        padding: EdgeInsets.only(right: 20.0),
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          size: 24.0,
          color: Colors.white,
        ),
        alignment: Alignment.centerRight,
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) => showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Delete'),
          content: Text('Do you want to delete this item?'),
          actions: <Widget>[
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(ctx).pop(false);
              },
            ),
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        ),
      ),
      onDismissed: (direction) => onDismissedHandler(),
      child: child,
    );
  }
}