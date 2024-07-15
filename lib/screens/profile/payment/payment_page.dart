import 'dart:async';

import 'package:flutter/material.dart';
import 'package:food_app/screens/profile/order/order_placed_page.dart';

class PaymentPage extends StatefulWidget {
  final double total;
  final double deliveryCharges;

  const PaymentPage({super.key, required this.total, this.deliveryCharges = 0.0});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String selectedPaymentMethod = 'cash_delivery';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double finalTotal = widget.total + widget.deliveryCharges;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFDC143C)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('PAYMENT', style: TextStyle(color: Color(0xFFDC143C))),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Select Payment Method',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Color(0xFFDC143C)),
              ),
              const SizedBox(height: 20.0),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFDC143C), width: 1.0),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedPaymentMethod,
                    isExpanded: true,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedPaymentMethod = newValue!;
                      });
                    },
                    items: <String>[
                      'credit_card',
                      'cash_delivery',
                      'upi',
                      'net_banking',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(_getPaymentMethodName(value)),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              if (selectedPaymentMethod == 'credit_card')
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name on Card',
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Color(0xFFDC143C)),
                        ),
                        SizedBox(height: 10.0),
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Enter Name on Card',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          'Account Number',
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Color(0xFFDC143C)),
                        ),
                        SizedBox(height: 10.0),
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Enter Account Number',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Expiration Date',
                                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Color(0xFFDC143C)),
                                  ),
                                  SizedBox(height: 10.0),
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: 'MM/YY',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 20.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'CVV',
                                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Color(0xFFDC143C)),
                                  ),
                                  SizedBox(height: 10.0),
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Enter CVV',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Order Total', style: TextStyle(fontSize: 16.0)),
                    Text('\₹${widget.total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16.0)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Delivery Charges', style: TextStyle(fontSize: 16.0)),
                    Text(widget.deliveryCharges > 0
                        ? '\₹${widget.deliveryCharges.toStringAsFixed(2)}'
                        : 'Free', style: const TextStyle(fontSize: 16.0)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Price', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                    Text('\₹${finalTotal.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDC143C),
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                ),
                onPressed: () {
                  // Simulate loading
                  setState(() {
                    isLoading = true;
                  });

                  // Simulate delay with Timer
                  Timer(const Duration(seconds: 2), () {
                    setState(() {
                      isLoading = false;
                    });
                    // Navigate to OrderPlacedPage
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const OrderPlacedPage()),
                    );
                  });
                },
                child: isLoading
                    ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                    : const Text(
                  'Pay Now',
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getPaymentMethodName(String value) {
    switch (value) {
      case 'credit_card':
        return 'Credit/Debit Card';
      case 'cash_delivery':
        return 'Cash on Delivery';
      case 'upi':
        return 'UPI';
      case 'net_banking':
        return 'Net Banking';
      default:
        return '';
    }
  }
}
