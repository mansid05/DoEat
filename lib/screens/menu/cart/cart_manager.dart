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

  final List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;

  void _loadCartItems() async {
    QuerySnapshot snapshot = await _firestore.collection('cart').get();
    for (var doc in snapshot.docs) {
      _cartItems.add(doc.data() as Map<String, dynamic>);
    }
    notifyListeners();
  }

  Future<void> addItem(Map<String, dynamic> item) async {
    DocumentReference docRef = await _firestore.collection('cart').add(item);
    item['id'] = docRef.id;
    _cartItems.add(item);
    notifyListeners();
  }

  Future<void> removeItem(int index) async {
    await _firestore.collection('cart').doc(_cartItems[index]['id']).delete();
    _cartItems.removeAt(index);
    notifyListeners();
  }

  Future<void> increaseQuantity(int index) async {
    _cartItems[index]['quantity']++;
    await _firestore.collection('cart').doc(_cartItems[index]['id']).update({
      'quantity': _cartItems[index]['quantity']
    });
    notifyListeners();
  }

  Future<void> decreaseQuantity(int index) async {
    if (_cartItems[index]['quantity'] > 1) {
      _cartItems[index]['quantity']--;
      await _firestore.collection('cart').doc(_cartItems[index]['id']).update({
        'quantity': _cartItems[index]['quantity']
      });
      notifyListeners();
    }
  }

  double calculateSubtotal() {
    return _cartItems.fold(0.0, (sum, item) => sum + (item['price'] * item['quantity']));
  }

  double calculateShipping() {
    return 5.0;
  }

  double calculateTax() {
    return calculateSubtotal() * 0.10;
  }

  double calculateTotal() {
    return calculateSubtotal() + calculateShipping() + calculateTax();
  }
}
