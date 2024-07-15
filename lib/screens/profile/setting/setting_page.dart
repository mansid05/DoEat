import 'package:flutter/material.dart';
import 'package:food_app/screens/profile/setting/change_password_page.dart';
import 'package:food_app/screens/profile/setting/help_support_page.dart';
import 'package:food_app/screens/profile/setting/language_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFDC143C)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('SETTINGS', style: TextStyle(color: Color(0xFFDC143C))),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'General Settings',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Color(0xFFDC143C)),
            ),
            const SizedBox(height: 20.0),
            ListTile(
              leading: const Icon(Icons.notifications, color: Color(0xFFDC143C)),
              title: const Text('Notifications'),
              trailing: Switch(
                value: true, // Example value, you can manage this with a state variable
                onChanged: (bool value) {
                  // Implement logic to change notification settings
                },
                activeColor: const Color(0xFFDC143C),
              ),
            ),
            const Divider(height: 0),
            ListTile(
              leading: const Icon(Icons.lightbulb_outline, color: Color(0xFFDC143C)),
              title: const Text('Dark Mode'),
              trailing: Switch(
                value: false, // Example value, you can manage this with a state variable
                onChanged: (bool value) {
                  // Implement logic to toggle dark mode
                },
                activeColor: const Color(0xFFDC143C),
              ),
            ),
            const Divider(height: 0),
            ListTile(
              leading: const Icon(Icons.language, color: Color(0xFFDC143C)),
              title: const Text('Language'),
              trailing: const Icon(Icons.chevron_right, color: Color(0xFFDC143C)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LanguagePage()),
                );
              },
            ),
            const Divider(height: 0),
            ListTile(
              leading: const Icon(Icons.help_outline, color: Color(0xFFDC143C)),
              title: const Text('Help & Support'),
              trailing: const Icon(Icons.chevron_right, color: Color(0xFFDC143C)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HelpSupportPage()),
                );
              },
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Account Settings',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Color(0xFFDC143C)),
            ),
            const SizedBox(height: 20.0),
            ListTile(
              leading: const Icon(Icons.lock_outline, color: Color(0xFFDC143C)),
              title: const Text('Change Password'),
              trailing: const Icon(Icons.chevron_right, color: Color(0xFFDC143C)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
                );
              },
            ),
            const Divider(height: 0),
            ListTile(
              leading: const Icon(Icons.logout, color: Color(0xFFDC143C)),
              title: const Text('Logout'),
              trailing: const Icon(Icons.chevron_right, color: Color(0xFFDC143C)),
              onTap: () {
                // Implement logout functionality
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            // Implement logout functionality
                            Navigator.of(context).popUntil(ModalRoute.withName('/')); // Navigate back to the first route
                          },
                          child: const Text('Logout', style: TextStyle(color: Colors.red)),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}