import 'dart:convert';
import 'package:chatbot_filrouge/screen.login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController pseudoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

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

  void updatePasswordMatch() {
    if (passwordController.text != confirmPasswordController.text) {
      print("Passwords do not match");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "S'enregistrer",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildTextField(pseudoController, 'Pseudo'),
              const SizedBox(height: 20),
              _buildTextField(emailController, 'Email'),
              const SizedBox(height: 20),
              _buildTextField(nomController, 'Nom'),
              const SizedBox(height: 20),
              _buildTextField(prenomController, 'Prénom'),
              const SizedBox(height: 20),
              _buildTextField(passwordController, 'Mot de passe', obscureText: true),
              const SizedBox(height: 20),
              _buildTextField(confirmPasswordController, 'Confirmation mot de passe', obscureText: true),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "S'enregistrer",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, {bool obscureText = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
      ),
      obscureText: obscureText,
    );
  }

  Future<void> _register() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Les mots de passe ne correspondent pas')),
      );
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

    var response = await http.post(url, body: json.encode(body), headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 201 || response.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${response.statusCode}')),
      );
    }
  }
}
