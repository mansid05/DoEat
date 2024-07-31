import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_app/screens/search/filter_page.dart';

// Fetch food items from Firestore
Future<List<Map<String, dynamic>>> fetchFoodItems() async {
  try {
    // Fetch data from both collections
    QuerySnapshot homePageSnapshot = await FirebaseFirestore.instance.collection('products').get();
    QuerySnapshot menuPageSnapshot = await FirebaseFirestore.instance.collection('menuItems').get();

    // Combine data from both collections
    List<Map<String, dynamic>> allItems = [
      ...homePageSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>),
      ...menuPageSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>),
    ];

    return allItems;
  } catch (e) {
    print('Error fetching food items: $e');
    return [];
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Map<String, dynamic>> foodItems = [];
  List<Map<String, dynamic>> filteredFoodItems = [];

  @override
  void initState() {
    super.initState();
    _loadFoodItems();  // Load food items on initialization
  }

  Future<void> _loadFoodItems() async {
    final items = await fetchFoodItems();
    setState(() {
      foodItems = items;
      filteredFoodItems = items; // Initially set to all items
    });
  }

  void _filterFoodItems(String query) {
    setState(() {
      if (query.isNotEmpty) {
        filteredFoodItems = foodItems.where((foodItem) {
          final foodNameLower = foodItem['name']?.toLowerCase() ?? '';
          final restaurantLower = foodItem['restaurant']?.toLowerCase() ?? '';
          final searchLower = query.toLowerCase();
          return foodNameLower.contains(searchLower) || restaurantLower.contains(searchLower);
        }).toList();
      } else {
        filteredFoodItems = foodItems; // Show all items if query is empty
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SEARCH FOOD', style: TextStyle(color: Color(0xFFDC143C))),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Color(0xFFDC143C)),
            onPressed: () {
              // Handle filter icon press
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: _filterFoodItems,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Color(0xFFDC143C)),
                hintText: 'Search',
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredFoodItems.length,
              itemBuilder: (context, index) {
                final foodItem = filteredFoodItems[index];
                return ListTile(
                  leading: SizedBox(
                    height: 50.0,
                    width: 50.0,
                    child: Image.network(foodItem['image'] ?? '', fit: BoxFit.cover), // Use Image.network for URLs
                  ),
                  title: Text(foodItem['name'] ?? 'No Name'),
                  subtitle: Text(foodItem['restaurant'] ?? 'No Restaurant'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SearchPage(),
  ));
}
