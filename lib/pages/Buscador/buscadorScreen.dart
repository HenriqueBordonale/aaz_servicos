import 'package:aaz_servicos/models/perfilProfi.dart';
import 'package:aaz_servicos/pages/Buscador/filtro.dart';
import 'package:aaz_servicos/pages/Buscador/perfilCard.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServicosScreen extends StatefulWidget {
  @override
  _ServicosScreenState createState() => _ServicosScreenState();
}

class _ServicosScreenState extends State<ServicosScreen> {
  List<Profile> _perfil = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar Serviços'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
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
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _perfil.length,
              itemBuilder: (context, index) {
                return ProfileCard(
                  nome: _perfil[index].nome,
                  categoria: _perfil[index].categoria,
                  especificacao: _perfil[index].especificacao,
                  avaliacao: _perfil[index].avaliacao,
                  quantidade: _perfil[index].quantidade,
                  onTao: () {},
                  imageUrl: _perfil[index].imageUrl,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FiltrosScreen(),
      ),
    );
  }

  void _getPerfis() {
    // Substitua isso com a lógica para obter perfis do Firestore
    // Aqui você deve preencher a lista _perfil com os dados dos perfis.
    // Suponhamos que você está usando o Firestore para obter os perfis.
    FirebaseFirestore.instance.collection('perfis').get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        // Mapeie os campos do documento para a classe Profile
        _perfil.add(Profile(
          nome: doc['nome'],
          categoria: doc['categoria'],
          especificacao: doc['especificacao'],
          avaliacao: doc['avaliacao'],
          quantidade: doc['quantidade'],
          imageUrl:
              doc['imageUrl'], // Suponhamos que você tenha um campo imageUrl
        ));
      });
      setState(() {
        // Atualize o estado para refletir os novos dados
      });
    });
  }
}
