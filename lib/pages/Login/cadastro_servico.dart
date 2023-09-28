import 'dart:collection';
import 'dart:convert';
import 'dart:ui';

import 'package:http/http.dart' as http;
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:aaz_servicos/models/auth.dart';
import 'package:aaz_servicos/pages/Login/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aaz_servicos/models/usuarios.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class cadastro_servico extends StatefulWidget {
  const cadastro_servico({super.key});

  @override
  State<cadastro_servico> createState() => _Cadastroserv();
}

class _Cadastroserv extends State<cadastro_servico> {
  final maskCpf = MaskTextInputFormatter(
      mask: "###.###.###-##", filter: {"#": RegExp(r'[0-9]')});
  final FirebaseAuth auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection("usernutri");

  String idofer = FirebaseAuth.instance.currentUser!.uid;

  String? _selectedUF; // UF selecionada
  String? _selectedCity; // Cidade selecionada
  List<String> _ufs = [];
  List<String> _cities = [];
  @override
  void initState() {
    super.initState();
    // Inicializar as UFs
    _loadUFs();
  }

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

  var cpfController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        key: _formKey,
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromARGB(216, 255, 85, 33),
                Color.fromARGB(255, 201, 53, 53),
              ]),
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 60.0, left: 22),
              child: Text(
                'Preencha com\nseus dados',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 35, left: 320),
            child: IconButton(
              iconSize: 40,
              icon: const Icon(Icons.arrow_circle_left),
              color: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => login(),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)),
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    TextFormField(
                      controller: cpfController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [maskCpf],
                      decoration: const InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.deepOrange,
                          width: 2,
                        )),
                        labelText: "CPF",
                        labelStyle: TextStyle(
                          color: Colors.black38,
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                        ),
                      ),
                      style: const TextStyle(fontSize: 20),
                      validator: ((value) {
                        if (value == null || value.isEmpty) {
                          return 'Preencha o campo de CPF';
                        } else if (!CPFValidator.isValid(value)) {
                          return 'Digite um CPF válido!';
                        }
                        return null;
                      }),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedUF,
                      hint: const Text('Selecione seu Estado'),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedUF = newValue!;
                          _selectedCity = null; // Limpar a cidade selecionada
                          _loadCities(
                              newValue); // Carregar cidades da UF selecionada
                        });
                      },
                      items: <DropdownMenuItem<String>>[
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text(
                            'Selecione uma UF',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 20,
                            ),
                          ), // Adicione um item vazio ou de seleção padrão
                        ),
                        ..._ufs.map<DropdownMenuItem<String>>((String uf) {
                          return DropdownMenuItem<String>(
                            value: uf,
                            child: Text(uf),
                          );
                        }).toList(),
                      ],
                    ),
                    const SizedBox(height: 10),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedCity,
                      hint: const Text('Selecione uma cidade'),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedCity = newValue!;
                        });
                      },
                      items: <DropdownMenuItem<String>>[
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text('Selecione uma cidade',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 20,
                              )), // Adicione um item vazio ou de seleção padrão
                        ),
                        ..._cities.map<DropdownMenuItem<String>>((String city) {
                          return DropdownMenuItem<String>(
                            value: city,
                            child: Text(
                              city,
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0, right: 18),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 55,
                              width: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                gradient: const LinearGradient(colors: [
                                  Color.fromARGB(216, 255, 85, 33),
                                  Color.fromARGB(255, 201, 53, 53),
                                ]),
                              ),
                              child: SizedBox.expand(
                                child: TextButton(
                                    child: const Text(
                                      'CADASTRAR',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.white),
                                    ),
                                    onPressed: () async {
                                      try {
                                        await Usuarios()
                                            .createOfer(
                                                idofer.toString(),
                                                cpfController.text,
                                                _selectedUF.toString(),
                                                _selectedCity.toString(),
                                                context)
                                            .then(
                                          (value) {
                                            Navigator.pop(context);
                                          },
                                        );
                                      } catch (e) {
                                        print('Error: $e');
                                      }
                                      //criarConta(txtNome.text ,txtEmail.text, txtSenha.text, txtTelefone.text, txtDataNascimento.text, txtCpf.text, txtCodigoNutricionista.text ?? "", context);
                                    }),
                              ),
                            ),
                          ]),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
