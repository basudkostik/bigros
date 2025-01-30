import 'package:flutter/material.dart';

Future<void> showPaymentDialog({
  required BuildContext context,
  required List cartItems,
  required Future<void> Function(List cartItems) handlePurchase,
}) async {
  final TextEditingController creditCardController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Enter Payment Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: creditCardController,
              decoration: const InputDecoration(
                labelText: 'Credit Card Number',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'Address',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final creditCard = creditCardController.text;
              final address = addressController.text;

              if (creditCard.isEmpty || address.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill all fields'),
                  ),
                );
                return;
              }
              Navigator.pop(context);
              await handlePurchase(cartItems);
            },
            child: const Text('Submit'),
          ),
        ],
      );
    },
  );
}
