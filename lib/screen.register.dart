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
            fontSize: 30,
            color: Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  TextField(
                    controller: pseudoController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Pseudo',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Email',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: nomController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Nom',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: prenomController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Prénom',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Mot de passe',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: confirmPasswordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Confirmation mot de passe',
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        var url = Uri.parse('https://mds.sprw.dev/users');

                        var body = {
                          'username': pseudoController.text,
                          'email': emailController.text,
                          'lastname': nomController.text,
                          'firstname': prenomController.text,
                          'password': passwordController.text,
                        };

                        var response =
                            await http.post(url, body: json.encode(body));

                        if (response.statusCode == 201 ||
                            response.statusCode == 200) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ScreenLogin()),
                          );
                        } else {
                          print("Error: ${response.statusCode}");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8), // Moins arrondi
                        ),
                      ),
                      child: const Text(
                        "S'enregistrer",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
