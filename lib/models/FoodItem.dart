import 'package:cloud_firestore/cloud_firestore.dart';

class FoodItem {
  final String id;
  final String name;
  final String restaurant;
  final double price;
  final String offer;
  final bool isFavorite;
  final String description;
  final String image;

  FoodItem({
    required this.id,
    required this.name,
    required this.restaurant,
    required this.price,
    required this.offer,
    required this.isFavorite,
    required this.description,
    required this.image,
  });

  factory FoodItem.fromMap(Map<String, dynamic> data, String documentId) {
    return FoodItem(
      id: documentId,
      name: data['name'] ?? '',
      restaurant: data['restaurant'] ?? '',
      price: data['price']?.toDouble() ?? 0.0,
      offer: data['offer'] ?? '',
      isFavorite: data['isFavorite'] ?? false,
      description: data['description'] ?? '',
      image: data['image'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'restaurant': restaurant,
      'price': price,
      'offer': offer,
      'isFavorite': isFavorite,
      'description': description,
      'image': image,
    };
  }
}

class ProductItem extends FoodItem {
  ProductItem({
    required super.id,
    required super.name,
    required super.restaurant,
    required super.price,
    required super.offer,
    required super.isFavorite,
    required super.description,
    required super.image,
  });

  factory ProductItem.fromMap(Map<String, dynamic> data, String documentId) {
    return ProductItem(
      id: documentId,
      name: data['name'] ?? '',
      restaurant: data['restaurant'] ?? '',
      price: data['price']?.toDouble() ?? 0.0,
      offer: data['offer'] ?? '',
      isFavorite: data['isFavorite'] ?? false,
      description: data['description'] ?? '',
      image: data['image'] ?? '',
    );
  }
}

class PopularItem extends FoodItem {
  PopularItem({
    required super.id,
    required super.name,
    required super.restaurant,
    required super.price,
    required super.offer,
    required super.isFavorite,
    required super.description,
    required super.image,
  });

  factory PopularItem.fromMap(Map<String, dynamic> data, String documentId) {
    return PopularItem(
      id: documentId,
      name: data['name'] ?? '',
      restaurant: data['restaurant'] ?? '',
      price: data['price']?.toDouble() ?? 0.0,
      offer: data['offer'] ?? '',
      isFavorite: data['isFavorite'] ?? false,
      description: data['description'] ?? '',
      image: data['image'] ?? '',
    );
  }
}
class MenuItem extends FoodItem {
  MenuItem({
    required super.id,
    required super.name,
    required super.restaurant,
    required super.price,
    required super.offer,
    required super.isFavorite,
    required super.description,
    required super.image,
  });

  factory MenuItem.fromMap(Map<String, dynamic> data, String documentId) {
    return MenuItem(
      id: documentId,
      name: data['name'] ?? '',
      restaurant: data['restaurant'] ?? '',
      price: data['price']?.toDouble() ?? 0.0,
      offer: data['offer'] ?? '',
      isFavorite: data['isFavorite'] ?? false,
      description: data['description'] ?? '',
      image: data['image'] ?? '',
    );
  }
  factory MenuItem.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return MenuItem.fromMap(data, snapshot.id);
  }

  static Future<List<MenuItem>> getCategory(String name) async {
    var instance = FirebaseFirestore.instance;
    var querySnapshot = await instance.collection("menus").where("category", isEqualTo: name).get();
    var list = querySnapshot.docs.map((doc) => MenuItem.fromSnapshot(doc)).toList();
    return list;
  }
}