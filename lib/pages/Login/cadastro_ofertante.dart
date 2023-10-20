import 'dart:convert';

import 'package:aaz_servicos/pages/Login/cadastro.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:aaz_servicos/pages/Login/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:aaz_servicos/models/servicos.dart';
import 'package:uuid/uuid.dart';

class CadastroOfer extends StatefulWidget {
  const CadastroOfer({super.key});

  @override
  State<CadastroOfer> createState() => _CadastroOfer();
}

Servicos minhaInstancia = Servicos();
List<String> serv = minhaInstancia.get_Servicos;

var uuid = Uuid();
String idServ = uuid.v4();

class _CadastroOfer extends State<CadastroOfer> {
  final maskCpf = MaskTextInputFormatter(
      mask: "###.###.###-##", filter: {"#": RegExp(r'[0-9]')});
  final FirebaseAuth auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  String idofer = FirebaseAuth.instance.currentUser!.uid;

  String? _selectedServ;
  String? _selectedUF; // UF selecionada
  String? _selectedCity; // Cidade selecionada
  List<String> _ufs = [];
  List<String> _cities = [];
  var especController = TextEditingController();
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
                Color.fromARGB(221, 249, 74, 16),
                Color.fromARGB(226, 236, 55, 45),
              ]),
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 60.0, left: 22),
              child: Text(
                'Preencha com\nseus dados',
                style: TextStyle(
                    fontSize: 35,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50, left: 330),
            child: IconButton(
              iconSize: 40,
              icon: const Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Cadastro(),
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
                padding: const EdgeInsets.only(left: 18, right: 18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: cpfController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [maskCpf],
                      decoration: const InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                          color: Color.fromARGB(226, 236, 55, 45),
                          width: 2,
                        )),
                        labelText: "CPF",
                        labelStyle: TextStyle(
                          color: Colors.black38,
                          fontWeight: FontWeight.w400,
                          fontSize: 17,
                        ),
                      ),
                      style: const TextStyle(fontSize: 17),
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
                      height: 20,
                    ),
                    const Text(
                        "Preencha a Unidade Federativa e cidade residente ",
                        style: TextStyle(
                            color: Color.fromARGB(255, 71, 71, 71),
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 15,
                    ),
                    DropdownButtonFormField2<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        // Add more decoration..
                      ),
                      value: _selectedUF,
                      hint: const Text(
                        'Selecione seu Estado',
                      ),
                      iconStyleData: const IconStyleData(
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Color.fromARGB(226, 236, 55, 45),
                        ),
                        iconSize: 24,
                      ),
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
                              fontSize: 17,
                            ),
                          ), // Adicione um item vazio ou de seleção padrão
                        ),
                        ..._ufs.map<DropdownMenuItem<String>>((String uf) {
                          return DropdownMenuItem<String>(
                            value: uf,
                            child: Text(
                              uf,
                              style: const TextStyle(fontSize: 17),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField2<String>(
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        // Add more decoration..
                      ),
                      isExpanded: true,
                      value: _selectedCity,
                      hint: const Text('Selecione uma cidade'),
                      iconStyleData: const IconStyleData(
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Color.fromARGB(226, 236, 55, 45),
                        ),
                        iconSize: 24,
                      ),
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
                                fontSize: 17,
                              )), // Adicione um item vazio ou de seleção padrão
                        ),
                        ..._cities.map<DropdownMenuItem<String>>((String city) {
                          return DropdownMenuItem<String>(
                            value: city,
                            child: Text(
                              city,
                              style: const TextStyle(fontSize: 17),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text("Escolha um serviço e especificação",
                        style: TextStyle(
                            color: Color.fromARGB(255, 71, 71, 71),
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 15,
                    ),
                    DropdownButtonFormField2<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        // Add more decoration..
                      ),
                      value: _selectedServ,
                      hint: const Text('Selecione seu serviço'),
                      iconStyleData: const IconStyleData(
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Color.fromARGB(226, 236, 55, 45),
                        ),
                        iconSize: 24,
                      ),
                      onChanged: (newValue) {
                        _selectedServ = newValue!;
                      },
                      items: serv.map((String service) {
                        return DropdownMenuItem<String>(
                          value: service,
                          child: Text(service),
                        );
                      }).toList(),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: especController,
                      autofocus: true,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.deepOrange,
                          width: 2,
                        )),
                        labelText: "Expecificação",
                        labelStyle: TextStyle(
                          color: Colors.black38,
                          fontSize: 17,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 17,
                      ),
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
                                  Color.fromARGB(221, 249, 74, 16),
                                  Color.fromARGB(226, 236, 55, 45),
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
                                        adicionarOfertante(
                                            cpfController.text,
                                            _selectedUF.toString(),
                                            _selectedCity.toString(),
                                            context);
                                        await Servicos().createServico(
                                            idServ,
                                            _selectedServ.toString(),
                                            especController.text,
                                            context);
                                        await Servicos()
                                            .updateIdServ(idServ)
                                            .then(
                                          (value) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => login(),
                                              ),
                                            );
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

  void adicionarOfertante(String cpf, String cidade, String uf, context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Obtém o ID do usuário atualmente autenticado
        final userId = user.uid;

        // Define os novos campos e valores que deseja adicionar ao documento do usuário
        final novosCampos = {
          'cpf': cpf,
          'cidade': cidade,
          'uf': uf,
          // Adicione mais campos e valores conforme necessário
        };

        // Atualiza o documento do usuário na coleção correspondente
        await FirebaseFirestore.instance
            .collection('user')
            .doc(userId)
            .update(novosCampos);
      } else {}
    } catch (e) {
      print('Erro ao adicionar novos campos ao documento do usuário: $e');
    }
  }
}
