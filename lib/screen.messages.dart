import 'package:flutter/material.dart';
import 'package:chatbot_filrouge/components/navigationBar.dart';

class ScreenMessages extends StatefulWidget {
  const ScreenMessages({super.key});

  @override
  State<ScreenMessages> createState() => _ScreenMessagesState();
}

class _ScreenMessagesState extends State<ScreenMessages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Univers",
          style: TextStyle(
            fontSize: 30,
            color: Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Text("Welcome to Screen Messages!"),
      bottomNavigationBar: const NavigationBarCustom(),
    );
  }
}
