import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Config extends StatefulWidget {
  const Config({super.key});

  @override
  State<Config> createState() => _Config();
}

class _Config extends State<Config> {
  CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection("servicos");
  @override
  bool servcad = false;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(221, 249, 74, 16),
        title: const Text('Configurações'),
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(
              top: 40,
            ),
            child: const Text(
              'Minha Conta',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color.fromARGB(255, 37, 37, 37),
                  fontFamily: 'Inter',
                  fontSize: 30),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          IconButton(
            onPressed: () async {
              await _pickImage(ImageSource
                  .gallery); // Chame a função _pickImage para selecionar uma imagem da galeria
            },
            icon: Icon(Icons.account_circle),
            color: const Color.fromARGB(255, 64, 64, 64),
            iconSize: 150,
          ),
          ListView(
            children: [
              TextFormField(),
            ],
          ),
        ],
      ),
    );
  }

  File? _imageFile;
  final picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile != null) {
      try {
        final user = FirebaseAuth.instance.currentUser;
        final storageRef = FirebaseStorage.instance.ref().child(
            'images/${user!.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg');

        await storageRef.putFile(_imageFile!);

        final imageUrl = await storageRef.getDownloadURL();

        // Aqui você pode salvar o URL da imagem no Firestore ou em outro lugar conforme necessário.
      } catch (error) {
        print('Erro ao enviar a imagem: $error');
      }
    } else {
      print('Nenhuma imagem selecionada');
    }
  }
}
