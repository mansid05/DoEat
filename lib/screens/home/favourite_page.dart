import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_app/models/banner.dart';
import 'package:food_app/screens/menu/cart/cart_manager.dart';
import 'package:food_app/screens/menu/cart/cart_page.dart';
import 'package:food_app/screens/menu/details_page.dart';
import 'package:food_app/screens/search/filter_page.dart';
import '../../models/FoodItem.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  _FavouritePageState createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;
  bool _isForward = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_isForward) {
        if (_currentPage < 4) {
          _currentPage++;
        } else {
          _isForward = false;
          _currentPage--;
        }
      } else {
        if (_currentPage > 0) {
          _currentPage--;
        } else {
          _isForward = true;
          _currentPage++;
        }
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
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
        title: const Text('FAVOURITE ITEMS', style: TextStyle(color: Color(0xFFDC143C))),
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
            _buildSlideBanner(),
            const SizedBox(height: 10.0),
            _buildFavouriteItems(),
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

  Widget _buildSlideBanner() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('banners').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading banners'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        List<BannerItem> banners = snapshot.data!.docs.map((doc) {
          return BannerItem.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();

        return SizedBox(
          height: 150.0,
          child: PageView.builder(
            controller: _pageController,
            itemCount: banners.length,
            itemBuilder: (context, index) {
              return Image.network(banners[index].image, fit: BoxFit.cover);
            },
          ),
        );
      },
    );
  }

  Widget _buildFavouriteItems() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('favouriteItems').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading favourite items'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          List<FoodItem> favouriteItems = snapshot.data!.docs.map((doc) {
            return FoodItem.fromMap(doc.data() as Map<String, dynamic>, doc.id);
          }).toList();

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: favouriteItems.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            itemBuilder: (context, index) {
              final item = favouriteItems[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsPage(foodItem: item.toMap()),
                    ),
                  );
                },
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Image.network(item.image, fit: BoxFit.cover, height: 120.0, width: double.infinity),
                          Positioned(
                            top: 8.0,
                            right: 8.0,
                            child: IconButton(
                              icon: const Icon(Icons.favorite, color: Color(0xFFDC143C)),
                              onPressed: () async {
                                await FirebaseFirestore.instance.collection('favouriteItems').doc(item.id).delete();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('${item.name} removed from favorites')),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(child: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold))),
                            const Icon(Icons.favorite, color: Color(0xFFDC143C)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.restaurant, style: const TextStyle(color: Colors.grey)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('₹${item.price}', style: const TextStyle(color: Color(0xFFDC143C))),
                                ElevatedButton(
                                  onPressed: () {
                                    CartManager().addItem({
                                      'image': item.image,
                                      'name': item.name,
                                      'price': item.price,
                                      'quantity': 1,
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('${item.name} added to cart')),
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
                            Text(item.offer, style: const TextStyle(color: Colors.blue)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
