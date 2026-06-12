import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            CircleAvatar(
              radius: 48,
              backgroundColor: Colors.deepPurple.shade100,
              child: Icon(
                Icons.person,
                size: 48,
                color: Colors.deepPurple.shade400,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Luca Maurer',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'luca.maurer@gmail.com',
              style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.school, size: 22, color: Colors.grey),
                const SizedBox(width: 16),
                const Text('Berner Fachhochschule'),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 22, color: Colors.grey),
                const SizedBox(width: 16),
                const Text('Mitglied seit 2026'),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.style_outlined, size: 22, color: Colors.grey),
                const SizedBox(width: 16),
                const Text('3 Lernkartensets erstellt'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
