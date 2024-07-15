import 'package:flutter/material.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

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
        title: const Text('LANGUAGE', style: TextStyle(color: Color(0xFFDC143C))),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        children: const [
          LanguageCard(language: 'English', isSelected: true),
          LanguageCard(language: 'Spanish', isSelected: false),
          LanguageCard(language: 'French', isSelected: false),
          LanguageCard(language: 'German', isSelected: false),
          LanguageCard(language: 'Chinese', isSelected: false),
        ],
      ),
    );
  }
}

class LanguageCard extends StatelessWidget {
  final String language;
  final bool isSelected;

  const LanguageCard({super.key,
    required this.language,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: ListTile(
        title: Text(language),
        trailing: isSelected
            ? const Icon(Icons.check, color: Color(0xFFDC143C))
            : null,
        onTap: () {
          // Handle selection logic here if needed
        },
      ),
    );
  }
}
