import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
      ),
      body: _buildOrderHistoryList(context),
    );
  }

  Widget _buildOrderHistoryList(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('orders').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error loading orders: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        List<OrderItem> orders = snapshot.data!.docs.map((doc) {
          return OrderItem.fromMap(doc.data() as Map<String, dynamic>);
        }).toList();

        if (orders.isEmpty) {
          return const Center(child: Text('No orders available.'));
        }

        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            OrderItem order = orders[index];
            return ListTile(
              title: Text('Order ID: ${order.id}'),
              subtitle: Text('Total: \₹${order.total.toStringAsFixed(2)}'),
              onTap: () {
                // Handle tapping on an order item if needed
              },
            );
          },
        );
      },
    );
  }
}

class OrderItem {
  final String id;
  final double total;

  OrderItem({
    required this.id,
    required this.total,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      id: map['id'] ?? '',
      total: map['total'] ?? 0.0,
    );
  }
}
