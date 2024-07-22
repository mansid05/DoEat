import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_app/screens/menu/cart/cart_manager.dart';
import 'package:food_app/screens/menu/cart/cart_page.dart';
import 'package:food_app/screens/search/filter_page.dart';
import '../../models/FoodItem.dart';
import 'details_page.dart';

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
  String? _selectedCategory;
  String? _selectedSortOption;
  List<QueryDocumentSnapshot> _foodItems = [];

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
            _buildSortDropdown(),
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

  Widget _buildSortDropdown() {
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
      id: doc.id,
      name: data['name'],
      restaurant: data['restaurant'],
      price: (data['price'] as num).toDouble(),
      offer: data['offer'],
      isFavorite: data['isFavorite'] ?? false,
      description: data['description'],
      image: data['image'],
    );

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsPage(foodItem: {
              'id': foodItem.id,
              'image': foodItem.image,
              'name': foodItem.name,
              'price': foodItem.price,
              'description': foodItem.description,
              // Add any other fields you need
            }),
          ),
        );
      },
      child: MenuCard(foodItem: foodItem),
    );
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
              height: 100.0,
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
                          '₹${widget.foodItem.price.toString()}',
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
