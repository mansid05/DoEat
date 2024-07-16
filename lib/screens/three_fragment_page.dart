import 'package:flutter/material.dart';
import 'package:food_app/screens/user_navigation.dart';

class ThreeFragmentPage extends StatefulWidget {
  const ThreeFragmentPage({super.key});

  @override
  _ThreeFragmentPageState createState() => _ThreeFragmentPageState();
}

class _ThreeFragmentPageState extends State<ThreeFragmentPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  children: [
                    _buildFragment(
                      'assets/logos/fresh_food_image.png',
                      'Fresh Foods',
                      'Natures bounty, delivered fresh to your plate, Fresh flavors that nourish and delight',
                    ),
                    _buildFragment(
                      'assets/logos/easy_payment_image.png',
                      'Easy Payment',
                      'Seamless payments for effortless orders, Simplify your checkout, pay with ease',
                    ),
                    _buildFragment(
                      'assets/logos/fast_delivery_image.png',
                      'Fast Delivery',
                      'Speedy satisfaction, delivered to your door, Fresh flavors, fast to your plate',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) => _buildDot(index)),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_currentPage != 0)
                    ElevatedButton(
                      onPressed: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDC143C),
                      ),
                      child: const Text(
                        'Previous',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  if (_currentPage != 2)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease,
                          );
                          if (_currentPage == 2) {
                            _navigateToHomePage();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDC143C),
                        ),
                        child: Text(
                          _currentPage == 2 ? 'Finish' : 'Next',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10.0),
              TextButton(
                onPressed: () {
                  _navigateToHomePage();
                },
                child: const Text(
                  'Skip',
                  style: TextStyle(color: Color(0xFFDC143C)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToHomePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UserNavigation()),
    );
  }

  Widget _buildDot(int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 10.0,
        height: 10.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _currentPage == index ? const Color(0xFFDC143C) : Colors.grey,
        ),
      ),
    );
  }

  Widget _buildFragment(String imagePath, String title, String tagline) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          imagePath,
          width: 200.0,
          height: 200.0,
        ),
        const SizedBox(height: 20.0),
        Text(
          title,
          style: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFFDC143C),
          ),
        ),
        const SizedBox(height: 10.0),
        Text(
          tagline,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16.0,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ThreeFragmentPage(),
  ));
}