import 'package:flutter/material.dart';
import 'package:food_app/screens/search/filter_page.dart';


class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Map<String, String>> foodItems = [
    {
      'image': 'assets/food/food_image_1.png',
      'name': 'Food Name 1',
      'restaurant': 'Restaurant 1',
    },
    {
      'image': 'assets/food/food_image_2.png',
      'name': 'Food Name 2',
      'restaurant': 'Restaurant 2',
    },
    {
      'image': 'assets/food/food_image_3.png',
      'name': 'Food Name 3',
      'restaurant': 'Restaurant 3',
    },
    {
      'image': 'assets/food/food_image_4.png',
      'name': 'Food Name 4',
      'restaurant': 'Restaurant 4',
    },
    {
      'image': 'assets/food/food_image_5.png',
      'name': 'Food Name 5',
      'restaurant': 'Restaurant 5',
    },
  ];

  List<Map<String, String>> filteredFoodItems = [];

  @override
  void initState() {
    super.initState();
    filteredFoodItems = List.from(foodItems);
  }

  void _filterFoodItems(String query) {
    setState(() {
      filteredFoodItems = foodItems.where((foodItem) {
        final foodNameLower = foodItem['name']!.toLowerCase();
        final restaurantLower = foodItem['restaurant']!.toLowerCase();
        final searchLower = query.toLowerCase();

        return foodNameLower.contains(searchLower) || restaurantLower.contains(searchLower);
      }).toList();
    });
  }

  void _removeFoodItem(int index) {
    setState(() {
      filteredFoodItems.removeAt(index);
    });
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
                    child: Image.asset(foodItem['image']!, fit: BoxFit.cover),
                  ),
                  title: Text(foodItem['name']!),
                  subtitle: Text(foodItem['restaurant']!),
                  trailing: IconButton(
                    icon: const Icon(Icons.close, color: Color(0xFFDC143C)),
                    onPressed: () => _removeFoodItem(index),
                  ),
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