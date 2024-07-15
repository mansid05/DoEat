import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy', style: TextStyle(color: Color(0xFFDC143C))),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFDC143C)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.0),
              Text(
                'Thank you for using the "Do Eat" food delivery app. This Privacy Policy explains how we collect, use and safeguard your information when you use our mobile application. Please read this Privacy Policy carefully.',
              ),
              SizedBox(height: 20.0),
              Text(
                'Information We Collect',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Color(0xFFDC143C)),
              ),
              Text(
                'We may collect and process the following information about you:\n-Contact Information: Including name, address (such as home address, work address, or other delivery address), email address, phone number, and other contact information provided to us.',
              ),
              SizedBox(height: 20.0),
              Text(
                'How We Use Your Information',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Color(0xFFDC143C)),
              ),
              Text(
                'We may use the information we collect from you to:\nProvide, maintain, and improve our Application.\nProvide and deliver the products and services you request.\nRespond to your comments, questions, and requests and provide customer service.\nCommunicate with you about products, services, offers, promotions, and events.\nMonitor and analyze trends, usage, and activities in connection with our Application.',
              ),
              SizedBox(height: 20.0),
              Text(
                'Disclosure of Your Information',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Color(0xFFDC143C)),
              ),
              Text(
                'We may share your information with third parties under the following circumstances:\n-With our kitchen or affiliated kitchens to fulfill your orders.\n-With service providers who assist us in providing the App and its services.\n-With law enforcement or government authorities if required by law.',
              ),
              SizedBox(height: 20.0),
              Text(
                'Data Retention Policy',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Color(0xFFDC143C)),
              ),
              Text(
                'We will retain your information for as long as you use the Application and for a reasonable time thereafter. If you wish to request that we no longer use your information to provide you services, please contact us at the email address listed below.',
              ),
              SizedBox(height: 20.0),
              Text(
                'Changes to Our Privacy Policy',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Color(0xFFDC143C)),
              ),
              Text(
                'We reserve the right to change this Privacy Policy at any time. If we make changes, we will notify you by revising the date at the top of the policy. We encourage you to review this Privacy Policy regularly.',
              ),
              SizedBox(height: 20.0),
              Text(
                'Contact Us',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Color(0xFFDC143C)),
              ),
              Text(
                'If you have any questions or comments about this Privacy Policy, please contact us at royalswebtech.director@gmail.com.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
