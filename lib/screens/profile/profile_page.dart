import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_app/screens/profile/order/my_order_page.dart';
import 'package:image_picker/image_picker.dart';
import '../../auth/login_page.dart';
import '../home/favourite_page.dart';
import 'address/address_page.dart';
import 'setting/language_page.dart';
import 'setting/setting_page.dart';
import '../home/home_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = '';
  String email = '';
  String address = '';
  String contactNumber = '';
  String profileImageUrl = ''; // Placeholder for profile image URL

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
        if (userDoc.exists) {
          final userData = userDoc.data()!;
          setState(() {
            name = userData['name'] ?? '';
            email = userData['email'] ?? '';
            address = userData['address'] ?? '';
            contactNumber = userData['contactNumber'] ?? '';
            profileImageUrl = userData['profileImageUrl'] ?? '';

            // Update controllers with fetched data
            nameController.text = name;
            emailController.text = email;
            addressController.text = address;
            contactNumberController.text = contactNumber;
          });
        }
      } catch (e) {
        print('Error fetching user data: $e');
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    addressController.dispose();
    contactNumberController.dispose();
    super.dispose();
  }

  Future<void> _editProfilePicture() async {
    final picker = ImagePicker();
    final pickedFile = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        actions: [
          TextButton(
            child: const Text('Gallery'),
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
          ),
        ],
      ),
    );

    if (pickedFile != null) {
      final selectedFile = await picker.pickImage(source: pickedFile);
      if (selectedFile != null) {
        File imageFile = File(selectedFile.path);

        // Upload the image to Firebase Storage
        try {
          String fileName = DateTime.now().toIso8601String();
          Reference storageReference = FirebaseStorage.instance.ref().child('profile_pictures/$fileName');
          UploadTask uploadTask = storageReference.putFile(imageFile);

          TaskSnapshot snapshot = await uploadTask;
          String downloadUrl = await snapshot.ref.getDownloadURL();

          // Update profileImageUrl with the new URL
          setState(() {
            profileImageUrl = downloadUrl;
          });

          // Optionally, update the Firestore document with the new profile image URL
          final uid = FirebaseAuth.instance.currentUser?.uid;
          if (uid != null) {
            await FirebaseFirestore.instance.collection('users').doc(uid).update({
              'profileImageUrl': profileImageUrl,
            });
          }
        } catch (e) {
          print('Error uploading image: $e');
        }
      }
    }
  }

  Future<void> _editProfileDetails() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 50.0,
                  backgroundImage: profileImageUrl.isNotEmpty
                      ? NetworkImage(profileImageUrl) // If using network image
                      : const AssetImage('assets/default_profile.png'), // Placeholder or default image
                ),
                const SizedBox(height: 12.0),
                TextButton(
                  onPressed: _editProfilePicture,
                  child: const Text('Change Profile Picture'),
                ),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                  ),
                ),
                TextField(
                  controller: contactNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Contact Number',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  name = nameController.text;
                  email = emailController.text;
                  address = addressController.text;
                  contactNumber = contactNumberController.text;
                  // Save changes to backend or storage here if needed
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save', style: TextStyle(color: Color(0xFFDC143C))),
            ),
          ],
        );
      },
    );
  }
  Future<void> _saveProfileDetails() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'name': nameController.text,
          'email': emailController.text,
          'address': addressController.text,
          'contactNumber': contactNumberController.text,
          'profileImageUrl': profileImageUrl, // Update with the new URL if changed
        });
      } catch (e) {
        print('Error updating user data: $e');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PROFILE', style: TextStyle(color: Color(0xFFDC143C))),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Color(0xFFDC143C)),
            onPressed: _editProfileDetails,
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20.0),
            CircleAvatar(
              radius: 50.0,
              backgroundColor: Colors.grey[200],
              backgroundImage: profileImageUrl.isNotEmpty
                  ? NetworkImage(profileImageUrl) // If using network image
                  : const AssetImage('assets/default_profile.png'), // Placeholder or default image
              child: profileImageUrl.isEmpty
                  ? const Icon(Icons.person, size: 50.0, color: Color(0xFFDC143C))
                  : null,
            ),
            const SizedBox(height: 20.0),
            Text(
              name,
              style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 8.0),
            Text(
              email,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20.0),
            _buildCombinedCard(
              Icons.payment, 'Payment Methods',
              Icons.location_on, 'Address',
            ),
            const SizedBox(height: 12.0),
            _buildGroupedCard(
              Icons.favorite, 'Favourite Orders',
              Icons.shopping_bag, 'My Orders',
              Icons.language, 'Language',
              Icons.settings, 'Settings',
            ),
            const SizedBox(height: 12.0),
            _buildCard(Icons.logout, 'Logout', color: Colors.red),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  Widget _buildCombinedCard(
      IconData icon1, String title1,
      IconData icon2, String title2,
      ) {
    return Card(
      elevation: 2.0,
      child: Column(
        children: [
          ListTile(
            leading: Icon(icon2, color: const Color(0xFFDC143C)),
            title: Text(title2),
            trailing: const Icon(Icons.chevron_right, color: Color(0xFFDC143C)),
            onTap: () {
              // Navigate to AddressPage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddressPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGroupedCard(
      IconData icon1, String title1,
      IconData icon2, String title2,
      IconData icon3, String title3,
      IconData icon4, String title4,
      ) {
    return Card(
      elevation: 2.0,
      child: Column(
        children: [
          ListTile(
            leading: Icon(icon1, color: const Color(0xFFDC143C)),
            title: Text(title1),
            trailing: const Icon(Icons.chevron_right, color: Color(0xFFDC143C)),
            onTap: () {
              // Navigate to FavouritePage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavouritePage()),
              );
            },
          ),
          const Divider(height: 0),
          ListTile(
            leading: Icon(icon2, color: const Color(0xFFDC143C)),
            title: Text(title2),
            trailing: const Icon(Icons.chevron_right, color: Color(0xFFDC143C)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyOrderPage()),
              );
              },
          ),
          const Divider(height: 0),
          ListTile(
            leading: Icon(icon3, color: const Color(0xFFDC143C)),
            title: Text(title3),
            trailing: const Icon(Icons.chevron_right, color: Color(0xFFDC143C)),
            onTap: () {
              // Navigate to LanguagePage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LanguagePage()),
              );
            },
          ),
          const Divider(height: 0),
          ListTile(
            leading: Icon(icon4, color: const Color(0xFFDC143C)),
            title: Text(title4),
            trailing: const Icon(Icons.chevron_right, color: Color(0xFFDC143C)),
            onTap: () {
              // Navigate to SettingPage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCard(IconData icon, String title, {Color color = Colors.black}) {
    return Card(
      elevation: 2.0,
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right, color: Color(0xFFDC143C)),
        onTap: () async {
          if (title == 'Logout') {
            await FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          }
        },
      ),
    );
  }
}

