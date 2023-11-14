import 'package:flutter/material.dart';

class Profile {
  final String nome;
  final String categoria;
  final String especificacao;
  // final double avaliacao;
  // final double quantidade;
  final String imageUrl;
  final String idPerfil;
  final String genero;
  final String cidade;
  final String uf;

  Profile(
      {required this.nome,
      required this.categoria,
      required this.especificacao,
      // required this.avaliacao,
      // required this.quantidade,
      required this.imageUrl,
      required this.idPerfil,
      required this.genero,
      required this.cidade,
      required this.uf});
}

class ProfileCard extends StatelessWidget {
  final String nome;
  final String categoria;
  final String especificacao;
  // final double avaliacao;
  //final double quantidade;
  final VoidCallback onTao;
  final String imageUrl;

  ProfileCard({
    required this.nome,
    required this.categoria,
    required this.especificacao,
    // required this.avaliacao,
    // required this.quantidade,
    required this.onTao,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(8),
      leading: CircleAvatar(
        radius: 35, // Tamanho da imagem de perfil
        backgroundImage: NetworkImage(
            imageUrl), // Carregue a imagem de perfil a partir do URL
      ),
      title: Text(
        nome,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Avaliação: 4.5', style: TextStyle(fontSize: 16)),
          Text('Categoria: $categoria', style: TextStyle(fontSize: 16)),
          Text('Especificação: $especificacao', style: TextStyle(fontSize: 16)),
        ],
      ),
      onTap: onTao,
    );
  }
}
