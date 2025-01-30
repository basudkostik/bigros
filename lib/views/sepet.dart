import 'package:bigross/dialogs/payment_dialog.dart';
import 'package:bigross/services/crud/cart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final cartItems = Cart.cartItems;
    final totalCost = Cart.totalCost;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text('Your cart is empty.'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return ListTile(
                        leading: Image.network(item['imageUrl']),
                        title: Text(item['productName']),
                        subtitle: Text(
                          'Price: ₺${item['price'].toStringAsFixed(2)} x ${item['quantity']} = ₺${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  Cart.decreaseQuantity(item['productName']);
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  Cart.increaseQuantity(item['productName']);
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Total: ₺${totalCost.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () => showPaymentDialog(
                          context: context,
                          cartItems: cartItems,
                          handlePurchase: _handlePurchase,
                        ),
                        child: const Text('Buy'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _handlePurchase(List cartItems) async {
    bool canBuy = true;

    for (var item in cartItems) {
      final productDoc = await FirebaseFirestore.instance
          .collection('products')
          .where('productName', isEqualTo: item['productName'])
          .get();

      if (productDoc.docs.isEmpty) {
        canBuy = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${item['productName']} not found in stock.'),
          ),
        );
        break;
      }

      final availableStock = productDoc.docs.first['stock'];
      if (item['quantity'] > availableStock) {
        canBuy = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Not enough stock for ${item['productName']}'),
          ),
        );
        break;
      }
    }

    if (canBuy) {
      try {
        for (var item in cartItems) {
          final productDoc = await FirebaseFirestore.instance
              .collection('products')
              .where('productName', isEqualTo: item['productName'])
              .get();

          if (productDoc.docs.isNotEmpty) {
            final docId = productDoc.docs.first.id;
            await FirebaseFirestore.instance
                .collection('products')
                .doc(docId)
                .update({
              'stock': FieldValue.increment(-item['quantity']),
            });
          }
        }

        // Clear cart and update UI
        setState(() {
          Cart.clearCart();
          devtools.log('Cart items after clearing: ${Cart.cartItems}');
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Purchase successful!'),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error during purchase: $e'),
          ),
        );
      }
    }
  }
}
