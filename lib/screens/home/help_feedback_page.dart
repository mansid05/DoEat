import 'package:flutter/material.dart';

class HelpFeedbackPage extends StatefulWidget {
  const HelpFeedbackPage({super.key});

  @override
  _HelpFeedbackPageState createState() => _HelpFeedbackPageState();
}

class _HelpFeedbackPageState extends State<HelpFeedbackPage> {
  int _selectedRating = 0;

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
        title: const Text('HELP and FEEDBACK', style: TextStyle(color: Color(0xFFDC143C))),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'We value your feedback!',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Color(0xFFDC143C)),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Please fill out the form below to provide your feedback or report any issues you are experiencing.',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Name',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Color(0xFFDC143C)),
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
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Color(0xFFDC143C)),
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
              'Feedback or Issue',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Color(0xFFDC143C)),
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
            const Text(
              'Rating',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Color(0xFFDC143C)),
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _selectedRating ? Icons.star : Icons.star_border,
                    color: const Color(0xFFDC143C),
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedRating = index + 1;
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC143C),
                padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 40.0),
              ),
              onPressed: () {
                // Handle fo
                // rm submission
              },
              child: const Text(
                'Submit',
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
