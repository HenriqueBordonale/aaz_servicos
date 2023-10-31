import 'dart:io';

import 'package:aaz_servicos/models/perfilProfi.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class perfilprofissional extends StatefulWidget {
  const perfilprofissional({super.key});

  @override
  State<perfilprofissional> createState() => _perfilprofissional();
}

class _perfilprofissional extends State<perfilprofissional> {
  String? imageUrlPerfil;
  String? descricao;

  String? imageUrlMidia;

  List<String> photoUrlsMidia = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    Perfil().consultarDocUser(onDataReceivedToUser);
    Perfil().consultarDocServico(onDataReceivedToServico);
    loadProfileImage();
    loadUserPhotos();
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
      ),
      body: SingleChildScrollView(
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
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$nome',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text('CARREGANDO'),
                      Text('$servico'),
                      Text('$especificacao'),
                      Text('$cidade - $uf'),
                      Text('CARREGANDO'),
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
              padding: const EdgeInsets.all(16.0),
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
            Text(
              '$descricao',
              style: TextStyle(fontSize: 15),
            ),
            const Divider(
              height: 30,
              thickness: 0.5,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
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
                  // Manter o GridView.builder aqui
                  GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: photoUrlsMidia.length,
                    itemBuilder: (context, index) {
                      return Image.network(photoUrlsMidia[index]);
                    },
                  ),
                ],
              ),
            ),
            const Divider(
              height: 30,
              thickness: 0.5,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ],
        ),
      ),
    );
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
