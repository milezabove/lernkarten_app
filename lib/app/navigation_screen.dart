import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:lernkarten_app/features/explore/presentation/explore_screen.dart';
import '../features/study_card_set/presentation/screens/study_card_set_list_screen.dart';
import '../features/info/presentation/info_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/settings/presentation/settings_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int currentIndex = 0;

  final screens = const [StudyCardSetListScreen(), ExploreScreen()];

  Future<void> _logout() async {
    // Drawer schließen
    Navigator.pop(context);

    // Benutzer abmelden
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lernkarten-App'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple.shade200,
      ),

      // ----------------------------------------------------------
      // DRAWER
      // ----------------------------------------------------------
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 179, 159, 218),
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Menü',
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
              ),
            ),

            // Profil
            ListTile(
              leading: const Icon(Icons.person_outlined),
              title: const Text('Profil'),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
            ),

            // Info
            ListTile(
              leading: const Icon(Icons.info_outlined),
              title: const Text('Info'),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const InfoScreen()),
                );
              },
            ),

            // Einstellungen
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Einstellungen'),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),

            const Divider(),

            // Abmelden
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Abmelden',
                style: TextStyle(color: Colors.red),
              ),
              onTap: _logout,
            ),
          ],
        ),
      ),

      // ----------------------------------------------------------
      // CURRENT SCREEN
      // ----------------------------------------------------------
      body: screens[currentIndex],

      // ----------------------------------------------------------
      // BOTTOM NAVIGATION
      // ----------------------------------------------------------
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_open_outlined),
            label: 'Meine Sets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            label: 'Entdecken',
          ),
        ],
      ),
    );
  }
}
