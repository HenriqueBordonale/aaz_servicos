import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class Config extends StatefulWidget {
  const Config({super.key});

  @override
  State<Config> createState() => _Config();
}

class _Config extends State<Config> {
  final List<String> listGeneros = [
    'Masculino',
    'Feminino',
    'Outro',
    'Não definido',
  ];
  bool _isEditing = false;
  String? selectedValue;
  TextEditingController generoController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  File? imageFile;
  final picker = ImagePicker();
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _checkIfImageExists();
  }

  CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection("user");

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('Usuário não autenticado.');
      return;
    }

    try {
      final snapshot = await _collectionReference.doc(user.uid).get();
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          _nameController.text = data['nome'];
          _emailController.text = data['email'];
          generoController.text = data['genero'];
          // Configure outros campos aqui
        });
      }
    } catch (error) {
      print('Erro ao carregar dados do usuário: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(221, 249, 74, 16),
        title: const Text('Configurações'),
      ),
      body: SingleChildScrollView(
        child: Column(
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
              height: 15,
            ),
            InkWell(
              onTap: () async {
                await _pickImage(ImageSource.gallery);
              },
              child: (imageFile != null || imageUrl != null)
                  ? imageFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(
                              75), // Define o raio para tornar a imagem circular
                          child: Image.file(
                            imageFile!,
                            fit: BoxFit.cover,
                            width: 150,
                            height: 150,
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(75),
                          child: Image.network(
                            imageUrl!,
                            fit: BoxFit.cover,
                            width: 150,
                            height: 150,
                          ),
                        )
                  : const Icon(Icons.account_circle,
                      color: Color.fromARGB(255, 64, 64, 64), size: 150),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    enabled: _isEditing,
                    decoration: InputDecoration(labelText: 'Nome'),
                  ),
                  TextField(
                    controller: _emailController,
                    enabled: _isEditing,
                    decoration: InputDecoration(labelText: 'E-mail'),
                  ), //
                  IgnorePointer(
                    ignoring: !_isEditing,
                    child: DropdownButtonFormField2<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        // Add more decoration..
                      ),
                      hint: const Text(
                        'Selecione seu gênero',
                        style: TextStyle(
                          fontSize: 19,
                          color: Colors.grey,
                        ),
                      ),
                      items: listGeneros
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 68, 68, 68),
                                    fontSize: 19,
                                  ),
                                ),
                              ))
                          .toList(),
                      validator: (value) {
                        if (value == null) {
                          return 'Selecione seu gênero';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        generoController.text = value.toString();
                      },
                      onSaved: (value) {
                        selectedValue = value.toString();
                      },
                      buttonStyleData: const ButtonStyleData(
                        padding: EdgeInsets.only(right: 8),
                      ),
                      iconStyleData: const IconStyleData(
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Color.fromARGB(226, 236, 55, 45),
                        ),
                        iconSize: 24,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_isEditing) {
                  // Chame o método de salvamento aqui
                  _updateUserData();
                } else {
                  setState(() {
                    // Inverte o estado de edição
                    _isEditing = true;
                  });
                }
              },
              child: Text(_isEditing ? 'Salvar' : 'Editar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
      await uploadImage(imageFile!);
    }
  }

  Future<void> uploadImage(File imageFile) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('Usuário não autenticado.');
      return;
    }

    final storage = FirebaseStorage.instance;
    final folderRef =
        storage.ref().child('user_images/profile_images/${user.uid}');

    // Exclua a imagem existente na pasta, se houver
    try {
      await folderRef.delete();
    } catch (e) {
      print('Nenhuma imagem para excluir.');
    }

    // Faça o upload da nova imagem
    try {
      await folderRef.putFile(imageFile);
      print('Imagem enviada com sucesso.');
    } catch (error) {
      print('Erro ao enviar a imagem: $error');
    }
  }

  Future<void> _checkIfImageExists() async {
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
        imageUrl = downloadUrl;
      });
    } catch (e) {
      print('Nenhuma imagem encontrada no Firebase Storage.');
    }
  }

  Future<void> _updateUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('Usuário não autenticado.');
      return;
    }

    try {
      final docRef = _collectionReference.doc(user.uid);

      // Crie um novo mapa para os dados atualizados
      final updatedData = <String, dynamic>{};

      // Atualize apenas os campos que foram editados
      if (_nameController.text.isNotEmpty) {
        updatedData['nome'] = _nameController.text;
      }

      if (_emailController.text.isNotEmpty) {
        updatedData['email'] = _emailController.text;
      }
      if (generoController.text.isEmpty) {
        updatedData['genero'] = generoController.text;
      }

      // Adicione outros campos conforme necessário
      // Exemplo:
      // if (_newFieldController.text.isNotEmpty) {
      //   updatedData['newField'] = _newFieldController.text;
      // }

      // Atualize os dados no Firestore
      await docRef.set(updatedData, SetOptions(merge: true));
      setState(() {
        _isEditing = false;
      });

      print('Dados do usuário atualizados com sucesso.');
    } catch (error) {
      print('Erro ao atualizar os dados do usuário: $error');
    }
  }
}
