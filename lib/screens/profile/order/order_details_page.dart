import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDetailsPage extends StatelessWidget {
  final String orderId;

  const OrderDetailsPage({required this.orderId, Key? key}) : super(key: key);

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
        title: const Text('Order Details', style: TextStyle(color: Color(0xFFDC143C))),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('orders').doc(orderId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var orderData = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Text('Order ID: ${orderId}', style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10.0),
                Text('User Name: ${orderData['userName']}', style: const TextStyle(fontSize: 18.0)),
                const SizedBox(height: 10.0),
                Text('Address: ${orderData['userAddress']}', style: const TextStyle(fontSize: 18.0)),
                const SizedBox(height: 10.0),
                Text('Phone Number: ${orderData['userPhoneNumber']}', style: const TextStyle(fontSize: 18.0)),
                const SizedBox(height: 10.0),
                Text('Total Price: \₹${orderData['totalPrice'].toStringAsFixed(2)}', style: const TextStyle(fontSize: 18.0)),
                const SizedBox(height: 10.0),
                const Text('Items:', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10.0),
                ...orderData['items'].map<Widget>((item) {
                  return ListTile(
                    title: Text(item['name']),
                    subtitle: Text('Quantity: ${item['quantity']}'),
                    trailing: Text('\₹${item['price'].toStringAsFixed(2)}'),
                  );
                }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }
}
