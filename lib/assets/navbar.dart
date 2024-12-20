import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const Navbar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home', // Landing page
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'Clothes', // Clothes list
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.face),
          label: 'Your Set',
        ),
      ],
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
    );
  }
}
