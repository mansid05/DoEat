import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_app/models/Banner.dart';
import 'package:food_app/models/Category.dart';
import 'package:food_app/models/FoodItem.dart';
import 'package:food_app/models/User.dart';
import 'package:food_app/screens/home/favourite_page.dart';
import 'package:food_app/screens/home/help_feedback_page.dart';
import 'package:food_app/screens/menu/cart/cart_page.dart';
import 'package:food_app/screens/profile/setting/setting_page.dart';
import '../menu/cart/cart_manager.dart';
import '../menu/details_page.dart';
import '../profile/profile_page.dart';
import '../search/search_page.dart'; // Import the DetailsPage

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;
  bool _isForward = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_isForward) {
        if (_currentPage < 3) {
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
        duration: const Duration(milliseconds: 1000),
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
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            _buildSlideBanner(),
            const SizedBox(height: 20.0),
            _buildSearchBar(),
            const SizedBox(height: 20.0),
            _buildCategorySection(),
            const SizedBox(height: 20.0),
            _buildSectionTitle('All Products', topMargin: 0.0),
            const SizedBox(height: 5.0),
            _buildProductGrid(),
            const SizedBox(height: 10.0),
            _buildSectionTitle('Most Popular', topMargin: 0.0),
            const SizedBox(height: 5.0),
            _buildPopularCarousel(),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Color(0xFFDC143C)),
        onPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
      title: const Text('HOME', style: TextStyle(color: Color(0xFFDC143C))),
      actions: [
        IconButton(
          icon: const Icon(Icons.favorite_border, color: Color(0xFFDC143C)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FavouritePage()),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.shopping_cart, color: Color(0xFFDC143C)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartPage()),
            );
          },
        ),
      ],
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.red,
            ),
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(
                  'currentUserId') // Replace with your actual user ID or use FirebaseAuth to get the current user ID
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Error loading user');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Loading user...');
                }

                UserModel user = UserModel.fromMap(
                    snapshot.data!.data() as Map<String, dynamic>,
                    snapshot.data!.id);

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.profileImageUrl),
                      radius: 30,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      user.name,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      user.email,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                );
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text('Search'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Favorites'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavouritePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Cart'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help & Feedback'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const HelpFeedbackPage()),
              );
            },
          ),
        ],
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
              return Image.network(
                banners[index].image,
                fit: BoxFit.cover,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: Color(0xFFDC143C)),
          hintText: 'Search for products',
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(color: Color(0xFFDC143C)),
          ),
        ),
        onSubmitted: (query) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SearchPage()),
          );
        },
      ),
    );
  }

  Widget _buildCategorySection() {
    return FutureBuilder<List<Category>>(
      future: Category().getCategory(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading categories'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        List<Category> categories = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0), // Adjust margin as needed
          child: SizedBox(
            height: 130.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Handle category tap
                        },
                        child: ClipOval(
                          child: Image.network(
                            categories[index].url ?? '',
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Text(categories[index].name ?? ''),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }


  Widget _buildSectionTitle(String title, {double topMargin = 10.0}) {
    return Container(
      margin: EdgeInsets.only(top: topMargin, left: 20.0, right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFFDC143C),
            ),
          ),
          const Icon(
            Icons.arrow_forward,
            color: Color(0xFFDC143C),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    final cartManager = CartManager(); // Get an instance of CartManager

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading products'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        List<FoodItem> productItems = snapshot.data!.docs.map((doc) {
          return FoodItem.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0), // Adjust margin as needed
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: productItems.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8, // Adjust as needed for card size
              mainAxisSpacing: 10.0, // Spacing between rows
              crossAxisSpacing: 10.0, // Spacing between columns
            ),
            itemBuilder: (context, index) {
              FoodItem foodItem = productItems[index];
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
                child: Card(
                  elevation: 3, // Add elevation for a shadow effect
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(10),
                        ),
                        child: Image.network(
                          foodItem.image,
                          height: 100.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              foodItem.name,
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              '₹${foodItem.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            ElevatedButton(
                              onPressed: () async {
                                await cartManager.addItem({
                                  'name': foodItem.name,
                                  'price': foodItem.price,
                                  'image': foodItem.image,
                                  'quantity': 1,
                                });
                                _showSnackBar('${foodItem.name} is added to cart');
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
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }


  Widget _buildPopularCarousel() {
    final cartManager = CartManager();

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('popular_items').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading popular items'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        List<FoodItem> popularItems = snapshot.data!.docs.map((doc) {
          return FoodItem.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0), // Adjust margin as needed
          child: SizedBox(
            height: 250.0, // Adjusted height to prevent overflow
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: popularItems.length,
              itemBuilder: (context, index) {
                FoodItem foodItem = popularItems[index];
                return Container(
                  width: 200.0,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: GestureDetector(
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
                    child: Card(
                      elevation: 3, // Add elevation for a shadow effect
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(10)),
                            child: Image.network(
                              foodItem.image,
                              height: 100.0, // Adjusted image height
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  foodItem.name,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                Text(
                                  '₹${foodItem.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                ElevatedButton(
                                  onPressed: () async {
                                    await cartManager.addItem({
                                      'name': foodItem.name,
                                      'price': foodItem.price,
                                      'image': foodItem.image,
                                      'quantity': 1,
                                    });
                                    _showSnackBar(
                                        '${foodItem.name} is added to cart');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0),
                                    backgroundColor: const Color(0xFFDC143C),
                                    minimumSize: const Size(70.0, 36.0),
                                  ),
                                  child: const Text(
                                    'ADD',
                                    style: TextStyle(
                                        fontSize: 12.0, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}