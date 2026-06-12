import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Einstellungen'), centerTitle: true),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.settings_outlined, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Einstellungen',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Das ist ein Platzhalter.\nEinstellungen werden hier bald verfügbar sein.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
