import 'package:flutter/material.dart';
import '../features/home/home_page.dart';
import '../features/profile/profile_page.dart';
import '../features/favorite_menu/favorites_page.dart';
import '../features/match_menu/match_page.dart';


class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final pages = const [
    HomePage(),
    MatchMenuPage(), // Match
    FavoritesPage(), // Fav
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Color.fromARGB(255, 96, 235, 115),
        unselectedItemColor: Colors.grey,

        onTap: (index) {
          setState(() => _currentIndex = index);
        },

        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.auto_awesome), label: "Match"),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: "Favorite"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
