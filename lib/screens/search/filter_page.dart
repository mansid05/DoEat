import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  List<String> categories = [
    'All', 'Breakfast', 'Lunch', 'Dinner', 'Brunch', 'Snacks', 'Desserts', 'Appetizers', 'Drinks', 'Shakes'
  ];
  List<String> foodTypes = ['Veg', 'NonVeg', 'Baked', 'Roasted', 'Beverages'];

  Map<String, bool> selectedCategories = {};
  Map<String, bool> selectedFoodTypes = {};

  RangeValues _currentRangeValues = const RangeValues(500, 1500);

  @override
  void initState() {
    super.initState();
    for (var category in categories) {
      selectedCategories[category] = false;
    }
    for (var foodType in foodTypes) {
      selectedFoodTypes[foodType] = false;
    }
  }

  void _toggleCategorySelection(String category) {
    setState(() {
      selectedCategories[category] = !selectedCategories[category]!;
    });
  }

  void _toggleFoodTypeSelection(String foodType) {
    setState(() {
      selectedFoodTypes[foodType] = !selectedFoodTypes[foodType]!;
    });
  }

  void _clearFilters() {
    setState(() {
      for (var category in categories) {
        selectedCategories[category] = false;
      }
      for (var foodType in foodTypes) {
        selectedFoodTypes[foodType] = false;
      }
      _currentRangeValues = const RangeValues(500, 1500);
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
        title: const Text('FILTER', style: TextStyle(color: Color(0xFFDC143C))),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Color(0xFFDC143C)),
            onPressed: () {
              // Navigate to cart page
            },
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Categories', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Color(0xFFDC143C))),
            Wrap(
              spacing: 10.0,
              children: categories.map((category) {
                return ChoiceChip(
                  label: Text(category, style: TextStyle(color: selectedCategories[category]! ? Colors.white : Colors.black)),
                  selected: selectedCategories[category]!,
                  selectedColor: const Color(0xFFDC143C),
                  onSelected: (isSelected) {
                    _toggleCategorySelection(category);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20.0),
            const Text('Types of food', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Color(0xFFDC143C))),
            Wrap(
              spacing: 10.0,
              children: foodTypes.map((foodType) {
                return ChoiceChip(
                  label: Text(foodType, style: TextStyle(color: selectedFoodTypes[foodType]! ? Colors.white : Colors.black)),
                  selected: selectedFoodTypes[foodType]!,
                  selectedColor: const Color(0xFFDC143C),
                  onSelected: (isSelected) {
                    _toggleFoodTypeSelection(foodType);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20.0),
            const Text('Price Range', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Color(0xFFDC143C))),
            RangeSlider(
              values: _currentRangeValues,
              min: 0,
              max: 2000,
              divisions: 20,
              activeColor: const Color(0xFFDC143C),
              labels: RangeLabels(
                _currentRangeValues.start.round().toString(),
                _currentRangeValues.end.round().toString(),
              ),
              onChanged: (values) {
                setState(() {
                  _currentRangeValues = values;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFDC143C)),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: const Text('Rs. 1000', style: TextStyle(fontSize: 16.0)),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFDC143C)),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: const Text('Rs. 2000', style: TextStyle(fontSize: 16.0)),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC143C),
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                minimumSize: const Size(double.infinity, 50),
                side: const BorderSide(color: Colors.black),
              ),
              onPressed: () {
                // Apply filters
              },
              child: const Text(
                'APPLY FILTER',
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ),
            Center(
              child: TextButton(
                onPressed: _clearFilters,
                child: const Text(
                  'Clear Filter',
                  style: TextStyle(color: Color(0xFFDC143C), fontSize: 16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: FilterPage(),
  ));
}
