import 'package:bigross/card/product_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String query = '';
  List<Map<String, dynamic>> searchResults = [];

  void searchProducts(String searchText) async {
    String lowercaseSearchText = searchText.toLowerCase();

    final results =
        await FirebaseFirestore.instance.collection('products').get();

    setState(() {
      searchResults = results.docs
          .where((doc) {
            final productName = (doc['productName'] as String).toLowerCase();
            return productName.contains(lowercaseSearchText);
          })
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Products'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                suffixIcon: const Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  query = value;
                });
                if (value.isNotEmpty) {
                  searchProducts(value);
                } else {
                  setState(() {
                    searchResults.clear();
                  });
                }
              },
            ),
          ),
          Expanded(
            child: searchResults.isEmpty
                ? const Center(
                    child: Text('No products found.'),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      final product = searchResults[index];
                      return ProductCard(
                        imageUrl: product['imageUrl'],
                        productName: product['productName'],
                        price: product['price'],
                        stock: product['stock'],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
