import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Info'), centerTitle: true),
      body: const Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Über die App',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Die Lernkarten-App ist zum Erstellen, Verwalten, Teilen und Lernen digitaler Karteikarten.',
              style: TextStyle(fontSize: 16, height: 1.6),
            ),
            SizedBox(height: 24),
            Text(
              'Funktionen',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.style, size: 20),
                SizedBox(width: 12),
                Text('Lernkarten erstellen und verwalten'),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.quiz, size: 20),
                SizedBox(width: 12),
                Text('Wissen im Quizmodus testen'),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.share, size: 20),
                SizedBox(width: 12),
                Text('Lernsets mit anderen teilen'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
