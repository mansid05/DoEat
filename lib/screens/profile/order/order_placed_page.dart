import 'package:flutter/material.dart';
import 'package:food_app/screens/home/home_page.dart';

class OrderPlacedPage extends StatelessWidget {
  const OrderPlacedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFDC143C)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFDC143C)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80.0),
            const SizedBox(height: 20.0),
            const Text(
              'Order Placed Successfully!',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Color(0xFFDC143C)),
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDC143C),
                  side: const BorderSide(color: Color(0xFFDC143C), width: 2.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0), // Adjust horizontal padding here
                ),
                child: const Text('Continue Shopping', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 15.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: OutlinedButton(
                onPressed: () {
                  // Navigate to order details page
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFDC143C), width: 2.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0), // Adjust horizontal padding here
                ),
                child: const Text('View Order', style: TextStyle(color: Color(0xFFDC143C))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
