import 'dart:convert';
import 'package:aaz_servicos/models/servicos.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class FiltrosScreen extends StatefulWidget {
  @override
  _FiltrosScreenState createState() => _FiltrosScreenState();
}

Servicos minhaInstancia = Servicos();
List<String> serv = minhaInstancia.get_Servicos;

class _FiltrosScreenState extends State<FiltrosScreen> {
  final List<String> listGeneros = [
    'Masculino',
    'Feminino',
    'Outro',
    'Não definido',
  ];
  String? generoSelected;
  String? servicoSelected;
  var especController = TextEditingController();
  TextEditingController generoController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  String? _selectedUF; // UF selecionada
  String? _selectedCity;
  List<String> _ufs = [];
  List<String> _cities = [];
  @override
  void initState() {
    super.initState();
    _loadUFs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Selecione os Filtros',
          style: TextStyle(fontSize: 25, fontFamily: 'inter'),
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
      body: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
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
                TextField(
                  controller: especController,
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.deepOrange,
                      width: 2,
                    )),
                    labelText: "Expecificação",
                    labelStyle: TextStyle(
                      color: Colors.black38,
                      fontSize: 19,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: 363,
                  child: DropdownButtonFormField2<String>(
                    isExpanded: true,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      // Add more decoration..
                    ),
                    hint: const Text(
                      'Selecione seu gênero',
                    ),
                    value: generoSelected,
                    items: listGeneros
                        .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                              ),
                            ))
                        .toList(),
                    onChanged: (newValue) {
                      setState(() {
                        generoSelected = newValue!;
                      });
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
                const SizedBox(
                  height: 15,
                ),
                DropdownButtonFormField2<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    // Add more decoration..
                  ),
                  value: servicoSelected,
                  hint: const Text('Selecione seu serviço'),
                  iconStyleData: const IconStyleData(
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Color.fromARGB(226, 236, 55, 45),
                    ),
                    iconSize: 24,
                  ),
                  onChanged: (newValue) {
                    servicoSelected = newValue!;
                  },
                  items: serv.map((String service) {
                    return DropdownMenuItem<String>(
                      value: service,
                      child: Text(service),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 363,
            child: DropdownButtonFormField2<String>(
              isExpanded: true,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                // Add more decoration..
              ),
              hint: const Text("Selecione uma UF"),
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
                  _selectedUF = newValue!;
                  _selectedCity = null; // Limpar a cidade selecionada
                  _loadCities(newValue); // Carregar cidades da UF selecionada
                });
              },
              items: _ufs.map<DropdownMenuItem<String>>((String uf) {
                return DropdownMenuItem<String>(
                  value: uf,
                  child: Text(
                    uf,
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            width: 363,
            child: DropdownButtonFormField2<String>(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 15),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                // Add more decoration..
              ),
              isExpanded: true,
              hint: const Text("Selecione uma cidade"),
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
                  _selectedCity = newValue!;
                });
              },
              items: _cities.map<DropdownMenuItem<String>>((String city) {
                return DropdownMenuItem<String>(
                  value: city,
                  child: Text(
                    city,
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(
            height: 25,
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
              onPressed: () {
                Map<String, dynamic> filtros = {
                  'categoria': servicoSelected != null
                      ? servicoSelected.toString()
                      : null,
                  'especificacao': especController.text,
                  'genero':
                      generoSelected != null ? generoSelected.toString() : null,
                  'uf': _selectedUF != null ? _selectedUF.toString() : null,
                  'cidade':
                      _selectedCity != null ? _selectedCity.toString() : null,
                  'nome': nameController.text,
                };

                Navigator.pop(context, filtros);
              },
              child: const Text(
                'Aplicar Filtro',
                style: TextStyle(
                  color: Color.fromARGB(255, 234, 234, 234),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

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
        'https://servicodados.ibge.gov.br/api/v1/localidades/estados/$uf/municipios',
      ),
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
}
