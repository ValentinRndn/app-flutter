import 'package:flutter/material.dart';
import 'package:chatbot_filrouge/class/token.dart';
import 'package:chatbot_filrouge/class/Personnage.class.dart';
import 'package:chatbot_filrouge/screen.personnageConversation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:convert';

class ScreenPersonnage extends StatefulWidget {
  final int universId;
  final int personnageId;

  const ScreenPersonnage({
    Key? key,
    required this.universId,
    required this.personnageId,
  }) : super(key: key);

  @override
  _ScreenPersonnageState createState() => _ScreenPersonnageState();
}

class _ScreenPersonnageState extends State<ScreenPersonnage> {
  final Personnage _personnage = Personnage();
  final Token _token = Token();

  void startConversation(String token) {
    debugPrint(token);

    // Split the token to get the payload part
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid token');
    }

    // Decode the base64Url part
    final payload = parts[1];
    var normalized = base64Url.normalize(payload);
    var decodedBytes = base64Url.decode(normalized);
    var decodedString = utf8.decode(decodedBytes);

    // Decode the JSON part
    final tokenDecoded = jsonDecode(decodedString);
    debugPrint(tokenDecoded['data'].toString());

    // Decode the 'data' field if it is a string
    final data = jsonDecode(tokenDecoded['data']);
    final id = data['id'];
    debugPrint('ID: $id');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScreenPersonnageConversation(
          characterId: widget.personnageId,
          universId: widget.universId,
          userId: id,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du personnage'),
      ),
      body: FutureBuilder<String?>(
        future: _token.getToken(),
        builder: (context, tokenSnapshot) {
          if (tokenSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (tokenSnapshot.hasError) {
            return Center(child: Text('Erreur : ${tokenSnapshot.error}'));
          } else if (!tokenSnapshot.hasData || tokenSnapshot.data == null) {
            return const Center(child: Text('Aucun token trouvé'));
          }

          final token = tokenSnapshot.data!;

          return FutureBuilder<Map<String, dynamic>>(
            future: _personnage.getSinglePersonnage(
                token, widget.universId, widget.personnageId),
            builder: (context, personnageSnapshot) {
              if (personnageSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (personnageSnapshot.hasError) {
                return Center(
                    child: Text('Erreur : ${personnageSnapshot.error}'));
              } else if (!personnageSnapshot.hasData ||
                  personnageSnapshot.data == null) {
                return const Center(child: Text('Aucune donnée trouvée'));
              }

              final personnage = personnageSnapshot.data!;
              final imageUrl = personnage['image'] == ''
                  ? 'https://via.placeholder.com/175'
                  : 'https://mds.sprw.dev/image_data/' + personnage['image'];

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: SizedBox(
                        width: 375,
                        height: 375,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(9),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => Image.network(
                              'https://via.placeholder.com/175',
                              width: 375,
                              height: 375,
                              fit: BoxFit.cover,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      personnage['name'],
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      personnage['description'],
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () => startConversation(token),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          primary: Colors.black, // Couleur de fond du bouton
                          onPrimary: Colors.white, // Couleur du texte du bouton
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: Text('Dialoguer avec ${personnage['name']}'),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
