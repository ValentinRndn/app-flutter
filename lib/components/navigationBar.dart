import 'package:flutter/material.dart';
import 'package:chatbot_filrouge/screen.home.dart';
import 'package:chatbot_filrouge/screen.messages.dart';
import 'package:chatbot_filrouge/screen.univers.dart';

class NavigationBarCustom extends StatefulWidget {
  const NavigationBarCustom({super.key});

  @override
  State<NavigationBarCustom> createState() => _NavigationBarCustomState();
}

class _NavigationBarCustomState extends State<NavigationBarCustom> {
  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ScreenHome()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ScreenUnivers()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ScreenMessages()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined, size: 30, color: Colors.black),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.public_outlined, size: 30, color: Colors.black),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message_outlined, size: 30, color: Colors.black),
          label: '',
        ),
      ],
      onTap: _onItemTapped,
    );
  }
}
