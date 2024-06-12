import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:chatbot_filrouge/class/Univers.dart';
import 'package:chatbot_filrouge/class/Conversation.class.dart';
import 'package:chatbot_filrouge/components/navigationBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatbot_filrouge/screen.univers.description.dart';
import 'package:chatbot_filrouge/screen.personnageConversation.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  Future<String?> _getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('jwt_token');
    return token;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Accueil",
          style: TextStyle(
            fontSize: 30,
            color: Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<String?>(
        future: _getToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erreur de chargement du token'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Token non disponible'));
          } else {
            final String token = snapshot.data!;
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "Dernières conversations",
                    style: TextStyle(
                      fontSize: 23,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future:
                        Conversation().getAllConversationsWithDetails(token),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(
                            child:
                                Text('Erreur de chargement des conversations'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text('Aucune conversation disponible'));
                      } else {
                        final conversations = snapshot.data!;
                        return SizedBox(
                          height:
                              140, // Ajustez cette valeur en fonction de vos besoins
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: conversations.length,
                            itemBuilder: (context, index) {
                              final conversation = conversations[index];
                              final characterName =
                                  conversation['character_name'] ??
                                      'Nom personnage';
                              final universeName =
                                  conversation['universe_name'] ??
                                      'Nom univers';
                              final characterImage =
                                  conversation['character_image'] ??
                                      'https://via.placeholder.com/100';
                              final characterId =
                                  conversation['character_id'] ?? 0;
                              final universId =
                                  conversation['universe_id'] ?? 0;
                              final userId = conversation['user_id'] ?? 0;

                              return GestureDetector(
                                onTap: () {
                                  debugPrint(
                                      'conversation[id]: ${conversation['id']}');
                                  debugPrint(conversations.toString());
                                  if (characterId != 0 &&
                                      universId != 0 &&
                                      userId != 0) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ScreenPersonnageConversation(
                                          characterId: characterId,
                                          universId: universId,
                                          userId: userId,
                                        ),
                                      ),
                                    );
                                  } else {
                                    // Gérer le cas où l'un des IDs est nul
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Données de conversation manquantes')),
                                    );
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 238, 238, 238),
                                          borderRadius:
                                              BorderRadius.circular(9),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(9),
                                          child: CachedNetworkImage(
                                            imageUrl: characterImage,
                                            placeholder: (context, url) =>
                                                const Center(
                                                    child:
                                                        CircularProgressIndicator()),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Image.network(
                                              'https://via.placeholder.com/100',
                                              fit: BoxFit.cover,
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Text(characterName),
                                      Text(
                                        universeName,
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Univers",
                    style: TextStyle(
                      fontSize: 23,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder<List<dynamic>>(
                      future: Univers().getAllUnivers(token),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return const Center(
                              child: Text('Erreur de chargement des univers'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text('Aucun univers disponible'));
                        } else {
                          final data = snapshot.data!;
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              final universId =
                                  data[index]['id']?.toString() ?? '0';
                              final imageUrl = (data[index]['image'] == ''
                                      ? 'https://via.placeholder.com/175'
                                      : 'https://mds.sprw.dev/image_data/' +
                                          data[index]['image']) ??
                                  'https://via.placeholder.com/175';
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ScreenUniversDescription(
                                        universId: universId,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 225,
                                        height: 225,
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 238, 238, 238),
                                          borderRadius:
                                              BorderRadius.circular(9),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(9),
                                          child: CachedNetworkImage(
                                            imageUrl: imageUrl,
                                            placeholder: (context, url) =>
                                                const Center(
                                                    child:
                                                        CircularProgressIndicator()),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Image.network(
                                              'https://via.placeholder.com/175',
                                              fit: BoxFit.cover,
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                          data[index]['name'] ?? 'Nom univers'),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
      bottomNavigationBar: const NavigationBarCustom(),
    );
  }
}
