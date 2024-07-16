import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartManager extends ChangeNotifier {
  static final CartManager _instance = CartManager._internal();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  factory CartManager() {
    return _instance;
  }

  CartManager._internal() {
    _loadCartItems();
  }

  List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;

  Future<void> _loadCartItems() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('cart').get();
      _cartItems = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();
      notifyListeners();
    } catch (e) {
      print('Error loading cart items: $e');
    }
  }

  Future<void> addItem(Map<String, dynamic> item) async {
    try {
      DocumentReference docRef = await _firestore.collection('cart').add(item);
      item['id'] = docRef.id;
      _cartItems.add(item);
      notifyListeners();
    } catch (e) {
      print('Error adding item to cart: $e');
    }
  }

  Future<void> removeItem(String itemId) async {
    try {
      await _firestore.collection('cart').doc(itemId).delete();
      _cartItems.removeWhere((item) => item['id'] == itemId);
      notifyListeners();
    } catch (e) {
      print('Error removing item from cart: $e');
    }
  }

  Future<void> increaseQuantity(String itemId) async {
    try {
      var index = _cartItems.indexWhere((item) => item['id'] == itemId);
      if (index != -1) {
        _cartItems[index]['quantity']++;
        await _firestore.collection('cart').doc(itemId).update({
          'quantity': _cartItems[index]['quantity'],
        });
        notifyListeners();
      }
    } catch (e) {
      print('Error increasing quantity: $e');
    }
  }

  Future<void> decreaseQuantity(String itemId) async {
    try {
      var index = _cartItems.indexWhere((item) => item['id'] == itemId);
      if (index != -1 && _cartItems[index]['quantity'] > 1) {
        _cartItems[index]['quantity']--;
        await _firestore.collection('cart').doc(itemId).update({
          'quantity': _cartItems[index]['quantity'],
        });
        notifyListeners();
      }
    } catch (e) {
      print('Error decreasing quantity: $e');
    }
  }

  double calculateSubtotal() {
    return _cartItems.fold(0.0, (sum, item) => sum + (item['price'] * item['quantity']));
  }

  double calculateShipping() {
    return 5.0; // Placeholder for shipping calculation
  }

  double calculateTax() {
    return calculateSubtotal() * 0.10; // Placeholder for tax calculation
  }

  double calculateTotal() {
    return calculateSubtotal() + calculateShipping() + calculateTax();
  }
}
