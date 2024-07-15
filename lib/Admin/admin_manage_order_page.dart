import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Order.dart';
import '../screens/profile/order/order_details_page.dart';

class AdminManageOrderPage extends StatefulWidget {
  const AdminManageOrderPage({Key? key}) : super(key: key);

  @override
  _AdminManageOrderPageState createState() => _AdminManageOrderPageState();
}

class _AdminManageOrderPageState extends State<AdminManageOrderPage> {
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
        title: const Text('Manage Orders', style: TextStyle(color: Color(0xFFDC143C))),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var orders = snapshot.data!.docs.map((doc) {
            return OrderPlaced.fromMap(doc.data() as Map<String, dynamic>, doc.id);
          }).toList();

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                margin: const EdgeInsets.all(10.0),
                child: ListTile(
                  title: Text('Order #${order.orderNumber}', style: const TextStyle(fontSize: 16.0)),
                  subtitle: Text('Total: \₹${order.totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 14.0)),
                  trailing: IconButton(
                    icon: const Icon(Icons.arrow_forward, color: Color(0xFFDC143C)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDetailsPage(orderId: order.id),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AdminManageOrderPage(),
  ));
}
