import 'package:aaz_servicos/models/database.dart';
import 'package:aaz_servicos/pages/Chat/bubbleMessage.dart';
import 'package:aaz_servicos/pages/Chat/conversas.dart';
import 'package:aaz_servicos/pages/Feedback/feedbackScreen.dart';
import 'package:aaz_servicos/pages/Menu/menuPrincipal.dart';
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
  String? userRemetente;
  String? tipouser;
  String? servFinalizado;
  @override
  void initState() {
    super.initState();
    _initializeData();
    verificarServicoFinalizado(widget.chat.chatId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: const Color.fromARGB(
          255, 238, 238, 238), // Defina a cor de fundo desejada para a tela
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 15,
            ),
            child: Visibility(
              visible: tipouser == 'ofertante' && servFinalizado == 'A' ||
                  (tipouser == 'contratante' && servFinalizado == 'B'),
              child: Container(
                height: 35,
                width: 160,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(144, 249, 74, 16),
                      Color.fromARGB(157, 236, 55, 45),
                    ],
                  ),
                ),
                child: TextButton(
                  child: Text(
                    tipouser == 'ofertante'
                        ? 'Encerrar Serviço'
                        : 'Realizar Avaliação',
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 252, 252),
                      fontWeight: FontWeight.w300,
                      fontSize: 15,
                    ),
                  ),
                  onPressed: () async {
                    if (tipouser == 'ofertante') {
                      attServicoState(widget.chat.chatId);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FeedbackScreen(
                            idChat: widget.chat.chatId,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: _buildMessagesList(),
          ),
          Container(
            color: const Color.fromARGB(190, 238, 238,
                238), // Defina a cor desejada para o espaçamento entre a lista e o input
            height: 20.0, // Ajuste a altura conforme necessário
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(widget.chat.nomeUsuario ?? 'Nome do Usuário'),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(
                  255, 255, 255, 255), // Defina a cor de fundo desejada aqui
              border: Border(
                top: BorderSide(
                  color: Color.fromARGB(255, 206, 205, 205), // Cor da borda
                  width: 1.0, // Espessura da borda
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Digite sua mensagem...',
                        hintStyle: TextStyle(
                          fontFamily: 'inter',
                          fontWeight: FontWeight.w400,
                          color: Color.fromARGB(172, 69, 69, 69),
                        ),
                        border: InputBorder.none,
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
          ),
        ),
      ],
    );
  }

  Widget _buildMessagesList() {
    return Container(
      color:
          Color.fromARGB(192, 238, 238, 238), // Defina a cor de fundo desejada
      child: StreamBuilder<QuerySnapshot>(
        stream: messagesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar mensagens'));
          } else if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Sem mensagens'));
          } else {
            var messages = snapshot.data!.docs;

            return ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                var invertedIndex = messages.length - 1 - index;
                var messageData =
                    messages[invertedIndex].data() as Map<String, dynamic>?;

                if (messageData != null) {
                  var sender = messageData['sender'] ?? '';
                  var text = messageData['text'] ?? '';
                  var isCurrentUser = sender == widget.chat.nomeUsuario;

                  return ChatMessageBubble(
                    text: text,
                    isCurrentUser: isCurrentUser,
                  );
                } else {
                  return Container(); // Tratamento para mensagens inválidas
                }
              },
            );
          }
        },
      ),
    );
  }

  Future<void> _initializeData() async {
    String? tipoUsuario = await ChatModel().getUserType();
    print('$tipoUsuario');
    String idChat = widget.chat.chatId;

    if (tipoUsuario != null) {
      messagesStream = FirebaseFirestore.instance
          .collection('mensagens')
          .where('chatId', isEqualTo: idChat)
          .orderBy('timestamp')
          .snapshots();

      String? nomeUsuarioa = await ChatModel().getNameUser(idChat, tipoUsuario);
      String? userremetente = await DatabaseMethods().getUserName();
      setState(() {
        widget.chat.nomeUsuario = nomeUsuarioa;
        userRemetente = userremetente;
        tipouser = tipoUsuario;
      });
    } else {
      print('Erro: tipoUsuario é nulo');
    }
  }

  void _sendMessage() async {
    String messageText = _messageController.text.trim();
    String? nomeUsuario = widget.chat.nomeUsuario;
    if (messageText.isNotEmpty && userRemetente != null) {
      await FirebaseFirestore.instance.collection('mensagens').add({
        'remetente': userRemetente,
        'sender': nomeUsuario,
        'chatId': widget.chat.chatId,
        'text': messageText.toString(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      _messageController.clear();
    }
  }

  Future<void> attServicoState(String idChat) async {
    bool confirmacao = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmação'),
          content: const Text('Tem certeza de que deseja finalizar o serviço?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirmação positiva
              },
              child: const Text('Sim'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Confirmação negativa
              },
              child: const Text('Não'),
            ),
          ],
        );
      },
    );

    if (confirmacao) {
      String servicofinalizado = 'B';
      await FirebaseFirestore.instance.collection('chat').doc(idChat).update({
        'servicoFinalizado': servicofinalizado,
      });
      somarValorAoCampo();
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Serviço Finalizado'),
            content: const Text(
                'Você finalizou um serviço com sucesso\njá está disponível sua avaliação para o contratante'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const menuPrincipal(),
                    ),
                  );
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> somarValorAoCampo() async {
    String idPerfil = widget.chat.idPerfil;
    int valorASomar = 1;

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction
          .get(FirebaseFirestore.instance.collection('perfis').doc(idPerfil));

      int quantidadeAtual = snapshot['quantidade'] ?? 0;
      int novaQuantidade = quantidadeAtual + valorASomar;

      transaction.update(
          FirebaseFirestore.instance.collection('perfis').doc(idPerfil),
          {'quantidade': novaQuantidade});
    });
    print('Operação de soma concluída com sucesso');
  }

  Future<void> verificarServicoFinalizado(String idChat) async {
    DocumentSnapshot chatSnapshot =
        await FirebaseFirestore.instance.collection('chat').doc(idChat).get();

    if (chatSnapshot.exists) {
      String? servicoFinalizado = chatSnapshot['servicoFinalizado'];

      setState(() {
        servFinalizado = servicoFinalizado;
      });

      print('Serviço finalizado: $servicoFinalizado');
    } else {
      print('Chat não encontrado');
    }
  }
}
