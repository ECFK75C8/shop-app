import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart' show Products;
import '../widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  final showFav;

  ProductsGrid(this.showFav);

  @override
  Widget build(BuildContext context) {
    var products = showFav
        ? Provider.of<Products>(context).showFavItems
        : Provider.of<Products>(context).items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemBuilder: (_, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: ProductItem(),
      ),
    );
  }
}
