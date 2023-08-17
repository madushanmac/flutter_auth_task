import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/data_model.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  ProductDetailScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: Icon(
            Icons.arrow_back_sharp,
            size: 30,
            color: Colors.black,
          ),
          backgroundColor: Colors.grey[300],
          elevation: 8.0,
          centerTitle: true,
          title: const Text(
            'Product Details',
            style: TextStyle(color: Colors.grey),
          )),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child:
                        Image.network(product.thumbnail, fit: BoxFit.cover))),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product.title,
              style: TextStyle(fontSize: 35),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('\$${product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.redAccent)),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text('\$${product.description.toString()}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black)),
          ),
          // Add more details...
        ],
      ),
    );
  }
}
