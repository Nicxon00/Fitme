import 'package:flutter/material.dart';
import 'ClothesList_page.dart';
import 'landing_page.dart'; // Import your updated LandingPage
import 'your_set_page.dart'; // Import YourSetPage
import 'package:fitme_main/assets/navbar.dart'; // Import the navbar

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();

    _pages.addAll([
      LandingPage(onNavigate: _onTap), // Pass the callback to LandingPage
      ClothesListScreen(),
      const YourSetPage(),
    ]);
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Navbar(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}
