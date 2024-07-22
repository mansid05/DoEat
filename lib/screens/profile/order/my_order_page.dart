import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../models/Order.dart';
import '../../../models/OrderService.dart';

class MyOrdersPage extends StatefulWidget {
  @override
  _MyOrdersPageState createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  final OrderService _orderService = OrderService();
  late List<Orders> _orders;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      List<Orders> orders = await _orderService.fetchOrdersForUser(user.uid);
      setState(() {
        _orders = orders;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
      ),
      body: _orders != null
          ? ListView.builder(
        itemCount: _orders.length,
        itemBuilder: (context, index) {
          Orders order = _orders[index];
          // Implement your UI to display each order
          return ListTile(
            subtitle: Text('Total Amount: ₹${order.totalAmount}'),
            // Add more details as needed
          );
        },
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
