import 'package:aaz_servicos/models/chatModel.dart';
import 'package:aaz_servicos/pages/Chat/conversas.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatDetailScreen extends StatefulWidget {
  final Chat chat;

  ChatDetailScreen({required this.chat});

  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  Future<String?>? nomeUsuarioFuture;

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
      appBar: AppBar(
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
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.chat.messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    '${widget.chat.messages[index].sender}: ${widget.chat.messages[index].text}',
                  ),
                  subtitle: Text('${widget.chat.messages[index].timestamp}'),
                );
              },
            ),
          ),
          // Adicione um campo de entrada de mensagem e um botão de envio aqui
        ],
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
        // Lide com a situação em que tipoUsuario é nulo
        print('Erro: tipoUsuario é nulo');
      }
    } catch (e) {
      print('Erro durante a inicialização de dados: $e');
    }
  }
}
