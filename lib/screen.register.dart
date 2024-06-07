import 'dart:convert';

import 'package:chatbot_filrouge/screen.login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ScreenRegister extends StatefulWidget {
  const ScreenRegister({super.key});

  @override
  State<ScreenRegister> createState() => _ScreenRegisterState();
}

class _ScreenRegisterState extends State<ScreenRegister> {
  TextEditingController pseudoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nomController = TextEditingController();
  TextEditingController prenomController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    pseudoController.dispose();
    emailController.dispose();
    nomController.dispose();
    prenomController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
    });

    if (passwordController.text != confirmPasswordController.text) {
      _showErrorSnackbar("Les mots de passe ne correspondent pas");
      setState(() {
        _isLoading = false;
      });
      return;
    }

    var url = Uri.parse('https://mds.sprw.dev/users');

    var body = {
      'username': pseudoController.text,
      'email': emailController.text,
      'lastname': nomController.text,
      'firstname': prenomController.text,
      'password': passwordController.text,
    };

    try {
      var response = await http.post(url, body: json.encode(body));

      if (response.statusCode == 201 || response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ScreenLogin()),
        );
      } else {
        _showErrorSnackbar("Erreur: ${response.statusCode}");
      }
    } catch (e) {
      _showErrorSnackbar("Erreur de connexion: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "S'enregistrer",
          style: TextStyle(
            fontSize: 28,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              TextField(
                controller: pseudoController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  hintText: 'Pseudo',
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  hintText: 'Email',
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nomController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  hintText: 'Nom',
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: prenomController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  hintText: 'Prénom',
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  hintText: 'Mot de passe',
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  hintText: 'Confirmation mot de passe',
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _isLoading ? null : _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "S'enregistrer",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ScreenLogin()),
                  );
                },
                child: const Text(
                  "Déjà un compte ? Se connecter",
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
