import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_app/screens/menu/cart/cart_manager.dart';
import 'package:food_app/screens/profile/payment/verify_page.dart';

import '../../../models/CartItem.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartManager _cartManager = CartManager();
  final TextEditingController _couponController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cartManager.addListener(_updateCart);
  }

  @override
  void dispose() {
    _cartManager.removeListener(_updateCart);
    super.dispose();
  }

  void _updateCart() {
    setState(() {}); // Refresh UI when cart changes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFDC143C)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('CART', style: TextStyle(color: Color(0xFFDC143C))),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('cart').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                List<CartItem> cartItems = snapshot.data!.docs.map((doc) => CartItem.fromFirestore(doc)).toList();

                return ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    CartItem item = cartItems[index];
                    return Card(
                      margin: const EdgeInsets.all(10.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            SizedBox(
                              height: 50.0,
                              width: 50.0,
                              child: Image.network(item.image, fit: BoxFit.cover),
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.name, style: const TextStyle(fontSize: 16.0)),
                                  const SizedBox(height: 5.0),
                                  Text('\₹${item.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 14.0)),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove, color: Color(0xFFDC143C)),
                              onPressed: () => _cartManager.decreaseQuantity(item.id),
                            ),
                            Text('${item.quantity}', style: const TextStyle(fontSize: 16.0)),
                            IconButton(
                              icon: const Icon(Icons.add, color: Color(0xFFDC143C)),
                              onPressed: () => _cartManager.increaseQuantity(item.id),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Color(0xFFDC143C)),
                              onPressed: () => _cartManager.removeItem(item.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _couponController,
                  decoration: InputDecoration(
                    hintText: 'Enter Coupon Code',
                    suffixIcon: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFDC143C),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      onPressed: () {
                        // Handle coupon code application
                      },
                      child: const Text(
                        'Apply Coupon',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10.0),
                _buildSummaryRow('Sub Total', '\₹${_cartManager.calculateSubtotal().toStringAsFixed(2)}'),
                _buildSummaryRow('Shipping', '\₹${_cartManager.calculateShipping().toStringAsFixed(2)}'),
                _buildSummaryRow('Tax (10%)', '\₹${_cartManager.calculateTax().toStringAsFixed(2)}'),
                const SizedBox(height: 10.0),
                _buildSummaryRow('Total', '\₹${_cartManager.calculateTotal().toStringAsFixed(2)}'),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDC143C),
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VerifyPage(total: _cartManager.calculateTotal(),),
                      ),
                    );
                  },
                  child: const Text(
                    'PROCEED TO CHECKOUT',
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16.0)),
          Text(value, style: const TextStyle(fontSize: 16.0)),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: CartPage(),
  ));
}
