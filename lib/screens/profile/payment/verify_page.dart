import 'package:flutter/material.dart';
import 'package:food_app/screens/profile/payment/payment_page.dart';

class VerifyPage extends StatefulWidget {
  final double total;

  const VerifyPage({super.key, required this.total});

  @override
  _VerifyPageState createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  String address = '123 Main Street, City, Country';
  String contactNumber = '+1234567890';

  final TextEditingController addressController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    addressController.text = address;
    contactNumberController.text = contactNumber;
  }

  @override
  void dispose() {
    addressController.dispose();
    contactNumberController.dispose();
    super.dispose();
  }

  Future<void> _editAddress() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Address'),
          content: TextField(
            controller: addressController,
            decoration: const InputDecoration(
              hintText: 'Enter new address',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  address = addressController.text;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save', style: TextStyle(color: Color(0xFFDC143C))),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editContactNumber() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Contact Number'),
          content: TextField(
            controller: contactNumberController,
            decoration: const InputDecoration(
              hintText: 'Enter new contact number',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  contactNumber = contactNumberController.text;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save', style: TextStyle(color: Color(0xFFDC143C))),
            ),
          ],
        );
      },
    );
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
        title: const Text('Verify Address', style: TextStyle(color: Color(0xFFDC143C))),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text(
                      'Payable Amount',
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      '\$${widget.total.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 24.0, color: Color(0xFFDC143C)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Card(
              child: ListTile(
                title: const Text('Delivery Address', style: TextStyle(color: Color(0xFFDC143C))),
                subtitle: Text(address),
                trailing: IconButton(
                  icon: const Icon(Icons.edit, color: Color(0xFFDC143C)),
                  onPressed: _editAddress,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Card(
              child: ListTile(
                title: const Text('Contact Number', style: TextStyle(color: Color(0xFFDC143C))),
                subtitle: Text(contactNumber),
                trailing: IconButton(
                  icon: const Icon(Icons.edit, color: Color(0xFFDC143C)),
                  onPressed: _editContactNumber,
                ),
              ),
            ),
            const Spacer(), // This pushes the button to the bottom
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC143C),
                padding: const EdgeInsets.symmetric(vertical: 15.0),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentPage(total: widget.total),
                  ),
                );
              },
              child: const Text(
                'Pay Now',
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}