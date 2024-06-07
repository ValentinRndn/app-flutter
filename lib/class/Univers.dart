import 'dart:convert';
import 'package:http/http.dart' as http;

class Univers {
  Future<void> createUnivers(String token, String name) async {
    var url = Uri.parse('https://mds.sprw.dev/universes');
    var response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'name': name}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create univers');
    }
  }

  Future<Map<String, dynamic>> getSingleUnivers(String? token, int id) async {
    var url = Uri.parse('https://mds.sprw.dev/universes/$id');
    var response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load data univers');
    }
  }

  Future<List<dynamic>> getAllUnivers(String? token) async {
    var url = Uri.parse('https://mds.sprw.dev/universes/');
    var response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to load data univers');
    }
  }

  Future<void> deleteUnivers(String token, int id) async {
    var url = Uri.parse('https://mds.sprw.dev/universes/$id');
    var response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete univers');
    }
  }

  Future<void> updateUnivers(String token, int id, String name) async {
    var url = Uri.parse('https://mds.sprw.dev/universes/$id');
    var response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'name': name}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update univers');
    }
  }
}
