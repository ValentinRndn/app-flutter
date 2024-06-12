// lib/class/Personnage.class.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class Personnage {
  Future<void> createPersonnage(
      String token, String name, int idUnivers) async {
    var url = Uri.parse('https://mds.sprw.dev/universes/$idUnivers/characters');
    var response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'name': name}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create personnage');
    }
  }

  Future<List<dynamic>> getAllPersonnage(String token, int idUnivers) async {
    var url = Uri.parse('https://mds.sprw.dev/universes/$idUnivers/characters');
    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to load personnages');
    }
  }

  //get single personnage

  Future<Map<String, dynamic>> getSinglePersonnage(
      String token, int idUnivers, int idPersonnage) async {
    var url = Uri.parse(
        'https://mds.sprw.dev/universes/$idUnivers/characters/$idPersonnage');
    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load personnage');
    }
  }
}
