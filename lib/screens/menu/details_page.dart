import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_app/screens/menu/cart/cart_manager.dart';
import 'package:food_app/screens/profile/payment/verify_page.dart';
import 'cart/cart_page.dart';

class DetailsPage extends StatefulWidget {
  final Map<String, dynamic> foodItem;

  const DetailsPage({super.key, required this.foodItem});

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  int quantity = 1;
  late bool isFavorite;
  List<bool> ratingStars = [false, false, false, false, false];

  @override
  void initState() {
    super.initState();
    isFavorite = widget.foodItem['isFavorite'] == true;
  }

  void _toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
      // Update Firestore with the new favorite status
      FirebaseFirestore.instance.collection('menuItems').doc(widget.foodItem['id']).update({
        'isFavorite': isFavorite,
      });
    });
  }

  void _toggleRating(int index) {
    setState(() {
      for (int i = 0; i < ratingStars.length; i++) {
        ratingStars[i] = i <= index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double price = widget.foodItem['price'] is double ? widget.foodItem['price'] : double.parse(widget.foodItem['price'].toString());
    double totalPrice = price * quantity;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFDC143C)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Product Details', style: TextStyle(color: Color(0xFFDC143C))),
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
              // Handle filter icon press
            },
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Image.network(
                    widget.foodItem['image'] ?? '',
                    height: 200.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : const Color(0xFFDC143C),
                      size: 30.0,
                    ),
                    onPressed: _toggleFavorite,
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Text(
                widget.foodItem['name'] ?? '',
                style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.grey),
                      Text('2 km away'),
                    ],
                  ),
                  Text(
                    '\₹${price.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Color(0xFFDC143C)),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Text(
                widget.foodItem['offer'] == 'Free Shipping' ? 'Free Shipping' : 'Delivery charges apply',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Pre-rating', style: TextStyle(fontSize: 16.0)),
                      Row(
                        children: List.generate(5, (index) {
                          return const Icon(
                            Icons.star,
                            color: Colors.orange,
                            size: 20.0,
                          );
                        }),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Give your rating', style: TextStyle(fontSize: 16.0)),
                      Row(
                        children: List.generate(5, (index) {
                          return IconButton(
                            icon: Icon(
                              ratingStars[index] ? Icons.star : Icons.star_border,
                              color: ratingStars[index] ? Colors.orange : Colors.grey,
                              size: 20.0,
                            ),
                            onPressed: () {
                              _toggleRating(index);
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              const Text('Details', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8.0),
              Text(
                widget.foodItem['description'] ?? 'Delicious food item',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Text('...Read More', style: TextStyle(color: Colors.blue)),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text('Quantity', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 10.0),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          if (quantity > 1) {
                            setState(() {
                              quantity--;
                            });
                          }
                        },
                      ),
                      Text(quantity.toString(), style: const TextStyle(fontSize: 18.0)),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Text('Total Price: \₹${totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Handle add to cart
                      CartManager().addItem({
                        'id': widget.foodItem['id'],
                        'image': widget.foodItem['image'],
                        'name': widget.foodItem['name'],
                        'price': price,
                        'quantity': quantity,
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${widget.foodItem['name']} added to cart')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                      side: const BorderSide(color: Color(0xFFDC143C)),
                    ),
                    child: const Text('Add to Cart', style: TextStyle(color: Color(0xFFDC143C))),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VerifyPage(total: totalPrice,),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDC143C),
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    ),
                    child: const Text('Place Order', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
