import 'package:aaz_servicos/models/auth.dart';
import 'package:aaz_servicos/pages/Chat/conversas.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  Future<String?>? nomeUsuarioFuture;
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: nomeUsuarioFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Erro ao obter nome de usuário'),
            ),
          );
        } else {
          return _buildChatDetailScreen(snapshot.data);
        }
      },
    );
  }

  Widget _buildChatDetailScreen(String? nomeUsuario) {
    return Scaffold(
      appBar: _buildAppBar(nomeUsuario),
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

  AppBar _buildAppBar(String? nomeUsuario) {
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

  Widget _buildMessagesList() {
    return ListView.builder(
      itemCount: widget.chat.messages.length,
      itemBuilder: (context, index) {
        final message = widget.chat.messages[index];

        return ListTile(
          title: Text(
            '${message.sender}: ${message.text}',
          ),
          subtitle: Text('${message.timestamp}'),
          // Adicione um ícone ou algo para distinguir as mensagens do contratante e do ofertante
          //  leading: message.sender == widget.chat.contratanteId
          //    ? Icon(Icons.person) // Ícone para mensagens do contratante
          //  : Icon(Icons.shopping_cart), // Ícone para mensagens do ofertante
        );
      },
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

  Future<void> _initializeData() async {
    try {
      String? tipoUsuario = await ChatModel().getUserType();
      print('$tipoUsuario');
      String idChat = widget.chat.chatId;

      if (tipoUsuario != null) {
        String? nomeUsuario =
            await ChatModel().getNameUser(idChat, tipoUsuario);
        print('$nomeUsuario');
        setState(() {
          nomeUsuarioFuture = Future.value(nomeUsuario);
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
    if (messageText.isNotEmpty) {
      String idRemetente = FirebaseAuth.instance.currentUser!.uid;
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      await FirebaseFirestore.instance
          .collection(
              'mensagens') // Substitua 'messages' pelo nome da sua coleção
          .add({
        'sender': idRemetente,
        'chatId': widget.chat.chatId,
        'text': messageText,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _messageController.clear();
    }
  }
}
