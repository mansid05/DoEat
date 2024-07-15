import 'package:flutter/material.dart';

class CartManager extends ChangeNotifier {
  static final CartManager _instance = CartManager._internal();

  factory CartManager() {
    return _instance;
  }

  CartManager._internal();

  final List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;

  void addItem(Map<String, dynamic> item) {
    _cartItems.add(item);
    notifyListeners();
  }

  void removeItem(int index) {
    _cartItems.removeAt(index);
    notifyListeners();
  }

  void increaseQuantity(int index) {
    _cartItems[index]['quantity']++;
    notifyListeners();
  }

  void decreaseQuantity(int index) {
    if (_cartItems[index]['quantity'] > 1) {
      _cartItems[index]['quantity']--;
      notifyListeners();
    }
  }

  double calculateSubtotal() {
    return _cartItems.fold(0.0, (sum, item) => sum + (item['price'] * item['quantity']));
  }

  double calculateShipping() {
    return 5.0; // Example shipping cost
  }

  double calculateTax() {
    return calculateSubtotal() * 0.10; // Example tax calculation
  }

  double calculateTotal() {
    return calculateSubtotal() + calculateShipping() + calculateTax();
  }
}
