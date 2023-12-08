import 'package:aaz_servicos/models/chatModel.dart';
import 'package:aaz_servicos/models/feedback.dart';
import 'package:aaz_servicos/models/perfilProfi.dart';
import 'package:aaz_servicos/pages/Feedback/feedbackCard.dart';
import 'package:aaz_servicos/pages/Menu/menuPrincipal.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MostrarPerfil extends StatefulWidget {
  final String idPerfil;

  MostrarPerfil({required this.idPerfil});

  @override
  State<MostrarPerfil> createState() => _mostrarPerfil();
}

class _mostrarPerfil extends State<MostrarPerfil> {
  String? imageUrlMidia;
  List<String> photoUrlsMidia = [];

  FeedbackM feedbackService = FeedbackM();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> feedbackList = [];
  @override
  void initState() {
    super.initState();
    loadUserPhotos();
    loadInfoPerfil();
    _carregarFeedbacks();
  }

  String? descricao;
  String? nome;
  String? cidade;
  String? uf;
  String? servico;
  String? especificacao;
  String? imageUrlPerfil;
  int? cont;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Perfil Profissional',
          style: TextStyle(fontSize: 25, fontFamily: 'inter'),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Adicione aqui o comportamento desejado ao clicar na seta de voltar
            Navigator.of(context)
                .pop(true); // Exemplo: voltar para a tela anterior
          },
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(221, 249, 74, 16),
                Color.fromARGB(226, 236, 55, 45),
              ], // Escolha as cores desejadas para o gradiente
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          left: 15,
          right: 15,
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                if (imageUrlPerfil != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(75),
                    child: Image.network(
                      imageUrlPerfil!,
                      fit: BoxFit.cover,
                      width: 150,
                      height: 150,
                    ),
                  )
                else
                  const Icon(
                    Icons.account_circle,
                    size: 150,
                  ),
                const SizedBox(width: 25),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$nome',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      FutureBuilder<double?>(
                        future: Perfil().calcularMediaNotas(widget
                            .idPerfil), // Substitua idPerfilAtual pelo valor correto
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text('CARREGANDO');
                          } else {
                            double mediaNotas =
                                snapshot.data != null ? snapshot.data! : 0.0;

                            return Row(
                              children: [
                                Text(
                                  '$mediaNotas',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Color.fromARGB(207, 10, 10, 10),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'inter',
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Icon(
                                  Icons.star,
                                  size: 25,
                                  color: Color.fromARGB(255, 243, 160, 51),
                                ),
                                const SizedBox(width: 10),
                              ],
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 4),
                      Text('$servico'),
                      const SizedBox(height: 4),
                      Text('$especificacao'),
                      const SizedBox(height: 4),
                      Text('$cidade - $uf'),
                      const SizedBox(height: 4),
                      Text('Contratações  $cont'),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white, // Cor de fundo
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 3,
                  left: 10,
                  right: 10,
                ),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Descrição',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Divider(
                      color: Colors.grey, // Cor do divisor
                      height: 25, // Altura do divisor
                      thickness: 0.8, // Espessura do divisor
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 3,
                        left: 20,
                        right: 20,
                      ),
                      child: Text(
                        descricao ?? '',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20), // Espaçamento entre blocos

            // Bloco 3: Fotos
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white, // Cor de fundo
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 3,
                  left: 10,
                  right: 10,
                ),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Fotos',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Divider(
                      color: Colors.grey, // Cor do divisor
                      height: 25, // Altura do divisor
                      thickness: 1, // Espessura do divisor
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: photoUrlsMidia.length > 3
                            ? 3
                            : photoUrlsMidia.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: GestureDetector(
                              onTap: () {
                                openImageGallery(context, photoUrlsMidia);
                              },
                              child: Image.network(
                                photoUrlsMidia[index],
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            //Bloco Feedback
            FeedbackCard(feedbackList: feedbackList),

            const SizedBox(height: 20), // Espaçamento entre blocos
            TextButton(
              onPressed: () {
                ChatModel().createChat(widget.idPerfil);
                // ChatModel().createMensagens();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const menuPrincipal(),
                  ),
                );
              },
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(221, 249, 74, 16),
                      Color.fromARGB(226, 236, 55, 45),
                    ],
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical:
                          16), // Ajuste o preenchimento conforme necessário
                  child: Center(
                    child: Text(
                      "Iniciar Conversa",
                      style: TextStyle(
                        color: Colors.white, // Cor do texto
                        fontSize: 16, // Tamanho da fonte
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _carregarFeedbacks() async {
    try {
      // Chame a função assíncrona e aguarde o resultado usando 'await'
      feedbackList = await feedbackService.getFeedbacks(widget.idPerfil);

      // Agora você pode usar feedbackList conforme necessário
      if (feedbackList.isNotEmpty) {
        print('Feedbacks carregados com sucesso.');
        print('Primeiro feedback: ${feedbackList.first}');
      } else {
        print('Nenhum feedback encontrado.');
      }

      setState(() {
        // Atualize o estado se necessário
      });
    } catch (e) {
      print("Erro ao carregar feedbacks: $e");
    }
  }

  Future<void> loadUserPhotos() async {
    if (widget.idPerfil != null) {
      final perfilPhotos =
          await _firestore.collection('perfis').doc(widget.idPerfil).get();
      if (perfilPhotos.exists) {
        final photos = perfilPhotos.data()?['photos'] as List<dynamic>?;
        if (photos != null) {
          setState(() {
            photoUrlsMidia = photos.map((url) => url.toString()).toList();
          });
        }
      }
    }
  }

  Future<void> loadInfoPerfil() async {
    final profilesCollection = FirebaseFirestore.instance.collection('perfis');
    final perfilDocument = await profilesCollection.doc(widget.idPerfil).get();

    if (perfilDocument.exists) {
      final Map<String, dynamic>? data = perfilDocument.data();

      if (data != null) {
        setState(() {
          descricao = data['descricao'] as String?;
          servico = data['categoria'] as String?;
          especificacao = data['especificacao'] as String?;
          nome = data['nome'] as String?;
          imageUrlPerfil = data['imageUrl'] as String?;
          cont = data['quantidade'] as int?;
          cidade = data['cidade'] as String?;
          uf = data['uf'] as String?;
        });
      }
    }
  }

  void openImageGallery(BuildContext context, List<String> imageUrls) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            color: Color.fromARGB(84, 54, 53, 53),
            child: PageView.builder(
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 370,
                        child: Image.network(
                          imageUrls[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: 350,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
