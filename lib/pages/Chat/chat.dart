import 'package:aaz_servicos/pages/Chat/conversas.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aaz_servicos/models/chatModel.dart';

class ChatDetailScreen extends StatefulWidget {
  final Chat chat;

  ChatDetailScreen({required this.chat});

  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  Stream<QuerySnapshot>? messagesStream;
  final TextEditingController _messageController = TextEditingController();
  String nomeUsuario = '';
  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: _buildMessagesList(),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(nomeUsuario ?? 'Nome do Usuário'),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(221, 249, 74, 16),
              Color.fromARGB(226, 236, 55, 45),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: Color.fromARGB(193, 245, 34, 2),
          ),
          color: Color.fromARGB(30, 255, 0, 0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Digite sua mensagem...',
                    hintStyle: TextStyle(
                      fontFamily: 'inter',
                      fontWeight: FontWeight.w400,
                      color: Color.fromARGB(173, 65, 65, 65),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.send,
                color: Color.fromARGB(193, 245, 34, 2),
              ),
              onPressed: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessagesList() {
    return StreamBuilder<QuerySnapshot>(
      stream: messagesStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print('Erro ao carregar mensagens: ${snapshot.error}');
          return Center(child: Text('Erro ao carregar mensagens'));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('Sem mensagens'));
        } else {
          var messages = snapshot.data!.docs;
          List<Widget> messageWidgets = [];

          for (var message in messages) {
            var messageData = message.data() as Map<String, dynamic>?;
            if (messageData != null) {
              var messageText = messageData['text'] ?? '';
              var sender = messageData['sender'] ?? '';
              var messageWidget = ListTile(
                title: Text('$sender: $messageText'),
              );
              messageWidgets.add(messageWidget);
            }
          }

          return ListView(
            children: messageWidgets,
          );
        }
      },
    );
  }

  Future<void> _initializeData() async {
    try {
      String? tipoUsuario = await ChatModel().getUserType();
      String idChat = widget.chat.chatId;

      if (tipoUsuario != null) {
        messagesStream = FirebaseFirestore.instance
            .collection('mensagens')
            .where('chatId', isEqualTo: idChat)
            .orderBy('timestamp')
            .snapshots();

        String? nomeUsuarioa =
            await ChatModel().getNameUser(idChat, tipoUsuario);
        setState(() {
          widget.chat.nomeUsuario = nomeUsuarioa;
        });
      } else {
        print('Erro: tipoUsuario é nulo');
      }
    } catch (e) {
      print('Erro durante a inicialização de dados: $e');
    }
  }

  void _sendMessage() async {
    String messageText = _messageController.text.trim();
    String? nomeUsuario = widget.chat.nomeUsuario;

    if (messageText.isNotEmpty && nomeUsuario != null) {
      await FirebaseFirestore.instance.collection('mensagens').add({
        'sender': nomeUsuario,
        'chatId': widget.chat.chatId,
        'text': messageText.toString(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      _messageController.clear();
    }
  }
}
