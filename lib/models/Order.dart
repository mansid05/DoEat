import 'package:cloud_firestore/cloud_firestore.dart';
import 'CartItem.dart';
import 'User.dart';  // Import UserModel class

class Orders {
  final String id;
  final UserModel user;  // Change userId to UserModel
  final String deliveryAddress;
  final String contactNumber;
  final double totalAmount;
  final String orderStatus;
  final Timestamp orderTimestamp;
  List<CartItem> cartItems;

  Orders({
    required this.id,
    required this.user,  // Change userId to UserModel
    required this.deliveryAddress,
    required this.contactNumber,
    required this.totalAmount,
    required this.orderStatus,
    required this.orderTimestamp,
    required this.cartItems,
  });

  factory Orders.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Create a UserModel instance from the userId field
    UserModel user = UserModel.fromMap(
      data['user'] as Map<String, dynamic>,  // Adjust the path if needed
      data['userId'] as String,
    );

    return Orders(
      id: doc.id,
      user: user,
      deliveryAddress: data['address'] ?? '',
      contactNumber: data['contactNumber'] ?? '',
      totalAmount: (data['total'] as num).toDouble(),
      orderStatus: data['status'] ?? 'Pending',
      orderTimestamp: data['timestamp'] ?? Timestamp.now(),
      cartItems: [],  // This should be updated based on your needs
    );
  }
}
