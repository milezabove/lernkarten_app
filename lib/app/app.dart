import 'package:flutter/material.dart';
import 'package:lernkarten_app/app/navigation_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Lernkarten-App', home: NavigationScreen());
  }
}
