import 'package:cloud_firestore/cloud_firestore.dart';
import 'Order.dart';

class OrderService {
  final CollectionReference ordersCollection = FirebaseFirestore.instance.collection('orders');
  static const int pageSize = 10;

  Future<List<Orders>> fetchOrdersForUser(String userId) async {
    try {
      QuerySnapshot querySnapshot = await ordersCollection.where('userID', isEqualTo: userId).get();

      List<Orders> ordersList = querySnapshot.docs.map((doc) => Orders.fromFirestore(doc)).toList();

      return ordersList;
    } catch (e) {
      print('Error fetching orders: $e');
      return []; // Handle error scenario based on your app's requirements
    }
  }

  Future<List<Orders>> fetchAllOrders() async {
    try {
      QuerySnapshot querySnapshot = await ordersCollection.limit(pageSize).get();

      List<Orders> ordersList = querySnapshot.docs.map((doc) => Orders.fromFirestore(doc)).toList();

      return ordersList;
    } catch (e) {
      print('Error fetching orders: $e');
      return []; // Handle error scenario based on your app's requirements
    }
  }

  Future<List<Orders>> fetchMoreOrders({required String lastOrderId}) async {
    try {
      QuerySnapshot querySnapshot = await ordersCollection
          .orderBy('id') // Adjust 'id' to your actual order ID field
          .startAfter([lastOrderId]) // Use lastOrderId or lastDocumentSnapshot as per your implementation
          .limit(pageSize)
          .get();

      List<Orders> moreOrdersList = querySnapshot.docs.map((doc) => Orders.fromFirestore(doc)).toList();

      return moreOrdersList;
    } catch (e) {
      print('Error fetching more orders: $e');
      return []; // Handle error scenario based on your app's requirements
    }
  }
}
