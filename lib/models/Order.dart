
import 'package:cloud_firestore/cloud_firestore.dart';

class Orders {
  final String id;
  final String orderNumber;
  final String orderDateTime;
  final String status;
  final List<OrderItem> items;
  final double totalPrice;

  Orders({
    required this.id,
    required this.orderNumber,
    required this.orderDateTime,
    required this.status,
    required this.items,
    required this.totalPrice,
  });

  factory Orders.fromMap(Map<String, dynamic> data, String documentId) {
    return Orders(
      id: documentId,
      orderNumber: data['orderNumber'] ?? '',
      orderDateTime: data['orderDateTime'] ?? '',
      status: data['status'] ?? '',
      items: (data['items'] as List<dynamic>).map((item) => OrderItem.fromMap(item)).toList(),
      totalPrice: data['totalPrice']?.toDouble() ?? 0.0,
    );
  }
}

class OrderItem {
  final String name;
  final int quantity;
  final bool isVegetarian;

  OrderItem({
    required this.name,
    required this.quantity,
    required this.isVegetarian,
  });

  factory OrderItem.fromMap(Map<String, dynamic> data) {
    return OrderItem(
      name: data['name'] ?? '',
      quantity: data['quantity'] ?? 0,
      isVegetarian: data['isVegetarian'] ?? false,
    );
  }
}

class OrderPlaced {
  final String id;
  final String orderNumber;
  final double totalPrice;
  final String userName;
  final String userAddress;
  final String userPhoneNumber;
  final List<dynamic> items;

  OrderPlaced({
    required this.id,
    required this.orderNumber,
    required this.totalPrice,
    required this.userName,
    required this.userAddress,
    required this.userPhoneNumber,
    required this.items,
  });

  factory OrderPlaced.fromMap(Map<String, dynamic> data, String documentId) {
    return OrderPlaced(
      id: documentId,
      orderNumber: data['orderNumber'] ?? '',
      totalPrice: data['totalPrice'].toDouble() ?? 0.0,
      userName: data['userName'] ?? '',
      userAddress: data['userAddress'] ?? '',
      userPhoneNumber: data['userPhoneNumber'] ?? '',
      items: data['items'] ?? [],
    );
  }
}

