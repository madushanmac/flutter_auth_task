import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

import '../models/data_model.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  ProductDetailScreen({super.key, required this.product});

  bool isReadOnly = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
          leading: IconButton(
            iconSize: 30,
            color: Colors.black,
            icon: const Icon(Icons.arrow_back_sharp),
            onPressed: () {
              Navigator.pop(context);
            },
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
            padding: const EdgeInsets.all(10.0),
            child: CarouselSlider(
              items: product.images.map((url) {
                return Builder(
                  builder: (BuildContext context) {
                    return AspectRatio(
                      aspectRatio: 16 / 9,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(70.0),
                        child: Image(image: NetworkImage(url)),
                      ),
                    );
                  },
                );
              }).toList(),
              options: CarouselOptions(
                height: 200,
                autoPlay: true,
                enlargeCenterPage: true,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product.title,
              style: const TextStyle(fontSize: 35),
            ),
          ),
          SmoothStarRating(
            rating: product.rating,
            size: 30,
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
