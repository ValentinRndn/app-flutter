import 'package:flutter/material.dart';
import 'package:chatbot_filrouge/class/Conversation.class.dart';
import 'package:chatbot_filrouge/class/Token.dart';
import 'package:chatbot_filrouge/class/Message.class.dart';
import 'package:chatbot_filrouge/class/Personnage.class.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ScreenPersonnageConversation extends StatefulWidget {
  final int characterId;
  final int universId;
  final int userId;

  const ScreenPersonnageConversation({
    Key? key,
    required this.characterId,
    required this.universId,
    required this.userId,
  }) : super(key: key);

  @override
  _ScreenPersonnageConversationState createState() =>
      _ScreenPersonnageConversationState();
}

class _ScreenPersonnageConversationState
    extends State<ScreenPersonnageConversation> {
  final Conversation _conversation = Conversation();
  final Token _token = Token();
  final Message _message = Message();
  final Personnage _personnage = Personnage();
  final TextEditingController _messageController = TextEditingController();
  int? _conversationId;
  List<dynamic> _messages = [];
  bool _isLoading = true;
  String? _error;
  Map<String, dynamic>? _characterDetails;

  @override
  void initState() {
    super.initState();
    _initializeConversation();
    _fetchCharacterDetails();
  }

  Future<void> _initializeConversation() async {
    try {
      final String? token = await _token.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }

      List<dynamic> allConversations =
          await _conversation.getAllConversation(token);

      // Filtrer les conversations par characterId
      List<dynamic> filteredConversations =
          allConversations.where((conversation) {
        return conversation['character_id'] == widget.characterId;
      }).toList();

      // Si aucune conversation n'est trouvée, créer une nouvelle conversation
      if (filteredConversations.isEmpty) {
        await _conversation.createConversation(
            token, widget.characterId, widget.userId);

        // Récupérer à nouveau les conversations après en avoir créé une nouvelle
        allConversations = await _conversation.getAllConversation(token);
        filteredConversations = allConversations.where((conversation) {
          return conversation['character_id'] == widget.characterId;
        }).toList();
      }

      // Assigner l'ID de la première conversation trouvée (ou nouvellement créée)
      if (filteredConversations.isNotEmpty) {
        _conversationId = filteredConversations.first['id'];
      }

      if (_conversationId != null) {
        List<dynamic> messages =
            await _message.getAllMessage(token, _conversationId!);
        messages.sort((a, b) => DateTime.parse(a['created_at'])
            .compareTo(DateTime.parse(b['created_at'])));
        setState(() {
          _messages = messages;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchCharacterDetails() async {
    try {
      final String? token = await _token.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }

      final characterDetails = await _personnage.getSinglePersonnage(
          token, widget.universId, widget.characterId);

      setState(() {
        _characterDetails = characterDetails;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  Future<void> _sendMessage(String content) async {
    try {
      final String? token = await _token.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }

      if (_conversationId == null) {
        throw Exception('No conversation ID found');
      }

      Map<String, dynamic> response =
          await _message.createMessage(token, _conversationId!, content);
      setState(() {
        _messages.add(response['message']);
        _messages.add(response['answer']);
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  Future<void> _deleteConversation() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmer la suppression'),
          content: const Text(
              'Êtes-vous sûr de vouloir supprimer cette conversation ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        final String? token = await _token.getToken();
        if (token == null) {
          throw Exception('Token not found');
        }

        if (_conversationId == null) {
          throw Exception('No conversation ID found');
        }

        await _conversation.deleteConversation(token, _conversationId!);
        Navigator.of(context)
            .pop(); // Retour à l'écran précédent après suppression
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la suppression : $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _characterDetails == null
            ? const CircularProgressIndicator()
            : Column(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: _characterDetails!['image'] != null
                        ? CachedNetworkImageProvider(
                            'https://mds.sprw.dev/image_data/${_characterDetails!['image']}',
                          )
                        : const AssetImage('assets/placeholder.png')
                            as ImageProvider,
                    onBackgroundImageError: (_, __) {
                      setState(() {
                        _characterDetails!['image'] = null;
                      });
                    },
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _characterDetails!['name'] ?? 'Nom personnage',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteConversation,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ListView.builder(
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            var message = _messages[index];
                            bool isSentByHuman = message['is_sent_by_human'];
                            return Align(
                              alignment: isSentByHuman
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isSentByHuman
                                      ? Colors.blue
                                      : Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  message['content'],
                                  style: TextStyle(
                                    color: isSentByHuman
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              decoration: InputDecoration(
                                hintText: 'Tapez votre message...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: () async {
                              String content = _messageController.text;
                              _messageController.clear();
                              await _sendMessage(content);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
