import 'dart:io';

import 'package:aaz_servicos/models/perfilProfi.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    checkIfProfileExists();
    Perfil().consultarDocUser(onDataReceivedToUser);
    Perfil().consultarDocServico(onDataReceivedToServico);
    loadProfileImage();
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
            const Divider(
              height: 30,
              thickness: 0.5,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 3,
                left: 10,
                right: 10,
              ),
              child: Column(children: [
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
                    ]),
              ]),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 3,
                left: 20,
                right: 20,
              ),
              child: Text(
                '$descricao',
                style: TextStyle(fontSize: 15),
              ),
            ),
            const Divider(
              height: 30,
              thickness: 0.5,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            Padding(
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
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 3,
                      left: 20,
                      right: 20,
                    ),
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemCount: photoUrlsMidia.length,
                      itemBuilder: (context, index) {
                        return Image.network(photoUrlsMidia[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 30,
              thickness: 0.5,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            Positioned(
              left: 16,
              bottom: 10,
              child: ElevatedButton(
                onPressed: () {
                  if (perfilCriado == true) {
                    // Lógica para editar o perfil
                    print('Editar Perfil');
                    // Chame a função de edição do perfil aqui
                    Perfil().updatePerfil(
                        idPerfil.toString(), descricao.toString());
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
                  primary: perfilCriado ? Colors.green : Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(perfilCriado ? "Editar Perfil" : "Criar Perfil"),
              ),
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
    final user = _auth.currentUser;
    if (user != null) {
      final userId = user.uid;
      final userPhotos = await _firestore.collection('user').doc(userId).get();
      if (userPhotos.exists) {
        final photos = userPhotos.data()?['photos'] as List<dynamic>?;
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

  Future<void> uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final user = _auth.currentUser;
      if (user != null) {
        final userId = user.uid;
        final photoRef =
            _storage.ref().child('user_photos/$userId/${DateTime.now()}.jpg');
        await photoRef.putFile(file);
        final downloadUrl = await photoRef.getDownloadURL();

        // Atualize a lista de fotos no Firestore
        final userPhotosRef = _firestore.collection('user').doc(userId);
        await userPhotosRef.update({
          'photos': FieldValue.arrayUnion([downloadUrl]),
        });

        // Recarregue as fotos na tela
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

//Image Profile
  Future<void> loadProfileImage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('Usuário não autenticado.');
      return;
    }

    final storageRef = FirebaseStorage.instance
        .ref()
        .child('user_images/profile_images/${user.uid}');
    try {
      final downloadUrl = await storageRef.getDownloadURL();
      setState(() {
        imageUrlPerfil = downloadUrl;
      });
    } catch (e) {
      print('Nenhuma imagem encontrada no Firebase Storage.');
    }
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
                maxLength: 300, // Limite de 280 caracteres
                maxLines: 5, // Permite várias linhas
                controller: TextEditingController(text: descricao),
                onChanged: (value) {
                  setState(() {
                    descricao = value;
                  });
                },
              ),
              ElevatedButton(
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
}
