import 'package:flutter/material.dart';
import 'package:chatbot_filrouge/components/navigationBar.dart';
import 'package:chatbot_filrouge/class/Conversation.class.dart';
import 'package:chatbot_filrouge/class/token.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatbot_filrouge/screen.personnageConversation.dart';

<<<<<<< HEAD
class ScreenMessages extends StatefulWidget {
  const ScreenMessages({super.key});
=======
class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);
>>>>>>> ab933b48f9d70df647ae2a25fb11f1d0a25deb9f

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
          'Messages',
          style: TextStyle(
<<<<<<< HEAD
            fontSize: 30,
            color: Color.fromARGB(255, 0, 0, 0),
=======
            fontSize: 24,
>>>>>>> ab933b48f9d70df647ae2a25fb11f1d0a25deb9f
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
<<<<<<< HEAD
                return Center(
                    child: Text('Error: ${conversationSnapshot.error}'));
              } else if (!conversationSnapshot.hasData ||
                  conversationSnapshot.data!.isEmpty) {
=======
                return Center(child: Text('Error: ${conversationSnapshot.error}'));
              } else if (!conversationSnapshot.hasData || conversationSnapshot.data!.isEmpty) {
>>>>>>> ab933b48f9d70df647ae2a25fb11f1d0a25deb9f
                return const Center(child: Text('No conversations found'));
              }

              final conversations = conversationSnapshot.data!;

              return ListView.builder(
                itemCount: conversations.length,
                itemBuilder: (context, index) {
                  final conversation = conversations[index];
<<<<<<< HEAD
                  final characterName =
                      conversation['character_name'] ?? 'Nom personnage';
                  final universeName =
                      conversation['universe_name'] ?? 'Nom univers';
                  final characterImage = conversation['character_image'] ??
                      'https://via.placeholder.com/75';
=======
                  final characterName = conversation['character_name'] ?? 'Character Name';
                  final universeName = conversation['universe_name'] ?? 'Universe Name';
                  final characterImage = conversation['character_image'] ?? 'https://via.placeholder.com/75';
>>>>>>> ab933b48f9d70df647ae2a25fb11f1d0a25deb9f
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
<<<<<<< HEAD
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
=======
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
>>>>>>> ab933b48f9d70df647ae2a25fb11f1d0a25deb9f
                                    ),
                                    fit: BoxFit.cover,
                                  ),
<<<<<<< HEAD
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
=======
                                  const SizedBox(height: 5),
                                  Text(
                                    universeName,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
>>>>>>> ab933b48f9d70df647ae2a25fb11f1d0a25deb9f
                              ),
                            ],
                          ),
                        ),
<<<<<<< HEAD
                        const Divider(
                          color: Colors.grey,
                        ),
                      ],
=======
                      ),
>>>>>>> ab933b48f9d70df647ae2a25fb11f1d0a25deb9f
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
 