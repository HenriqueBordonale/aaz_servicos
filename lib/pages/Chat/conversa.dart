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
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Chat> chats = [
    Chat(
      chatId: '1',
      messages: [
        Message(sender: 'User1', text: 'Olá!', timestamp: DateTime.now()),
        Message(
            sender: 'User2',
            text: 'Oi! Como você está?',
            timestamp: DateTime.now()),
        // Adicione mais mensagens conforme necessário
      ],
    ),
    // Adicione mais chats conforme necessário
  ];

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
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Chat ${chats[index].chatId}'),
            onTap: () {
              _openChatScreen(chats[index]);
            },
          );
        },
      ),
    );
  }

  void _openChatScreen(Chat chat) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatDetailScreen(chat: chat),
      ),
    );
  }
}

class ChatDetailScreen extends StatelessWidget {
  final Chat chat;

  ChatDetailScreen({required this.chat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Robson Bambu',
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
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: chat.messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                      '${chat.messages[index].sender}: ${chat.messages[index].text}'),
                  subtitle: Text('${chat.messages[index].timestamp}'),
                );
              },
            ),
          ),
          // Adicione um campo de entrada de mensagem e um botão de envio aqui
        ],
      ),
    );
  }
}
