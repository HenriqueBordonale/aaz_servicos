import 'package:aaz_servicos/models/chatModel.dart';
import 'package:aaz_servicos/pages/Chat/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Message {
  final String sender;
  final String text;
  final DateTime timestamp;

  Message({
    required this.sender,
    required this.text,
    required this.timestamp,
  });
}

class Chat {
  final String chatId;
  final List<Message> messages;

  Chat({required this.chatId, required this.messages});

  Chat.empty({required this.chatId}) : messages = [];
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late List<Chat> chats = [];
  final FirebaseAuth auth = FirebaseAuth.instance;
  String userID = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    loadChats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Conversas',
          style: TextStyle(fontSize: 25, fontFamily: 'inter'),
        ),
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
        automaticallyImplyLeading: false,
      ),
      body: chats.isNotEmpty
          ? ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                return FutureBuilder<String?>(
                  future: _initializeData(index),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ListTile(
                        title: Text('Carregando...'),
                      );
                    } else if (snapshot.hasError) {
                      return ListTile(
                        title: Text('Erro: ${snapshot.error}'),
                      );
                    } else {
                      return ListTile(
                        title: Text('${snapshot.data}'),
                        onTap: () {
                          _openChatScreen(chats[index]);
                        },
                      );
                    }
                  },
                );
              },
            )
          : CircularProgressIndicator(),
    );
  }

  Future<void> loadChats() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('chat').get();

      setState(() {
        chats = snapshot.docs.where((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return data['idContratante'] == userID ||
              data['idOfertante'] == userID;
        }).map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          List<Message> messages =
              (data['messages'] as List<dynamic>? ?? []).map((msg) {
            return Message(
              sender: msg['sender'],
              text: msg['text'],
              timestamp: (msg['timestamp'] as Timestamp).toDate(),
            );
          }).toList();

          return Chat(
            chatId: doc.id,
            messages: messages,
          );
        }).toList();
      });
    } catch (e) {
      print('Erro ao carregar chats: $e');
    }
  }

  void _openChatScreen(Chat chat) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatDetailScreen(chat: chat),
      ),
    );
  }

  Future<String?> _initializeData(int index) async {
    try {
      String? tipoUsuario = await ChatModel().getUserType();
      print('$tipoUsuario');
      String idChat = chats[index].chatId;

      if (tipoUsuario != null) {
        String? nomeUsuario =
            await ChatModel().getNameUser(idChat, tipoUsuario);
        print('$nomeUsuario');
        return nomeUsuario;
      } else {
        print('Erro: tipoUsuario é nulo');
        return null;
      }
    } catch (e) {
      print('Erro durante a inicialização de dados: $e');
      return null;
    }
  }
}
