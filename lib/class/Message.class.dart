// lib/class/Message.class.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class Message {
  Future<List<dynamic>> getAllMessage(String token, int conversationId) async {
    var url = Uri.parse(
        'https://mds.sprw.dev/conversations/$conversationId/messages');
    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to get messages');
    }

    List<dynamic> messages = jsonDecode(response.body);
    return messages;
  }

  Future<Map<String, dynamic>> createMessage(
      String token, int conversationId, String content) async {
    var url = Uri.parse(
        'https://mds.sprw.dev/conversations/$conversationId/messages');
    var response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'content': content}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create message');
    }

    return jsonDecode(response.body);
  }
}
