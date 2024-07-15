import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_app/models/FoodItem.dart';
import 'package:food_app/models/Category.dart';  // Import the Category class
import 'admin_navigation.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final TextEditingController _bannerUrlController = TextEditingController();
  final TextEditingController _foodNameController = TextEditingController();
  final TextEditingController _restaurantController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _offerController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _foodImageUrlController = TextEditingController();
  final TextEditingController _categoryNameController = TextEditingController();
  final TextEditingController _categoryImageUrlController = TextEditingController();

  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    List<Category> categoryList = await Category().getCategory();
    setState(() {
      categories = categoryList;
    });
  }

  @override
  void dispose() {
    _bannerUrlController.dispose();
    _foodNameController.dispose();
    _restaurantController.dispose();
    _priceController.dispose();
    _offerController.dispose();
    _descriptionController.dispose();
    _foodImageUrlController.dispose();
    _categoryNameController.dispose();
    _categoryImageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Manage Banners'),
            const SizedBox(height: 10.0),
            _buildBannerForm(),
            const SizedBox(height: 20.0),
            const Divider(),
            const SizedBox(height: 20.0),
            _buildSectionTitle('Manage Food Items'),
            const SizedBox(height: 10.0),
            _buildFoodItemForm(),
            const SizedBox(height: 20.0),
            const Divider(),
            const SizedBox(height: 20.0),
            _buildSectionTitle('Manage Popular Items'),
            const SizedBox(height: 10.0),
            _buildPopularItemForm(),
            const SizedBox(height: 20.0),
            const Divider(),
            const SizedBox(height: 20.0),
            _buildSectionTitle('Manage Categories'),
            const SizedBox(height: 10.0),
            _buildCategoryForm(),
            const SizedBox(height: 20.0),
            _buildCategoryList(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Admin Dashboard'),
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: _showAddOptionsDialog,
        ),
      ],
    );
  }

  void _showAddOptionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Item'),
          content: const Text('Would you like to add a Banner, Food Item, Popular Item, or Category?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showAddBannerDialog();
              },
              child: const Text('Banner'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showAddFoodItemDialog();
              },
              child: const Text('Food Item'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showAddPopularItemDialog();
              },
              child: const Text('Popular Item'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showAddCategoryDialog();
              },
              child: const Text('Category'),
            ),
          ],
        );
      },
    );
  }

  void _showAddBannerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Banner'),
          content: _buildBannerForm(),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addBanner();
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showAddFoodItemDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Food Item'),
          content: SingleChildScrollView(child: _buildFoodItemForm()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addFoodItem();
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showAddPopularItemDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Popular Item'),
          content: SingleChildScrollView(child: _buildPopularItemForm()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addPopularItem();
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showAddCategoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Category'),
          content: SingleChildScrollView(child: _buildCategoryForm()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addCategory();
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildBannerForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _bannerUrlController,
          decoration: const InputDecoration(
            labelText: 'Banner Image URL',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10.0),
        ElevatedButton(
          onPressed: _addBanner,
          child: const Text('Add Banner'),
        ),
      ],
    );
  }

  void _addBanner() {
    String imageUrl = _bannerUrlController.text.trim();
    if (imageUrl.isNotEmpty) {
      FirebaseFirestore.instance.collection('banners').add({
        'image': imageUrl,
      }).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Banner added successfully')),
        );
        _bannerUrlController.clear();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add banner: $error')),
        );
      });
    }
  }

  Widget _buildFoodItemForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(_foodNameController, 'Food Name'),
        const SizedBox(height: 10.0),
        _buildTextField(_restaurantController, 'Restaurant'),
        const SizedBox(height: 10.0),
        _buildTextField(_priceController, 'Price'),
        const SizedBox(height: 10.0),
        _buildTextField(_offerController, 'Offer'),
        const SizedBox(height: 10.0),
        _buildTextField(_descriptionController, 'Description'),
        const SizedBox(height: 10.0),
        _buildTextField(_foodImageUrlController, 'Food Image URL'),
        const SizedBox(height: 10.0),
        ElevatedButton(
          onPressed: _addFoodItem,
          child: const Text('Add Food Item'),
        ),
      ],
    );
  }

  Widget _buildPopularItemForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(_foodNameController, 'Popular Item Name'),
        const SizedBox(height: 10.0),
        _buildTextField(_priceController, 'Price'),
        const SizedBox(height: 10.0),
        _buildTextField(_foodImageUrlController, 'Popular Item Image URL'),
        const SizedBox(height: 10.0),
        ElevatedButton(
          onPressed: _addPopularItem,
          child: const Text('Add Popular Item'),
        ),
      ],
    );
  }

  Widget _buildCategoryForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(_categoryNameController, 'Category Name'),
        const SizedBox(height: 10.0),
        _buildTextField(_categoryImageUrlController, 'Category Image URL'),
        const SizedBox(height: 10.0),
        ElevatedButton(
          onPressed: _addCategory,
          child: const Text('Add Category'),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
    );
  }

  void _addFoodItem() {
    String name = _foodNameController.text.trim();
    String restaurant = _restaurantController.text.trim();
    double price = double.tryParse(_priceController.text.trim()) ?? 0.0;
    String offer = _offerController.text.trim();
    String description = _descriptionController.text.trim();
    String imageUrl = _foodImageUrlController.text.trim();

    if (name.isNotEmpty && restaurant.isNotEmpty && price > 0 && imageUrl.isNotEmpty) {
      FoodItem foodItem = FoodItem(
        id: '',
        name: name,
        restaurant: restaurant,
        price: price,
        offer: offer,
        isFavorite: false, // Default value
        description: description,
        image: imageUrl,
      );

      FirebaseFirestore.instance.collection('products').add(foodItem.toMap()).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Food item added successfully')),
        );
        _clearFoodItemForm();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add food item: $error')),
        );
      });
    }
  }

  void _addPopularItem() {
    String name = _foodNameController.text.trim();
    double price = double.tryParse(_priceController.text.trim()) ?? 0.0;
    String imageUrl = _foodImageUrlController.text.trim();

    if (name.isNotEmpty && price > 0 && imageUrl.isNotEmpty) {
      FoodItem popularItem = FoodItem(
        id: '',
        name: name,
        restaurant: '',
        price: price,
        offer: '',
        isFavorite: false, // Default value
        description: '',
        image: imageUrl,
      );

      FirebaseFirestore.instance.collection('popular_items').add(popularItem.toMap()).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Popular item added successfully')),
        );
        _clearPopularItemForm();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add popular item: $error')),
        );
      });
    }
  }

  void _addCategory() {
    String name = _categoryNameController.text.trim();
    String imageUrl = _categoryImageUrlController.text.trim();

    if (name.isNotEmpty && imageUrl.isNotEmpty) {
      Category category = Category(name: name, url: imageUrl);

      FirebaseFirestore.instance.collection('category').add(category.toJson()).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Category added successfully')),
        );
        _clearCategoryForm();
        _loadCategories(); // Reload categories after adding a new one
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add category: $error')),
        );
      });
    }
  }

  void _clearFoodItemForm() {
    _foodNameController.clear();
    _restaurantController.clear();
    _priceController.clear();
    _offerController.clear();
    _descriptionController.clear();
    _foodImageUrlController.clear();
  }

  void _clearPopularItemForm() {
    _foodNameController.clear();
    _priceController.clear();
    _foodImageUrlController.clear();
  }

  void _clearCategoryForm() {
    _categoryNameController.clear();
    _categoryImageUrlController.clear();
  }

  Widget _buildCategoryList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: categories.length,
      itemBuilder: (context, index) {
        Category category = categories[index];
        return ListTile(
          title: Text(category.name ?? 'No Name'),
          subtitle: Text(category.url ?? 'No Image URL'),
        );
      },
    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AdminNavigation(),
  ));
}
