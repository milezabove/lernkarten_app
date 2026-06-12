import 'package:flutter/material.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Entdecken'), centerTitle: true),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.explore_outlined, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Entdecken',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Das ist ein Platzhalter.\nEntdecken wird hier bald verfügbar sein.',
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
