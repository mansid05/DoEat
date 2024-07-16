import 'CartItem.dart';

class Orders {
  final String id;
  final String orderNumber;
  final String orderDateTime;
  final String status;
  final List<OrderItem> items;
  final double totalPrice;
  final double deliveryCharges;
  final String paymentMethod;
  final List<CartItem> cartItems;
  final AddressModel address; // Updated to use AddressModel

  Orders({
    required this.id,
    required this.orderNumber,
    required this.orderDateTime,
    required this.status,
    required this.items,
    required this.totalPrice,
    required this.deliveryCharges,
    required this.paymentMethod,
    required this.cartItems,
    required this.address,
  });

  factory Orders.fromMap(Map<String, dynamic> data, String documentId) {
    return Orders(
      id: documentId,
      orderNumber: data['orderNumber'] ?? '',
      orderDateTime: data['orderDateTime'] ?? '',
      status: data['status'] ?? '',
      items: (data['items'] as List<dynamic>).map((item) => OrderItem.fromMap(item)).toList(),
      totalPrice: data['totalPrice']?.toDouble() ?? 0.0,
      deliveryCharges: data['deliveryCharges']?.toDouble() ?? 0.0,
      paymentMethod: data['paymentMethod'] ?? '',
      cartItems: [], // You may need to map cartItems if necessary
      address: AddressModel.fromMap(data['address']), // Mapping AddressModel from data
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

class AddressModel {
  final String street;
  final String city;
  final String country;

  AddressModel({
    required this.street,
    required this.city,
    required this.country,
  });

  factory AddressModel.fromMap(Map<String, dynamic> data) {
    return AddressModel(
      street: data['street'] ?? '',
      city: data['city'] ?? '',
      country: data['country'] ?? '',
    );
  }
}
