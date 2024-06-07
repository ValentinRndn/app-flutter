import 'package:chatbot_filrouge/screen.home.dart';
import 'package:chatbot_filrouge/screen.messages.dart';
import 'package:chatbot_filrouge/screen.univers.dart';
import 'package:flutter/material.dart';

class NavigationBarCustom extends StatefulWidget {
  const NavigationBarCustom({super.key});

  @override
  State<NavigationBarCustom> createState() => _NavigationBarCustomState();
}

class _NavigationBarCustomState extends State<NavigationBarCustom> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const ScreenHome()));
        break;
      case 1:
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const ScreenUnivers()));
        break;
      case 2:
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const ScreenMessages()));
        break;
    }
  }

  Color _getItemColor(int index) {
    return _selectedIndex == index ? Colors.black : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home, color: _getItemColor(0)),
          label: 'Accueil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.public, color: _getItemColor(1)),
          label: 'Univers',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message, color: _getItemColor(2)),
          label: 'Messages',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.black,
      onTap: _onItemTapped,
    );
  }
}
