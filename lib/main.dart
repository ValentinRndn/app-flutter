import 'package:flutter/material.dart';
import 'package:chatbot_filrouge/screen.login.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatbot Fil Rouge',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const ScreenLogin(),
    );
  }
}
