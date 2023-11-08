import 'package:flutter/material.dart';

class Profile {
  final String nome;
  final String categoria;
  final String especificacao;
  final double avaliacao;
  final double quantidade;
  final String imageUrl;

  Profile({
    required this.nome,
    required this.categoria,
    required this.especificacao,
    required this.avaliacao,
    required this.quantidade,
    required this.imageUrl,
  });
}

class ProfileCard extends StatelessWidget {
  final String nome;
  final String categoria;
  final String especificacao;
  final double avaliacao;
  final double quantidade;
  final VoidCallback onTao;
  final String imageUrl; // Adicione o URL da imagem de perfil

  ProfileCard({
    required this.nome,
    required this.categoria,
    required this.especificacao,
    required this.avaliacao,
    required this.quantidade,
    required this.onTao,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(8),
      leading: CircleAvatar(
        radius: 30, // Tamanho da imagem de perfil
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
          Text('Especificação: $especificacao', style: TextStyle(fontSize: 16)),
          Text('Categoria: $categoria', style: TextStyle(fontSize: 16)),
          Text('Avaliação: $avaliacao', style: TextStyle(fontSize: 16)),
          Text('Quantidade: $quantidade', style: TextStyle(fontSize: 16)),
        ],
      ),
      onTap: onTao,
    );
  }
}
