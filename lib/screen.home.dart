import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:chatbot_filrouge/class/Univers.dart';
import 'package:chatbot_filrouge/class/Conversation.class.dart';
import 'package:chatbot_filrouge/components/navigationBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatbot_filrouge/screen.univers.description.dart';
import 'package:chatbot_filrouge/screen.personnageConversation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<String?> _getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Accueil",
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
        future: _getToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Erreur de chargement du token ou token non disponible'));
          } else {
            final String token = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Dernières conversations",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildConversations(token),
                  const SizedBox(height: 30),
                  const Text(
                    "Univers",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildUniverses(token),
                ],
              ),
            );
          }
        },
      ),
      bottomNavigationBar: const NavigationBarCustom(),
    );
  }

  Widget _buildConversations(String token) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: Conversation().getAllConversationsWithDetails(token),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Erreur de chargement des conversations'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Aucune conversation disponible'));
        } else {
          final conversations = snapshot.data!;
          return SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                final conversation = conversations[index];
                final characterName = conversation['character_name'] ?? 'Nom personnage';
                final universeName = conversation['universe_name'] ?? 'Nom univers';
                final characterImage = conversation['character_image'] ?? 'https://via.placeholder.com/100';
                final characterId = conversation['character_id'] ?? 0;
                final universId = conversation['universe_id'] ?? 0;
                final userId = conversation['user_id'] ?? 0;

                return GestureDetector(
                  onTap: () {
                    if (characterId != 0 && universId != 0 && userId != 0) {
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
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Données de conversation manquantes')),
                      );
                    }
                  },
                  child: Container(
                    width: 120,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: characterImage,
                            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => Image.network(
                              'https://via.placeholder.com/100',
                              fit: BoxFit.cover,
                              width: 120,
                              height: 90,
                            ),
                            fit: BoxFit.cover,
                            width: 120,
                            height: 90,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                characterName,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                universeName,
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
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
    );
  }

  Widget _buildUniverses(String token) {
    return Expanded(
      child: FutureBuilder<List<dynamic>>(
        future: Univers().getAllUnivers(token),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erreur de chargement des univers'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun univers disponible'));
          } else {
            final universes = snapshot.data!;
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: universes.length,
              itemBuilder: (context, index) {
                final univers = universes[index];
                final universId = univers['id']?.toString() ?? '0';
                final imageUrl = (univers['image'] == ''
                    ? 'https://via.placeholder.com/175'
                    : 'https://mds.sprw.dev/image_data/' + univers['image']) ??
                    'https://via.placeholder.com/175';

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScreenUniversDescription(universId: universId),
                      ),
                    );
                  },
                  child: Container(
                    width: 150,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => Image.network(
                              'https://via.placeholder.com/175',
                              fit: BoxFit.cover,
                              width: 150,
                              height: 100,
                            ),
                            fit: BoxFit.cover,
                            width: 150,
                            height: 100,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            univers['name'] ?? 'Nom univers',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
