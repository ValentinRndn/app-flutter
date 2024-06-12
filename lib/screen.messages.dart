import 'package:chatbot_filrouge/components/navigationBar.dart';
import 'package:flutter/material.dart';
import 'package:chatbot_filrouge/class/Conversation.class.dart';
import 'package:chatbot_filrouge/class/token.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatbot_filrouge/screen.personnageConversation.dart';

class ScreenMessages extends StatefulWidget {
  const ScreenMessages({super.key});

  @override
  State<ScreenMessages> createState() => _ScreenMessagesState();
}

class _ScreenMessagesState extends State<ScreenMessages> {
  final Conversation _conversation = Conversation();
  final Token _token = Token();

  Future<void> _navigateToConversation(
      BuildContext context, int characterId, int universId, int userId) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScreenPersonnageConversation(
          characterId: characterId,
          universId: universId,
          userId: userId,
        ),
      ),
    ).then((_) {
      // Refresh the page after returning from conversation screen
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Conversations',
          style: TextStyle(
            fontSize: 30,
            color: Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<String?>(
        future: _token.getToken(),
        builder: (context, tokenSnapshot) {
          if (tokenSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (tokenSnapshot.hasError) {
            return Center(child: Text('Error: ${tokenSnapshot.error}'));
          } else if (!tokenSnapshot.hasData || tokenSnapshot.data == null) {
            return const Center(child: Text('No token found'));
          }

          final token = tokenSnapshot.data!;

          return FutureBuilder<List<Map<String, dynamic>>>(
            future: _conversation.getAllConversationsWithDetails(token),
            builder: (context, conversationSnapshot) {
              if (conversationSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (conversationSnapshot.hasError) {
                return Center(
                    child: Text('Error: ${conversationSnapshot.error}'));
              } else if (!conversationSnapshot.hasData ||
                  conversationSnapshot.data!.isEmpty) {
                return const Center(child: Text('No conversations found'));
              }

              final conversations = conversationSnapshot.data!;

              return ListView.builder(
                itemCount: conversations.length,
                itemBuilder: (context, index) {
                  final conversation = conversations[index];
                  final characterName =
                      conversation['character_name'] ?? 'Nom personnage';
                  final universeName =
                      conversation['universe_name'] ?? 'Nom univers';
                  final characterImage = conversation['character_image'] ??
                      'https://via.placeholder.com/75';
                  final characterId = conversation['character_id'] ?? 0;
                  final universId = conversation['universe_id'] ?? 0;
                  final userId = conversation['user_id'] ?? 0;

                  return GestureDetector(
                    onTap: () {
                      _navigateToConversation(
                          context, characterId, universId, userId);
                    },
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 75,
                                height: 75,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(9),
                                  child: CachedNetworkImage(
                                    imageUrl: characterImage,
                                    placeholder: (context, url) => const Center(
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        Image.network(
                                      'https://via.placeholder.com/75',
                                      width: 75,
                                      height: 75,
                                      fit: BoxFit.cover,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      characterName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      universeName,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: const NavigationBarCustom(),
    );
  }
}
