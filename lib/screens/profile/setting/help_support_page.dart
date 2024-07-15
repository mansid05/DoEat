import 'package:flutter/material.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

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
        title: const Text(
            'HELP & SUPPORT', style: TextStyle(color: Color(0xFFDC143C))),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'How can we help you?',
              style: TextStyle(fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFDC143C)),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'If you have any questions or need assistance, please fill out the form below and our support team will get back to you as soon as possible.',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Name',
              style: TextStyle(fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFDC143C)),
            ),
            const SizedBox(height: 10.0),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Enter your name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Email',
              style: TextStyle(fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFDC143C)),
            ),
            const SizedBox(height: 10.0),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Enter your email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Message',
              style: TextStyle(fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFDC143C)),
            ),
            const SizedBox(height: 10.0),
            const TextField(
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Enter your message',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC143C),
                padding: const EdgeInsets.symmetric(vertical: 15.0),
              ),
              onPressed: () {
                // Handle form submission
              },
              child: const Text(
                'Submit',
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ),
            const SizedBox(height: 20.0),
            const Divider(color: Color(0xFFDC143C)),
            const SizedBox(height: 20.0),
            const Text(
              'Frequently Asked Questions',
              style: TextStyle(fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFDC143C)),
            ),
            const SizedBox(height: 10.0),
            ListTile(
              title: const Text('How do I track my order?',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text(
                  'You can track your order by logging into your account and clicking on "My Orders".'),
              trailing: const Icon(
                  Icons.keyboard_arrow_right, color: Color(0xFFDC143C)),
              onTap: () {
                // Navigate to FAQ detail
              },
            ),
            ListTile(
              title: const Text('How can I cancel my order?',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text(
                  'To cancel an order, please contact our support team as soon as possible.'),
              trailing: const Icon(
                  Icons.keyboard_arrow_right, color: Color(0xFFDC143C)),
              onTap: () {
                // Navigate to FAQ detail
              },
            ),
            ListTile(
              title: const Text('What payment methods do you accept?',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text(
                  'We accept credit/debit cards, UPI, net banking, and cash on delivery.'),
              trailing: const Icon(
                  Icons.keyboard_arrow_right, color: Color(0xFFDC143C)),
              onTap: () {
                // Navigate to FAQ detail
              },
            ),
          ],
        ),
      ),
    );
  }
}