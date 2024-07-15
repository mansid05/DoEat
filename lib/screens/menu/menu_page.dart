import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_app/screens/menu/cart/cart_manager.dart';
import 'package:food_app/screens/menu/cart/cart_page.dart';
import 'package:food_app/screens/profile/profile_page.dart';
import 'package:food_app/screens/search/filter_page.dart';
import 'package:food_app/screens/home/home_page.dart';
import 'package:food_app/screens/search/search_page.dart';

import '../../models/FoodItem.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MenuPage(),
  ));
}

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int _currentIndex = 2;
  String? _selectedCategory;
  String? _selectedSortOption;
  List<DropdownMenuItem<String>> _categoryItems = [];
  List<QueryDocumentSnapshot> _foodItems = [];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      switch (index) {
        case 0:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
          break;
        case 1:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SearchPage()),
          );
          break;
        case 2:
          break;
        case 3:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ProfilePage()),
          );
          break;
      }
    });
  }

  void _sortFoodItems(String? sortOption) {
    if (sortOption == 'Low to High') {
      _foodItems.sort((a, b) {
        var foodA = a.data() as Map<String, dynamic>;
        var foodB = b.data() as Map<String, dynamic>;
        return foodA['price'].compareTo(foodB['price']);
      });
    } else if (sortOption == 'High to Low') {
      _foodItems.sort((a, b) {
        var foodA = a.data() as Map<String, dynamic>;
        var foodB = b.data() as Map<String, dynamic>;
        return foodB['price'].compareTo(foodA['price']);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFDC143C)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('MENU ITEMS', style: TextStyle(color: Color(0xFFDC143C))),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Color(0xFFDC143C)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Color(0xFFDC143C)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FilterPage()),
              );
            },
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            const SizedBox(height: 10.0),
            _buildCategoryAndSortDropdowns(),
            const SizedBox(height: 10.0),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('menuItems').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading menu items'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                _foodItems = snapshot.data!.docs;

                // Apply sorting
                if (_selectedSortOption != null) {
                  _sortFoodItems(_selectedSortOption);
                }

                // Filter by category if a category is selected
                var filteredFoodItems = _selectedCategory != null
                    ? _foodItems.where((item) {
                  var data = item.data() as Map<String, dynamic>;
                  return data['category'] == _selectedCategory;
                }).toList()
                    : _foodItems;

                return Column(
                  children: List.generate((filteredFoodItems.length / 2).ceil(), (index) {
                    int first = index * 2;
                    int? second = first + 1 < filteredFoodItems.length ? first + 1 : null;
                    return _buildCardRow(filteredFoodItems[first], second != null ? filteredFoodItems[second] : null);
                  }),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30.0),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, size: 30.0),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu, size: 30.0),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 30.0),
            label: '',
          ),
        ],
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFFDC143C),
        unselectedItemColor: Colors.grey,
        selectedIconTheme: const IconThemeData(
          size: 35.0,
          color: Color(0xFFDC143C),
        ),
        unselectedIconTheme: const IconThemeData(
          size: 30.0,
        ),
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: Color(0xFFDC143C)),
          hintText: 'What are you looking for?',
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }

  Widget _buildCategoryAndSortDropdowns() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DropdownButton<String>(
            hint: const Text("Sort By"),
            value: _selectedSortOption,
            items: const [
              DropdownMenuItem<String>(
                value: 'Low to High',
                child: Text('Low to High'),
              ),
              DropdownMenuItem<String>(
                value: 'High to Low',
                child: Text('High to Low'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _selectedSortOption = value;
                _sortFoodItems(value);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCardRow(QueryDocumentSnapshot firstDoc, QueryDocumentSnapshot? secondDoc) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        children: [
          Expanded(child: _buildMenuCard(firstDoc)),
          const SizedBox(width: 8.0),
          secondDoc != null ? Expanded(child: _buildMenuCard(secondDoc)) : Expanded(child: Container()),
        ],
      ),
    );
  }

  Widget _buildMenuCard(QueryDocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    var foodItem = FoodItem(
      name: data['name'],
      restaurant: data['restaurant'],
      image: data['image'],
      price: data['price'],
      offer: data['offer'],
      id: data['id'],
      isFavorite: false,
      description: data['description'],
    );
    return MenuCard(foodItem: foodItem);
  }
}

class MenuCard extends StatefulWidget {
  final FoodItem foodItem;

  const MenuCard({super.key, required this.foodItem});

  @override
  _MenuCardState createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.foodItem.isFavorite;
  }

  void _toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4.0),
                      bottomRight: Radius.circular(4.0),
                    ),
                  ),
                  child: const Text(
                    'Bestseller',
                    style: TextStyle(color: Colors.white, fontSize: 10.0),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : const Color(0xFFDC143C),
                    size: 20.0,
                  ),
                  onPressed: _toggleFavorite,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              widget.foodItem.image,
              height: 100.00,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.foodItem.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.foodItem.restaurant,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 4.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '\₹${widget.foodItem.price.toString()}',
                          style: const TextStyle(
                            color: Color(0xFFDC143C),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.foodItem.offer,
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        CartManager().addItem({
                          'image': widget.foodItem.image,
                          'name': widget.foodItem.name,
                          'price': widget.foodItem.price,
                          'quantity': 1,
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${widget.foodItem.name} added to cart')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        backgroundColor: const Color(0xFFDC143C),
                        minimumSize: const Size(70.0, 36.0),
                      ),
                      child: const Text(
                        'ADD',
                        style: TextStyle(fontSize: 12.0, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
