import 'package:chatbot_filrouge/screen.home.dart';
import 'package:chatbot_filrouge/screen.register.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({Key? key}) : super(key: key);

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  TextEditingController pseudoController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void dispose() {
    pseudoController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Connexion',
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
                  SizedBox(height: 80),
                  TextField(
                    controller: pseudoController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Pseudo',
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Mot de passe',
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ScreenRegister()),
                    );
                  },
                  child: const Text(
                    "S'enregistrer",
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        var url = Uri.parse('https://mds.sprw.dev/auth');

                        var body = {
                          'username': pseudoController.text,
                          'password': passwordController.text,
                        };
                        var response =
                            await http.post(url, body: jsonEncode(body));
                        if (response.statusCode == 200 ||
                            response.statusCode == 201) {
                          var bodyResponseMap = jsonDecode(response.body);
                          if (bodyResponseMap.containsKey('token')) {
                            var token = bodyResponseMap['token'];
                            var parts = token.split('.');
                            var payload = parts[1];
                            var payloadMap = jsonDecode(utf8.decode(
                                base64.decode(base64.normalize(payload))));
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setString('jwt_token', token);
                            print('Token saved in shared preferences');
                            print('Extracted JWT payload: $payloadMap');
                          } else {
                            print('Error: JWT token not found in response');
                          }
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ScreenHome()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Erreur de connexion ' +
                                  response.statusCode.toString()),
                            ),
                          );
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
                        'Se connecter',
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
