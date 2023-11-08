import 'dart:io';

import 'package:aaz_servicos/models/database.dart';
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
  String? imageUrlPerfil;
  String? descricao;
  String? idPerfil;
  String? imageUrlMidia;
  bool perfilCriado = false;
  List<String> photoUrlsMidia = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    LoadUrlImage();
    checkIfProfileExists();
    Perfil().consultarDocUser(onDataReceivedToUser);
    Perfil().consultarDocServico(onDataReceivedToServico);

    loadUserPhotos();
    loadInfoPerfil();
  }

  String nome = '';
  String cidade = '';
  String uf = '';
  String servico = '';
  String especificacao = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(221, 249, 74, 16),
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
                imageUrlPerfil != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(75),
                        child: Image.network(
                          imageUrlPerfil!,
                          fit: BoxFit.cover,
                          width: 150,
                          height: 150,
                        ),
                      )
                    : const Icon(
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
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text('CARREGANDO'),
                      const SizedBox(
                        height: 4,
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
                      Text('Contratações'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Color.fromARGB(150, 238, 237, 237),
                border: Border.all(
                  color: Color.fromARGB(255, 211, 209, 209),
                ),
                borderRadius: BorderRadius.circular(10),
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
                        descricao ?? '"Escreva sobre você ou seu serviço"',
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
                color: Color.fromARGB(150, 238, 237, 237),
                border: Border.all(
                  color: Color.fromARGB(255, 211, 209, 209),
                ),
                borderRadius: BorderRadius.circular(10),
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
                            uploadImage(widget.idServico);
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
                      height: 120, // Altura fixa das imagens
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
                                width: 120, // Largura fixa das imagens
                                height: 120, // Altura fixa das imagens
                                fit: BoxFit
                                    .cover, // Pode ajustar a escala da imagem conforme necessário
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
            ElevatedButton(
              onPressed: () {
                if (perfilCriado == true) {
                  // Lógica para editar o perfil
                  print('Editar Perfil');
                  // Chame a função de edição do perfil aqui
                  Perfil()
                      .updatePerfil(idPerfil.toString(), descricao.toString());
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Perfil atualizado com sucesso!'),
                  ));
                } else {
                  // Lógica para criar um perfil
                  print('Criar Perfil');
                  // Chame a função de criação do perfil aqui
                  Perfil().createPerfil(
                      widget.idServico.toString(), descricao.toString());
                  setState(() {
                    perfilCriado = true;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Perfil criado com sucesso!'),
                  ));
                }
              },
              style: ElevatedButton.styleFrom(
                primary: perfilCriado
                    ? const Color.fromARGB(212, 76, 175, 79)
                    : const Color.fromARGB(208, 255, 153, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(perfilCriado ? "Salvar Perfil" : "Criar Perfil"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> checkIfProfileExists() async {
    final profilesCollection = FirebaseFirestore.instance.collection('perfis');
    final querySnapshot = await profilesCollection
        .where('idServico', isEqualTo: widget.idServico)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Um perfil com o mesmo idServico já existe
      setState(() {
        perfilCriado = true;
        idPerfil = querySnapshot.docs.first.id;
      });
    }
  }

  Future<void> loadUserPhotos() async {
    if (widget.idServico != null) {
      final perfilPhotos =
          await _firestore.collection('servicos').doc(widget.idServico).get();
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
    final querySnapshot = await profilesCollection
        .where('idServico', isEqualTo: widget.idServico)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final descricaoDoc = querySnapshot.docs.first.data()?['descricao'];
      setState(() {
        descricao = descricaoDoc as String?;
      });
    }
  }

  Future<void> uploadImage(String idServico) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);

      if (idServico != null) {
        final photoRef = FirebaseStorage.instance
            .ref()
            .child('midias_perfil/$idServico/${DateTime.now()}.jpg');
        await photoRef.putFile(file);
        final downloadUrl = await photoRef.getDownloadURL();

        // Atualize a lista de fotos no Firestore
        final servicoRef = _firestore.collection('servicos').doc(idServico);
        await servicoRef.update({
          'photos': FieldValue.arrayUnion([downloadUrl]),
        });
        loadUserPhotos();
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

  Future<void> LoadUrlImage() async {
    String? _imageUrl = await DatabaseMethods().checkIfImageExists();
    imageUrlPerfil = _imageUrl;
  }

  // Método para mostrar o modal de edição da descrição
  void _showEditDescriptionModal(BuildContext context) {
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
                controller: TextEditingController(),
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
            color: Color.fromARGB(159, 233, 232, 232),
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
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey,
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
