import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class AdminManageOrderPage extends StatefulWidget {
  @override
  _AdminManageOrderPageState createState() => _AdminManageOrderPageState();
}

class _AdminManageOrderPageState extends State<AdminManageOrderPage> {
  @override
  void initState() {
    super.initState();
    _setupFirebaseMessaging();
  }

  void _setupFirebaseMessaging() {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permissions for iOS
    messaging.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      if (notification != null) {
        // Show a local notification
        // Implement local notification logic here
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle notification tap
      print('Notification was tapped!');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Orders', style: TextStyle(color: Color(0xFFDC143C))),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          List<DocumentSnapshot> orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              DocumentSnapshot order = orders[index];
              return _buildOrderCard(order);
            },
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(DocumentSnapshot order) {
    String address = order['address'];
    String contactNumber = order['contactNumber'];
    double total = order['total'];
    List<dynamic> items = order['items'];

    return Card(
      margin: const EdgeInsets.all(10.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ID: ${order.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10.0),
            Text('Address: $address'),
            Text('Contact Number: $contactNumber'),
            const SizedBox(height: 10.0),
            Text('Total: \₹${total.toStringAsFixed(2)}'),
            const SizedBox(height: 10.0),
            Text('Items:', style: const TextStyle(fontWeight: FontWeight.bold)),
            ...items.map((item) => _buildOrderItem(item)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(Map<String, dynamic> item) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(item['name']),
      subtitle: Text('Quantity: ${item['quantity']}'),
      trailing: Text('\₹${item['price'].toStringAsFixed(2)}'),
    );
  }
}
