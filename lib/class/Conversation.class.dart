import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:chatbot_filrouge/class/Univers.dart'; // Importer la classe Univers

class Conversation {
  Future<void> createConversation(
      String token, int characterId, int userId) async {
    var url = Uri.parse('https://mds.sprw.dev/conversations/');
    var response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'character_id': characterId, 'user_id': userId}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create conversation');
    }
  }

  Future<List<dynamic>> getAllConversation(String token) async {
    var url = Uri.parse('https://mds.sprw.dev/conversations/');
    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to get conversations');
    }

    List<dynamic> conversations = jsonDecode(response.body);
    return conversations;
  }

  Future<Map<String, dynamic>> getCharacter(
      String token, int characterId) async {
    var url = Uri.parse('https://mds.sprw.dev/characters/$characterId');
    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to get character');
    }

    return jsonDecode(response.body);
  }

  Future<void> deleteConversation(String token, int conversationId) async {
    var url = Uri.parse('https://mds.sprw.dev/conversations/$conversationId');
    var response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete conversation');
    }
  }

  Future<Map<String, dynamic>> getUniverse(String token, int universeId) async {
    var univers = Univers();
    return await univers.getSingleUnivers(token, universeId);
  }

  Future<List<Map<String, dynamic>>> getAllConversationsWithDetails(
      String token) async {
    List<dynamic> conversations = await getAllConversation(token);

    List<Map<String, dynamic>> enrichedConversations = [];
    for (var conversation in conversations) {
      var characterDetails =
          await getCharacter(token, conversation['character_id']);
      var universeDetails =
          await getUniverse(token, characterDetails['universe_id']);
      enrichedConversations.add({
        'id': conversation['id'],
        'character_id': conversation['character_id'], // Ajout de character_id
        'universe_id': characterDetails['universe_id'], // Ajout de universe_id
        'user_id': conversation['user_id'], // Ajout de user_id
        'character_name': characterDetails['name'],
        'universe_name': universeDetails['name'],
        'character_image': 'https://mds.sprw.dev/image_data/' +
            (characterDetails['image'] ?? 'placeholder.png'),
      });
    }

    return enrichedConversations;
  }
}
