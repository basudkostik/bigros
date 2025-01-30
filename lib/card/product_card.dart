import 'package:bigross/services/crud/cart.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String productName;
  final double price;
  final int stock;

  const ProductCard({
    required this.imageUrl,
    required this.productName,
    required this.price,
    required this.stock,
  });

  @override
  Widget build(BuildContext context) {
    String abbreviatedProductName = productName.length > 20
        ? '${productName.substring(0, 20)}...'
        : productName;

    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  abbreviatedProductName,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  'Price:  ₺${price.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 14.0),
                ),
                const SizedBox(height: 4.0),
                Text(
                  'Stock: $stock',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: stock > 0 ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(height: 8.0),
                ElevatedButton(
                  onPressed: stock > 0
                      ? () {
                          // Add product to cart
                          Cart.addProduct({
                            'imageUrl': imageUrl,
                            'productName': productName,
                            'price': price,
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('$productName added to cart!')),
                          );
                        }
                      : null,
                  child: const Text('Add to Cart'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
