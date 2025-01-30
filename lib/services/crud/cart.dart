class Cart {
  static final Map<String, Map<String, dynamic>> _cartItems = {};

  static void addProduct(Map<String, dynamic> product) {
    final productName = product['productName'];
    if (_cartItems.containsKey(productName)) {
      _cartItems[productName]!['quantity'] += 1;
    } else {
      _cartItems[productName] = {
        ...product,
        'quantity': 1,
      };
    }
  }

  static void increaseQuantity(String productName) {
    if (_cartItems.containsKey(productName)) {
      _cartItems[productName]!['quantity'] += 1;
    }
  }

  static void decreaseQuantity(String productName) {
    if (_cartItems.containsKey(productName) &&
        _cartItems[productName]!['quantity'] > 1) {
      _cartItems[productName]!['quantity'] -= 1;
    } else {
      _cartItems.remove(productName);
    }
  }

  static List<Map<String, dynamic>> get cartItems => _cartItems.values.toList();

  static double get totalCost => _cartItems.values
      .fold(0, (total, item) => total + (item['price'] * item['quantity']));

  static void clearCart() {
    _cartItems.clear();
  }
}
