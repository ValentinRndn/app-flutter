import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'screen.register.dart';
import 'screen.home.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({Key? key}) : super(key: key);

  @override
  _ScreenLoginState createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  final TextEditingController _pseudoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _pseudoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      var url = Uri.parse('https://mds.sprw.dev/auth');
      var body = {
        'username': _pseudoController.text,
        'password': _passwordController.text,
      };
      var response = await http.post(url, body: jsonEncode(body));
      if (response.statusCode == 200 || response.statusCode == 201) {
        var bodyResponseMap = jsonDecode(response.body);
        if (bodyResponseMap.containsKey('token')) {
          var token = bodyResponseMap['token'];
          var parts = token.split('.');
          var payload = parts[1];
          var payloadMap = jsonDecode(utf8.decode(base64.decode(base64.normalize(payload))));
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('jwt_token', token);
          print('Token saved in shared preferences');
          print('Extracted JWT payload: $payloadMap');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ScreenHome()),
          );
        } else {
          print('Error: JWT token not found in response');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur de connexion: ${response.statusCode}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Connexion',
          style: TextStyle(
            fontSize: 30,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _pseudoController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Pseudo',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre pseudo';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Mot de passe',
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre mot de passe';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Se connecter',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ScreenRegister()),
                    );
                  },
                  child: const Text(
                    "S'enregistrer",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
