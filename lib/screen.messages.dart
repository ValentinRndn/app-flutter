import 'package:flutter/material.dart';
import 'package:chatbot_filrouge/class/Conversation.class.dart';
import 'package:chatbot_filrouge/class/token.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatbot_filrouge/screen.personnageConversation.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final Conversation _conversation = Conversation();
  final Token _token = Token();

  void _navigateToConversation(
      BuildContext context, int characterId, int universId, int userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScreenPersonnageConversation(
          characterId: characterId,
          universId: universId,
          userId: userId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Conversations',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: FutureBuilder<String?>(
        future: _token.getToken(),
        builder: (context, tokenSnapshot) {
          if (tokenSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (tokenSnapshot.hasError) {
            return Center(child: Text('Erreur: ${tokenSnapshot.error}'));
          } else if (!tokenSnapshot.hasData || tokenSnapshot.data == null) {
            return const Center(child: Text('Aucun token trouvé'));
          }

          final token = tokenSnapshot.data!;

          return FutureBuilder<List<Map<String, dynamic>>>(
            future: _conversation.getAllConversationsWithDetails(token),
            builder: (context, conversationSnapshot) {
              if (conversationSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (conversationSnapshot.hasError) {
                return Center(child: Text('Erreur: ${conversationSnapshot.error}'));
              } else if (!conversationSnapshot.hasData || conversationSnapshot.data!.isEmpty) {
                return const Center(child: Text('Aucune conversation trouvée'));
              }

              final conversations = conversationSnapshot.data!;

              return ListView.builder(
                itemCount: conversations.length,
                itemBuilder: (context, index) {
                  final conversation = conversations[index];
                  final characterName = conversation['character_name'] ?? 'Nom personnage';
                  final universeName = conversation['universe_name'] ?? 'Nom univers';
                  final characterImage = conversation['character_image'] ?? 'https://via.placeholder.com/75';
                  final characterId = conversation['character_id'] ?? 0;
                  final universId = conversation['universe_id'] ?? 0;
                  final userId = conversation['user_id'] ?? 0;

                  return GestureDetector(
                    onTap: () {
                      _navigateToConversation(context, characterId, universId, userId);
                    },
                    child: Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: characterImage,
                                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) => Image.network(
                                  'https://via.placeholder.com/75',
                                  width: 75,
                                  height: 75,
                                  fit: BoxFit.cover,
                                ),
                                width: 75,
                                height: 75,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    characterName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    universeName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
