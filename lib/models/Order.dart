import 'package:cloud_firestore/cloud_firestore.dart';

import 'CartItem.dart';

class Orders {
  final String id;
  final String userId;
  final String deliveryAddress;
  final String contactNumber;
  final double totalAmount;
  final String orderStatus;
  final Timestamp orderTimestamp;
  List<CartItem> cartItems;

  Orders({
    required this.id,
    required this.userId,
    required this.deliveryAddress,
    required this.contactNumber,
    required this.totalAmount,
    required this.orderStatus,
    required this.orderTimestamp,
    required this.cartItems,
  });

  factory Orders.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Orders(
      id: doc.id,
      userId: data['userId'] ?? '',
      deliveryAddress: data['address'] ?? '',
      contactNumber: data['contactNumber'] ?? '',
      totalAmount: (data['total'] as num).toDouble(),
      orderStatus: data['status'] ?? 'Pending',
      orderTimestamp: data['timestamp'] ?? Timestamp.now(),
      cartItems: [],
    );
  }
}
