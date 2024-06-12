import 'package:flutter/material.dart';
import 'package:chatbot_filrouge/components/navigationBar.dart';
import 'package:chatbot_filrouge/class/token.dart';
import 'package:chatbot_filrouge/class/univers.dart';
import 'package:chatbot_filrouge/screen.univers.description.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class ScreenUnivers extends StatefulWidget {
  const ScreenUnivers({super.key});

  @override
  State<ScreenUnivers> createState() => _ScreenUniversState();
}

class _ScreenUniversState extends State<ScreenUnivers> {
  final Token _tokenClass = Token();
  final TextEditingController _nameController = TextEditingController();

  Future<Uint8List?> _fetchImage(String url, String token) async {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image');
    }
  }

  void _showModal(BuildContext context, String token) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ajout d\'un univers'),
          content: TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: 'Nom de l\'univers',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fermer'),
            ),
            TextButton(
              onPressed: () async {
                await Univers().createUnivers(token, _nameController.text);
                Navigator.pop(context);
                setState(() {});
              },
              child: const Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteUnivers(String token, int id) async {
    var url = Uri.parse('https://mds.sprw.dev/universes/$id');
    var response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete univers');
    } else {
      setState(() {});
    }
  }

  void _showEditModal(
      BuildContext context, String token, int id, String currentName) {
    _nameController.text = currentName;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modifier l\'univers'),
          content: TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: 'Nom de l\'univers',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fermer'),
            ),
            TextButton(
              onPressed: () async {
                await Univers().updateUnivers(token, id, _nameController.text);
                Navigator.pop(context);
                setState(() {});
              },
              child: const Text('Mettre à jour'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Univers",
          style: TextStyle(
            fontSize: 30,
            color: Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          FutureBuilder<String?>(
            future: _tokenClass.getToken(),
            builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return const Icon(Icons.error);
              } else if (!snapshot.hasData || snapshot.data == null) {
                return const Icon(Icons.error);
              } else {
                return IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _showModal(context, snapshot.data!),
                );
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<String?>(
        future: _tokenClass.getToken(),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No token found'));
          } else {
            final String token = snapshot.data!;
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
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
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              final univers = data[index];
                              final imageUrl = univers['image'] == ''
                                  ? 'https://via.placeholder.com/75'
                                  : 'https://mds.sprw.dev/image_data/' +
                                      univers['image'];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ScreenUniversDescription(
                                        universId: univers['id'].toString(),
                                      ),
                                    ),
                                  );
                                },
                                child: Dismissible(
                                  key: Key(univers['id'].toString()),
                                  direction: DismissDirection.horizontal,
                                  background: Container(
                                    color: Colors.blue,
                                    child: const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 20.0),
                                        child: Icon(Icons.edit,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  secondaryBackground: Container(
                                    color: Colors.red,
                                    child: const Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 20.0),
                                        child: Icon(Icons.delete,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  confirmDismiss: (direction) async {
                                    if (direction ==
                                        DismissDirection.startToEnd) {
                                      _showEditModal(context, token,
                                          univers['id'], univers['name']);
                                      return false;
                                    } else if (direction ==
                                        DismissDirection.endToStart) {
                                      await _deleteUnivers(
                                          token, univers['id']);
                                      return true;
                                    }
                                    return false;
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 75,
                                          height: 75,
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 238, 238, 238),
                                            borderRadius:
                                                BorderRadius.circular(9),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(9),
                                            child: FutureBuilder<Uint8List?>(
                                              future:
                                                  _fetchImage(imageUrl, token),
                                              builder:
                                                  (context, imageSnapshot) {
                                                if (imageSnapshot
                                                        .connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const Center(
                                                      child:
                                                          CircularProgressIndicator());
                                                } else if (imageSnapshot
                                                        .hasError ||
                                                    !imageSnapshot.hasData) {
                                                  return Image.network(
                                                    'https://via.placeholder.com/75',
                                                    fit: BoxFit.cover,
                                                  );
                                                } else {
                                                  return Image.memory(
                                                    imageSnapshot.data!,
                                                    fit: BoxFit.cover,
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                univers['name'],
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                univers['description'],
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ),
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const Divider(),
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
