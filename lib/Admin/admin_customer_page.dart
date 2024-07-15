import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/User.dart';
import 'admin_navigation.dart';

class AdminCustomerPage extends StatefulWidget {
  const AdminCustomerPage({super.key});

  @override
  _AdminCustomerPageState createState() => _AdminCustomerPageState();
}

class _AdminCustomerPageState extends State<AdminCustomerPage> {
  late Stream<List<UserModel>> _usersStream;

  @override
  void initState() {
    super.initState();
    _usersStream = _fetchUsers();
  }

  Stream<List<UserModel>> _fetchUsers() {
    return FirebaseFirestore.instance.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => UserModel.fromMap(doc.data(), doc.id)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Data', style: TextStyle(color: Color(0xFFDC143C))),
      ),
      body: StreamBuilder<List<UserModel>>(
        stream: _usersStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching users'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          List<UserModel> users = snapshot.data ?? [];

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return _buildUserCard(users[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildUserCard(UserModel user) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: user.profileImageUrl.isNotEmpty
              ? NetworkImage(user.profileImageUrl)
              : const AssetImage('assets/default_profile_image.jpg') as ImageProvider,
          radius: 25.0,
        ),
        title: Text(user.name),
        subtitle: Text(user.email),
        trailing: Text('Active: ${user.lastActive.toString()}'), // Example: Show last active timestamp
      ),
    );
  }
}
void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AdminNavigation(),
  ));
}