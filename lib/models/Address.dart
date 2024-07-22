import 'package:cloud_firestore/cloud_firestore.dart';


class Address {
  final String firstName;
  final String lastName;
  final String address;
  final String phoneNumber;
  final String city;
  final String state;

  Address({
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.phoneNumber,
    required this.city,
    required this.state,
  });

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'address': address,
      'phoneNumber': phoneNumber,
      'city': city,
      'state': state,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      firstName: map['firstName'],
      lastName: map['lastName'],
      address: map['address'],
      phoneNumber: map['phoneNumber'],
      city: map['city'],
      state: map['state'],
    );
  }

  static CollectionReference<Address> get collection =>
      FirebaseFirestore.instance.collection('addresses').withConverter<Address>(
        fromFirestore: (snapshot, _) => Address.fromMap(snapshot.data()!),
        toFirestore: (address, _) => address.toMap(),
      );

  Future<void> save(String userId) async {
    await Address.collection.doc(userId).set(toMap() as Address);
  }
}

class AddressModel {
  final String userID;
  final String address;
  final String contactNumber;

  AddressModel({
    required this.userID,
    required this.address,
    required this.contactNumber,
  });

  factory AddressModel.fromFirestore(Map<String, dynamic> data) {
    return AddressModel(
      userID: data['userID'],
      address: data['address'],
      contactNumber: data['contactNumber'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userID': userID,
      'address': address,
      'contactNumber': contactNumber,
    };
  }
}
