import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:aaz_servicos/models/auth.dart';

import '../Login/esqueceu_senha.dart';

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
  TextEditingController nameController = TextEditingController();
  String? _selectedUF; // UF selecionada
  String? _selectedCity;
  File? imageFile;
  final picker = ImagePicker();
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    _loadUFs();
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
          nameController.text = data['nome'];
          generoController.text = data['genero'];
          _selectedUF = data['uf'];
          _selectedCity = data['cidade'];
          if (_selectedUF != null) {
            _loadCities(
                _selectedUF!); // Carregue as cidades apenas se _selectedUF não for nulo
          }
        });
      }
    } catch (error) {
      print('Erro ao carregar dados do usuário: $error');
    }
  }

  List<String> _ufs = [];
  List<String> _cities = [];
  var especController = TextEditingController();

  // Carregar a lista de UFs
  Future<void> _loadUFs() async {
    final response = await http.get(
      Uri.parse('https://servicodados.ibge.gov.br/api/v1/localidades/estados'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _ufs = data.map((uf) => uf['sigla']).cast<String>().toList();
      });
    } else {
      throw Exception('Falha ao buscar UFs');
    }
  }

  // Carregar a lista de cidades de uma UF específica
  Future<void> _loadCities(String uf) async {
    final response = await http.get(
      Uri.parse(
          'https://servicodados.ibge.gov.br/api/v1/localidades/estados/$uf/municipios'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _cities = data.map((city) => city['nome']).cast<String>().toList();
      });
    } else {
      throw Exception('Falha ao buscar cidades');
    }
  }

  InputDecoration _getDropdownInputDecoration(bool isEnabled) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: isEnabled
              ? Color.fromARGB(226, 236, 55, 45)
              : Colors
                  .grey, // Defina a cor quando estiver habilitado e desabilitado
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(221, 249, 74, 16),
        title: const Text('Configurações'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.only(
                top: 30,
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
                    controller: nameController,
                    enabled: _isEditing,
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      labelStyle: TextStyle(
                        color: Colors.black38,
                        fontSize: 19,
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: Color.fromARGB(226, 236, 55, 45),
                        width: 2,
                      )),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  AbsorbPointer(
                    absorbing: !_isEditing,
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
                      hint: Text(
                        generoController.text,
                        style: TextStyle(
                          fontSize: 17,
                          color: _isEditing
                              ? Colors.black
                              : Colors
                                  .grey, // Defina a cor com base em _isEditing
                        ),
                      ),
                      items: listGeneros
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: _isEditing
                                        ? Colors.black
                                        : Colors
                                            .grey, // Defina a cor com base em _isEditing
                                  ),
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        generoController.text = value.toString();
                      },
                      onSaved: (value) {
                        selectedValue = value.toString();
                      },
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
                        padding: EdgeInsets.symmetric(horizontal: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 363,
              child: AbsorbPointer(
                absorbing: !_isEditing,
                child: DropdownButtonFormField2<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    // Add more decoration..
                  ),
                  hint: Text("Selecione uma UF"),
                  iconStyleData: const IconStyleData(
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Color.fromARGB(226, 236, 55, 45),
                    ),
                    iconSize: 24,
                  ),
                  value: _selectedUF,
                  menuItemStyleData: const MenuItemStyleData(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      if (_isEditing) {
                        _selectedUF = newValue!;
                        _selectedCity = null; // Limpar a cidade selecionada
                        _loadCities(
                            newValue); // Carregar cidades da UF selecionada
                      }
                    });
                  },
                  items: _ufs.map<DropdownMenuItem<String>>((String uf) {
                    return DropdownMenuItem<String>(
                      value: uf,
                      child: Text(
                        uf,
                        style: TextStyle(
                          fontSize: 17,
                          color: _isEditing
                              ? Colors.black
                              : Colors
                                  .grey, // Defina a cor com base em _isEditing
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: 365,
              child: AbsorbPointer(
                absorbing: !_isEditing,
                child: DropdownButtonFormField2<String>(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    // Add more decoration..
                  ),
                  isExpanded: true,
                  hint: Text("Selecione uma cidade"),
                  iconStyleData: const IconStyleData(
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Color.fromARGB(226, 236, 55, 45),
                    ),
                    iconSize: 24,
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                  ),
                  value: _selectedCity,
                  onChanged: (newValue) {
                    setState(() {
                      if (_isEditing) {
                        _selectedCity = newValue!;
                      }
                    });
                  },
                  items: _cities.map<DropdownMenuItem<String>>((String city) {
                    return DropdownMenuItem<String>(
                      value: city,
                      child: Text(
                        city,
                        style: TextStyle(
                          fontSize: 17,
                          color: _isEditing
                              ? Colors.black
                              : Colors
                                  .grey, // Defina a cor com base em _isEditing
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 55,
              width: 300,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                gradient: LinearGradient(colors: [
                  Color.fromARGB(221, 249, 74, 16),
                  Color.fromARGB(226, 236, 55, 45),
                ]),
              ),
              child: TextButton(
                child: Text(
                  _isEditing ? 'Salvar' : 'Editar',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 234, 234, 234),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
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
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              height: 55,
              width: 300,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                gradient: LinearGradient(colors: [
                  Color.fromARGB(221, 249, 74, 16),
                  Color.fromARGB(226, 236, 55, 45),
                ]),
              ),
              child: TextButton(
                child: Text(
                  'Alterar senha',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 234, 234, 234),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => esqueceu_senha(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              height: 55,
              width: 300,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                gradient: LinearGradient(colors: [
                  Color.fromARGB(221, 249, 74, 16),
                  Color.fromARGB(226, 236, 55, 45),
                ]),
              ),
              child: TextButton(
                child: const Text(
                  'Sair',
                  style: TextStyle(
                    color: Color.fromARGB(255, 234, 234, 234),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                onPressed: () async {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, 'login');
                },
              ),
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
      if (nameController.text.isNotEmpty) {
        updatedData['nome'] = nameController.text;
      }

      if (generoController.text.isNotEmpty) {
        updatedData['genero'] = generoController.text;
      }

      if (_selectedUF.toString().isNotEmpty) {
        updatedData['uf'] = _selectedUF.toString();
      }
      if (_selectedCity.toString().isNotEmpty) {
        updatedData['cidade'] = _selectedCity.toString();
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
