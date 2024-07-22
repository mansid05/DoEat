import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_app/screens/menu/cart/cart_manager.dart';
import '../../../models/Address.dart';
import '../../../models/CartItem.dart';
import '../../profile/order/order_placed_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with WidgetsBindingObserver {
  final CartManager _cartManager = CartManager();
  final TextEditingController _couponController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cartManager.addListener(_updateCart);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _cartManager.removeListener(_updateCart);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _clearCartItems();
    }
  }

  void _updateCart() {
    setState(() {});
  }

  void _placeOrder() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        String address = '';
        String contactNumber = '';

        final TextEditingController addressController = TextEditingController();
        final TextEditingController contactNumberController = TextEditingController();

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        controller: addressController,
                        decoration: const InputDecoration(
                          hintText: 'Enter Address',
                        ),
                        onChanged: (value) {
                          address = value;
                        },
                      ),
                      const SizedBox(height: 10.0),
                      TextField(
                        controller: contactNumberController,
                        decoration: const InputDecoration(
                          hintText: 'Enter Contact Number',
                        ),
                        onChanged: (value) {
                          contactNumber = value;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDC143C),
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                        ),
                        onPressed: () {
                          _handlePayment(address, contactNumber);
                        },
                        child: const Text(
                          'Pay Now',
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _handlePayment(String address, String contactNumber) async {
    List<Map<String, dynamic>> itemsData = _cartManager.cartItems;

    try {
      await FirebaseFirestore.instance.collection('orders').add({
        'userId': '', // Replace with actual user ID if available
        'address': address,
        'contactNumber': contactNumber,
        'total': _cartManager.calculateTotal(),
        'items': itemsData,
        'timestamp': Timestamp.now(),
      });

      _clearCartItems();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderPlacedPage(
            addressModel: AddressModel(address: address, contactNumber: contactNumber, userID: ''),
            total: _cartManager.calculateTotal(),
            cartItems: _cartManager.cartItems.map((item) {
              return CartItem(
                id: item['id'],
                name: item['name'],
                price: item['price'],
                quantity: item['quantity'],
                image: item['image'],
              );
            }).toList(),
          ),
        ),
      );
    } catch (error) {
      print('Error placing order: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error placing order: $error')),
      );
    }
  }

  Future<void> _clearCartItems() async {
    try {
      final cartSnapshot = await FirebaseFirestore.instance.collection('cart').get();
      for (DocumentSnapshot doc in cartSnapshot.docs) {
        await doc.reference.delete();
      }
      _cartManager.resetCart();
    } catch (error) {
      print('Error clearing cart: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error clearing cart: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _clearCartItems();
        return true;
      },
      child: Scaffold(
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

                  List<Map<String, dynamic>> cartItems = snapshot.data!.docs.map((doc) {
                    return {
                      'id': doc.id,
                      ...doc.data() as Map<String, dynamic>,
                    };
                  }).toList();

                  return ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> item = cartItems[index];
                      return Card(
                        margin: const EdgeInsets.all(10.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 50.0,
                                width: 50.0,
                                child: Image.network(item['image'], fit: BoxFit.cover),
                              ),
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item['name'], style: const TextStyle(fontSize: 16.0)),
                                    const SizedBox(height: 5.0),
                                    Text('\₹${item['price'].toStringAsFixed(2)}', style: const TextStyle(fontSize: 14.0)),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.remove, color: Color(0xFFDC143C)),
                                onPressed: () => _cartManager.decreaseQuantity(item['id']),
                              ),
                              Text('${item['quantity']}', style: const TextStyle(fontSize: 16.0)),
                              IconButton(
                                icon: const Icon(Icons.add, color: Color(0xFFDC143C)),
                                onPressed: () => _cartManager.increaseQuantity(item['id']),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Color(0xFFDC143C)),
                                onPressed: () => _cartManager.removeItem(item['id']),
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
                  _buildSummaryRow('Subtotal', _cartManager.calculateSubtotal()),
                  _buildSummaryRow('Tax', _cartManager.calculateTax()),
                  _buildSummaryRow('Total', _cartManager.calculateTotal()),
                  const SizedBox(height: 10.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDC143C),
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                    ),
                    onPressed: _placeOrder,
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
      ),
    );
  }

  Widget _buildSummaryRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16.0)),
          Text('\₹${value.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16.0)),
        ],
      ),
    );
  }
}
