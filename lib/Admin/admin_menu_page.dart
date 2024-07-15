import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_navigation.dart'; // Import your AdminNavigation widget here

class AdminMenuPage extends StatefulWidget {
  const AdminMenuPage({super.key});

  @override
  _AdminMenuPageState createState() => _AdminMenuPageState();
}

class _AdminMenuPageState extends State<AdminMenuPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _restaurantController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _offerController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  final bool _isEditing = false;
  late String _documentId; // To store the document ID for editing

  @override
  void dispose() {
    _nameController.dispose();
    _restaurantController.dispose();
    _priceController.dispose();
    _offerController.dispose();
    _descriptionController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isEditing ? const Text('Edit Food Item') : const Text('Add Food Item'),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                // Implement delete functionality
                _deleteFoodItem(_documentId);
              },
            ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              _isEditing ? _editFoodItem() : _addFoodItem();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: _restaurantController,
              decoration: const InputDecoration(labelText: 'Restaurant'),
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Price'),
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: _offerController,
              decoration: const InputDecoration(labelText: 'Offer'),
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: _imageController,
              decoration: const InputDecoration(labelText: 'Image URL'),
            ),
          ],
        ),
      ),
    );
  }

  // Function to add a new food item
  void _addFoodItem() {
    FirebaseFirestore.instance.collection('menuItems').add({
      'name': _nameController.text,
      'restaurant': _restaurantController.text,
      'price': double.parse(_priceController.text),
      'offer': _offerController.text,
      'description': _descriptionController.text,
      'image': _imageController.text,
      'isFavorite': false, // Default value for new items
    }).then((value) {
      Navigator.pop(context);
      // Optionally show a success message
    }).catchError((error) {
      // Handle errors
    });
  }

  // Function to edit an existing food item
  void _editFoodItem() {
    FirebaseFirestore.instance.collection('menuItems').doc(_documentId).update({
      'name': _nameController.text,
      'restaurant': _restaurantController.text,
      'price': double.parse(_priceController.text),
      'offer': _offerController.text,
      'description': _descriptionController.text,
      'image': _imageController.text,
    }).then((value) {
      Navigator.pop(context);
      // Optionally show a success message
    }).catchError((error) {
      // Handle errors
    });
  }

  // Function to delete a food item
  void _deleteFoodItem(String documentId) {
    FirebaseFirestore.instance.collection('menuItems').doc(documentId).delete().then((value) {
      Navigator.pop(context);
      // Optionally show a success message
    }).catchError((error) {
      // Handle errors
    });
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AdminNavigation(),
  ));
}
