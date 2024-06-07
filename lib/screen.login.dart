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
  bool _isLoading = false;

  @override
  void dispose() {
    pseudoController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    var url = Uri.parse('https://mds.sprw.dev/auth');
    var body = {
      'username': pseudoController.text,
      'password': passwordController.text,
    };

    try {
      var response = await http.post(url, body: jsonEncode(body));
      if (response.statusCode == 200 || response.statusCode == 201) {
        var bodyResponseMap = jsonDecode(response.body);
        if (bodyResponseMap.containsKey('token')) {
          var token = bodyResponseMap['token'];
          var parts = token.split('.');
          var payload = parts[1];
          var payloadMap = jsonDecode(utf8.decode(
              base64.decode(base64.normalize(payload))));
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('jwt_token', token);
          print('Token saved in shared preferences');
          print('Extracted JWT payload: $payloadMap');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ScreenHome()),
          );
        } else {
          _showErrorSnackbar('Erreur: JWT token non trouvé dans la réponse');
        }
      } else {
        _showErrorSnackbar(
            'Erreur de connexion: ${response.statusCode.toString()}');
      }
    } catch (e) {
      _showErrorSnackbar('Erreur de connexion: $e');
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
          'Connexion',
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
              SizedBox(height: 80),
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
              SizedBox(height: 20),
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
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
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
                        'Se connecter',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
              ),
              SizedBox(height: 20),
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
