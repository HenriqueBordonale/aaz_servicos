import 'dart:io';

import 'package:aaz_servicos/models/perfilProfi.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class perfilprofissional extends StatefulWidget {
  final String idServico;

  perfilprofissional({required this.idServico});

  @override
  State<perfilprofissional> createState() => _perfilprofissional();
}

class _perfilprofissional extends State<perfilprofissional> {
  bool _isLoading = false;
  String? idPerfil;
  String? imageUrlMidia;
  bool perfilCriado = false;
  List<String> photoUrlsMidia = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();

    Perfil().consultarDocUser(onDataReceivedToUser);
    Perfil().consultarDocServico(onDataReceivedToServico);
    loadUserPhotos();
    loadInfoPerfil();
  }

  String? nome;
  String? descricao;
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
          'Cadastrar Perfil',
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
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      FutureBuilder<double?>(
                        future: Perfil().calcularMediaNotas(idPerfil ?? '0'),
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
                      Text('$servico'),
                      const SizedBox(
                        height: 4,
                      ),
                      Text('$especificacao'),
                      const SizedBox(
                        height: 4,
                      ),
                      Text('$cidade - $uf'),
                      const SizedBox(
                        height: 4,
                      ),
                      Text('Contratações - $cont'),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Descrição',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          onTap: () {
                            _showEditDescriptionModal(context);
                          },
                          child: Row(
                            children: [
                              Text('Alterar Descrição'),
                              SizedBox(width: 8),
                              Icon(Icons.edit),
                            ],
                          ),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Fotos',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          onTap: () {
                            uploadImage();
                          },
                          child: Row(
                            children: [
                              Text('Enviar Fotos'),
                              SizedBox(width: 8),
                              Icon(Icons.camera_alt),
                            ],
                          ),
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
                    Container(
                      height: 120,
                      child: _isLoading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : ListView.builder(
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

            const SizedBox(height: 20), // Espaçamento entre blocos
            TextButton(
              onPressed: () {
                if (perfilCriado == true) {
                  // Lógica para editar o perfil
                  print('Editar Perfil');
                  // Chame a função de edição do perfil aqui
                  Perfil().updatePerfil(
                      idPerfil.toString(),
                      descricao.toString(),
                      nome.toString(),
                      servico.toString(),
                      especificacao.toString(),
                      imageUrlPerfil.toString());
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Perfil atualizado com sucesso!'),
                  ));
                } else {
                  // Lógica para criar um perfil
                  print('Criar Perfil');
                  // Chame a função de criação do perfil aqui
                  Perfil().createPerfil(
                      widget.idServico.toString(),
                      descricao.toString(),
                      nome.toString(),
                      servico.toString(),
                      especificacao.toString(),
                      imageUrlPerfil.toString());
                  setState(() {
                    perfilCriado = true;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Perfil criado com sucesso!'),
                  ));
                }
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
                      perfilCriado ? "Salvar Perfil" : "Criar Perfil",
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

  Future<String?> checkIfProfileExists() async {
    final profilesCollection = FirebaseFirestore.instance.collection('perfis');
    final querySnapshot = await profilesCollection
        .where('idServico', isEqualTo: widget.idServico)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      idPerfil = querySnapshot.docs.first.id;
      setState(() {
        perfilCriado = true;
      });
      return idPerfil;
    }
  }

  Future<void> loadUserPhotos() async {
    idPerfil = await checkIfProfileExists();
    if (idPerfil != null) {
      final perfilPhotos =
          await _firestore.collection('perfis').doc(idPerfil).get();
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
    idPerfil = await checkIfProfileExists();
    final profilesCollection = FirebaseFirestore.instance.collection('perfis');
    final perfilDocument = await profilesCollection.doc(idPerfil).get();
    if (perfilDocument.exists) {
      final Map<String, dynamic>? data = perfilDocument.data();

      if (data != null) {
        setState(() {
          descricao = data['descricao'] as String?;
          imageUrlPerfil = data['imageUrl'] as String?;
          cont = data['quantidade'] as int?;
          print("teste$cont");
        });
      }
    }
  }

  Future<void> uploadImage() async {
    setState(() {
      _isLoading = true; // Mostrar tela de carregamento
    });

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);

      if (idPerfil != null) {
        final photoRef = FirebaseStorage.instance
            .ref()
            .child('midias_perfil/$idPerfil/${DateTime.now()}.jpg');
        await photoRef.putFile(file);
        final downloadUrl = await photoRef.getDownloadURL();

        // Atualize a lista de fotos no Firestore
        final servicoRef = _firestore.collection('perfis').doc(idPerfil);
        await servicoRef.update({
          'photos': FieldValue.arrayUnion([downloadUrl]),
        });
        loadUserPhotos();

        setState(() {
          _isLoading = false; // Esconder tela de carregamento
        });
      }
    }
  }

  void onDataReceivedToUser(String nome, String cidade, String uf) {
    setState(() {
      this.nome = nome;
      this.cidade = cidade;
      this.uf = uf;
    });
  }

  void onDataReceivedToServico(String servico, String especificacao) {
    setState(() {
      this.servico = servico;
      this.especificacao = especificacao;
    });
  }

  // Método para mostrar o modal de edição da descrição
  void _showEditDescriptionModal(BuildContext context) {
    TextEditingController _descricao = TextEditingController(text: descricao);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Editar Descrição',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextField(
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: Color.fromARGB(226, 236, 55, 45),
                    width: 2,
                  )),
                ),
                maxLength: 300, // Limite de 280 caracteres
                maxLines: 5, // Permite várias linhas
                controller: _descricao,
                onChanged: (value) {
                  setState(() {
                    descricao = value;
                  });
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(200, 255, 86, 34),
                  padding:
                      EdgeInsets.symmetric(vertical: 16), // Espaçamento interno
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15), // Borda arredondada
                  ),
                  minimumSize: Size(100, 0), // Defina a largura mínima desejada
                  alignment:
                      Alignment.center, // Centralize o texto horizontalment
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Feche o modal de edição
                },
                child: Text('Salvar'),
              ),
            ],
          ),
        );
      },
    );
  }

  // Função para exibir um diálogo de confirmação
  Future<void> showDeleteConfirmationDialog(
      BuildContext context, int index, List<String> imageUrls) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmar Exclusão'),
          content: Text('Tem certeza de que deseja excluir esta imagem?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
            ),
            TextButton(
              child: Text('Excluir'),
              onPressed: () async {
                // Fecha o diálogo
                Navigator.of(context).pop();

                // Mostre um AlertDialog com um indicador de carregamento

                Perfil()
                    .deleteImageFromStorage(imageUrls[index], widget.idServico);

                // Remova a imagem da lista
                imageUrls.removeAt(index);

                // Atualize a lista de imagens na tela
                setState(() {
                  photoUrlsMidia = imageUrls;
                });

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
                        height: 300,
                        child: Image.network(
                          imageUrls[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: 350,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.delete),
                          label: Text('Excluir'),
                          style: ElevatedButton.styleFrom(
                            primary: const Color.fromARGB(179, 244, 67, 54),
                          ),
                          onPressed: () {
                            showDeleteConfirmationDialog(
                                context, index, imageUrls);
                          },
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
