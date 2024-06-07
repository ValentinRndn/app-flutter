import 'dart:typed_data';
import 'package:chatbot_filrouge/class/Univers.dart';
import 'package:chatbot_filrouge/class/Token.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ImageFetcher {
  Future<Uint8List?> fetchImage(String url, String token) async {
    final response = await http
        .get(Uri.parse(url), headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      debugPrint('Failed to load image: ${response.statusCode}');
      return null;
    }
  }
}

class ScreenUniversDescription extends StatefulWidget {
  final String universId;

  const ScreenUniversDescription({super.key, required this.universId});

  @override
  State<ScreenUniversDescription> createState() =>
      _ScreenUniversDescriptionState();
}

class _ScreenUniversDescriptionState extends State<ScreenUniversDescription> {
  final Univers _univers = Univers();
  final Token _token = Token();
  final ImageFetcher _imageFetcher = ImageFetcher();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          final int universId = int.tryParse(widget.universId) ?? 0;

          return FutureBuilder<Map<String, dynamic>>(
            future: _univers.getSingleUnivers(token, universId),
            builder: (context, universSnapshot) {
              if (universSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (universSnapshot.hasError) {
                return Center(child: Text('Error: ${universSnapshot.error}'));
              } else if (!universSnapshot.hasData ||
                  universSnapshot.data == null) {
                return const Center(child: Text('No data found'));
              }

              final univers = universSnapshot.data!;
              final imageUrl = univers['image'] == ''
                  ? 'https://via.placeholder.com/175'
                  : 'https://mds.sprw.dev/image_data/' + univers['image'];

              return Scaffold(
                appBar: AppBar(
                  title: Text(univers['name']),
                ),
                body: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                          child: Column(
                        children: [
                          imageUrl != 'https://via.placeholder.com/175'
                              ? FutureBuilder<Uint8List?>(
                                  future:
                                      _imageFetcher.fetchImage(imageUrl, token),
                                  builder: (context, imageSnapshot) {
                                    if (imageSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    } else if (imageSnapshot.hasError) {
                                      return Center(
                                          child: Text(
                                              'Error loading image: ${imageSnapshot.error}'));
                                    } else if (!imageSnapshot.hasData ||
                                        imageSnapshot.data == null) {
                                      return const Center(
                                          child: Text('No image found'));
                                    }

                                    return Image.memory(imageSnapshot.data!);
                                  },
                                )
                              : Image.network(imageUrl),
                          const SizedBox(height: 10),
                          Text(univers['name'],
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                        ],
                      )),
                      const SizedBox(height: 10),
                      Text(univers['description'],
                          style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
