import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/data_model.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  ProductDetailScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product Detail')),
      body: Column(
        children: [
          Image.network(product.thumbnail),
          Text(product.title),
          Text('\$${product.price.toStringAsFixed(2)}'),
          // Add more details...
        ],
      ),
    );
  }
}
