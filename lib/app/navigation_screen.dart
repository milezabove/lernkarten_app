import 'package:flutter/material.dart';
import 'package:lernkarten_app/features/explore/presentation/explore_screen.dart';
import '../features/study_card/presentation/study_card_set_list_screen.dart';
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

  final screens = const [
    StudyCardSetListScreen(),
    InfoScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lernkarten-App'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple.shade200,
      ),
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
            ListTile(
              leading: const Icon(Icons.explore_outlined),
              title: const Text('Entdecken'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ExploreScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.build_outlined),
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
          ],
        ),
      ),
      body: screens[currentIndex],
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
            icon: Icon(Icons.info_outlined),
            label: 'Info',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
