import 'package:flutter/foundation.dart';

class CartItem {
  String id;
  String title;
  double price;
  int quantity;

  CartItem({this.id, this.title, this.price, this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  int get quantityItemsCount => (_items.isEmpty)
      ? itemCount
      : _items.values
          .map((item) => item.quantity)
          .reduce((value, element) => value + element);

  double get totalAmount => (_items.isEmpty)
      ? 0.0
      : _items.values
          .map((item) => item.price * item.quantity)
          .reduce((value, element) => value + element);

  void addItem(String productId, String title, double price) {
    _items.update(
      productId,
      (existedCartItem) => CartItem(
          id: existedCartItem.id,
          title: existedCartItem.title,
          price: existedCartItem.price,
          quantity: existedCartItem.quantity + 1),
      ifAbsent: () => CartItem(
        id: DateTime.now().toString(),
        title: title,
        price: price,
        quantity: 1,
      ),
    );
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) return;

    if (_items[productId].quantity > 1) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
            id: existingCartItem.id,
            title: existingCartItem.title,
            price: existingCartItem.price,
            quantity: existingCartItem.quantity - 1),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void deleteItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
