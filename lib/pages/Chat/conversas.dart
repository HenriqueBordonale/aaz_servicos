import 'package:aaz_servicos/models/chatModel.dart';
import 'package:aaz_servicos/models/database.dart';
import 'package:aaz_servicos/pages/Chat/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Chat {
  final String chatId;
  final String idPerfil;
  String? nomeUsuario;
  String? servFinalizado;

  Chat(
      {required this.chatId,
      required this.idPerfil,
      this.nomeUsuario,
      required this.servFinalizado});

  Chat.empty(
      {required this.chatId,
      required this.idPerfil,
      required this.servFinalizado});
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
              padding: EdgeInsets.only(top: 20, left: 10, right: 10),
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];

                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 15,
                  ),
                  color: chat.servFinalizado == 'C'
                      ? Color.fromARGB(255, 225, 224, 224)
                      : Colors.white,
                  child: FutureBuilder<String?>(
                    future: _initializeData(index),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return ListTile(
                          leading: CircularProgressIndicator(),
                          title: Text('Carregando...'),
                        );
                      } else {
                        String? servicoFinalizado = chat.servFinalizado;
                        return ListTile(
                          leading: Container(
                            width: 60, // Largura total do conteúdo do leading
                            child: Row(
                              children: [
                                FutureBuilder<String?>(
                                  future: getImageProfile(index),
                                  builder: (context, imageSnapshot) {
                                    if (imageSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } else {
                                      final String? imageUrlPerfil =
                                          imageSnapshot.data;
                                      return imageUrlPerfil != null
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              child: Image.network(
                                                imageUrlPerfil,
                                                fit: BoxFit.cover,
                                                width: 45,
                                                height: 45,
                                              ),
                                            )
                                          : const Icon(
                                              Icons.account_circle,
                                              size: 45,
                                            );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${snapshot.data}',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),

                              Icon(
                                Icons.circle,
                                size: 15,
                                color: chat.servFinalizado == 'C'
                                    ? Color.fromARGB(255, 214, 79, 79)
                                    : Color.fromARGB(255, 130, 189, 140),
                              ), // Substitua "your_icon_here" pelo ícone desejado
                            ],
                          ),
                          onTap: () {
                            if (servicoFinalizado != 'C') {
                              _openChatScreen(chats[index]);
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: const Text(
                                    'Essa conversa já foi finalizada'),
                              ));
                            }
                          },
                        );
                      }
                    },
                  ),
                );
              },
            )
          : const Center(
              child: Text(
                'Nenhuma Conversa iniciada',
                style: TextStyle(
                    fontFamily: 'inter',
                    fontSize: 25,
                    fontWeight: FontWeight.w300),
              ),
            ),
    );
  }

  Future<void> loadChats() async {
    QuerySnapshot<Map<String, dynamic>> chatSnapshot =
        await FirebaseFirestore.instance.collection('chat').get();

    setState(() {
      chats = chatSnapshot.docs.where((doc) {
        Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
        return docData['idContratante'] == userID ||
            docData['idOfertante'] == userID;
      }).map((doc) {
        Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
        return Chat(
          chatId: doc.id,
          idPerfil: docData['idPerfil'],
          servFinalizado: docData['servicoFinalizado'],
        );
      }).toList();
    });
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

  Future<String?> getImageProfile(int index) async {
    try {
      String? tipoUsuario = await ChatModel().getUserType();
      String idChat = chats[index].chatId;
      String? imageUrlPerfil;

      final chatDocRef =
          FirebaseFirestore.instance.collection('chat').doc(idChat);
      DocumentSnapshot chatSnapshot = await chatDocRef.get();
      Map<String, dynamic> chatData =
          chatSnapshot.data() as Map<String, dynamic>;

      if (tipoUsuario == 'ofertante') {
        String idUser = chatData['idContratante'];
        imageUrlPerfil = await DatabaseMethods().getUrlImage(idUser);
      } else {
        String idUser = chatData['idOfertante'];
        imageUrlPerfil = await DatabaseMethods().getUrlImage(idUser);
      }

      return imageUrlPerfil;
    } catch (e) {
      print('Erro ao obter imagem de perfil: $e');
      return null;
    }
  }
}
