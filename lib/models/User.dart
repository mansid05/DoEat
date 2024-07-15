
class UserModel {
  final String id;
  final String name;
  final String email;
  final String address;
  final String phoneNumber;
  final DateTime lastActive;
  final String profileImageUrl; // Optional: for profile image

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.address,
    required this.phoneNumber,
    required this.lastActive,
    required this.profileImageUrl,
  });

  factory UserModel.fromMap(Map<String, dynamic> data, String documentId) {
    return UserModel(
      id: documentId,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      address: data['address'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      lastActive: data['lastActive']?.toDate() ?? DateTime.now(),
      profileImageUrl: data['profileImageUrl'] ?? '', // Update based on your Firestore structure
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
    };
  }
}




class User {
  final String uid;
  final String name;
  final String email;

  User({
    required this.uid,
    required this.name,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
    };
  }
}
