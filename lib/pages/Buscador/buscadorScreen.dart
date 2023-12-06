import 'package:aaz_servicos/pages/Buscador/mostrarPerfil.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aaz_servicos/pages/Buscador/filtro.dart';
import 'package:aaz_servicos/pages/Buscador/perfilCard.dart';
import 'package:aaz_servicos/models/perfilProfi.dart';

class ServicosScreen extends StatefulWidget {
  @override
  _ServicosScreenState createState() => _ServicosScreenState();
}

class _ServicosScreenState extends State<ServicosScreen> {
  List<Profile> _perfisExibidos = [];
  final List<Profile> _todosPerfis = [];

  @override
  void initState() {
    super.initState();
    _getPerfis();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Buscar Serviços',
          style: TextStyle(fontSize: 25, fontFamily: 'inter'),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(221, 249, 74, 16),
                Color.fromARGB(226, 236, 55, 45),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterScreen();
            },
          ),
        ],
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
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _perfisExibidos.length,
              itemBuilder: (context, index) {
                return ProfileCard(
                  nome: _perfisExibidos[index].nome,
                  categoria: _perfisExibidos[index].categoria,
                  especificacao: _perfisExibidos[index].especificacao,
                  onTao: () async {
                    String idPerfilSelecionado =
                        _perfisExibidos[index].idPerfil;

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MostrarPerfil(
                          idPerfil: idPerfilSelecionado,
                        ),
                      ),
                    );
                  },
                  imageUrl: _perfisExibidos[index].imageUrl,
                  idPerfil: _perfisExibidos[index].idPerfil,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterScreen() async {
    Map<String, dynamic>? filtros = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FiltrosScreen(),
      ),
    );

    if (filtros != null) {
      _aplicarFiltros(filtros);
    }
  }

  void _getPerfis() {
    FirebaseFirestore.instance.collection('perfis').get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        String nome = doc['nome'];
        String categoria = doc['categoria'];
        String especificacao = doc['especificacao'];
        String imageUrl = doc['imageUrl'];
        String genero = doc['genero'];
        String cidade = doc['cidade'];
        String uf = doc['uf'];
        String idPerfil = doc.id;

        _todosPerfis.add(Profile(
          nome: nome,
          categoria: categoria,
          especificacao: especificacao,
          imageUrl: imageUrl,
          idPerfil: idPerfil,
          cidade: cidade,
          genero: genero,
          uf: uf,
        ));
      });
      _perfisExibidos = List.from(_todosPerfis);
      setState(() {});
    });
  }

  void _aplicarFiltros(Map<String, dynamic> filtros) {
    if (filtros.isNotEmpty) {
      List<Profile> perfisFiltrados = _todosPerfis.where((perfil) {
        return _perfilAtendeFiltros(perfil, filtros);
      }).toList();

      if (perfisFiltrados.isEmpty) {
        _exibirMensagem(
            "Não correspondem perfis com esses parâmetros de busca");
        _perfisExibidos = [];
      } else {
        _perfisExibidos = perfisFiltrados;
      }
    } else {
      // Caso nenhum filtro seja fornecido, exibir todos os perfis
      _perfisExibidos = List.from(_todosPerfis);
    }

    setState(() {});
  }

  bool _perfilAtendeFiltros(Profile perfil, Map<String, dynamic> filtros) {
    if (filtros.isEmpty) {
      return true; // Retorna verdadeiro se não houver filtros
    }

    return filtros.entries.every((filtro) {
      var filtroKey = filtro.key;
      var filtroValue = filtro.value;

      if (filtroValue != null && filtroValue.toString().isNotEmpty) {
        var valorPerfil = perfilToJson(perfil, filtroKey);
        return valorPerfil.toString() == filtroValue.toString();
      }

      return true; // Se o filtro não for preenchido, considera como atendido
    });
  }

  dynamic perfilToJson(Profile perfil, String key) {
    switch (key) {
      case 'nome':
        return perfil.nome;
      case 'categoria':
        return perfil.categoria;
      case 'especificacao':
        return perfil.especificacao;
      case 'genero':
        return perfil.genero;
      case 'cidade':
        return perfil.cidade;
      case 'uf':
        return perfil.uf;
      default:
        return null;
    }
  }

  void _exibirMensagem(String mensagem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(mensagem),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
