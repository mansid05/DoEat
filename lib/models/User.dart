import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String address;
  final String phoneNumber;
  final DateTime lastActive;
  final String profileImageUrl;
  final bool isActive;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.address,
    required this.phoneNumber,
    required this.lastActive,
    required this.profileImageUrl,
    required this.isActive,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      address: map['address'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      lastActive: (map['lastActive'] as Timestamp).toDate(),
      profileImageUrl: map['profileImageUrl'] ?? '',
      isActive: map['isActive'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'address': address,
      'phoneNumber': phoneNumber,
      'lastActive': lastActive,
      'profileImageUrl': profileImageUrl,
      'isActive': isActive,
    };
  }
}
