import 'package:aaz_servicos/models/perfilProfi.dart';
import 'package:flutter/material.dart';

class Profile {
  final String nome;
  final String categoria;
  final String especificacao;
  final String imageUrl;
  final String idPerfil;
  final String genero;
  final String cidade;
  final String uf;

  Profile(
      {required this.nome,
      required this.categoria,
      required this.especificacao,
      required this.imageUrl,
      required this.idPerfil,
      required this.genero,
      required this.cidade,
      required this.uf});
}

class ProfileCard extends StatelessWidget {
  final String idPerfil;
  final String nome;
  final String categoria;
  final String especificacao;
  final VoidCallback onTao;
  final String imageUrl;

  ProfileCard({
    required this.idPerfil,
    required this.nome,
    required this.categoria,
    required this.especificacao,
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
          FutureBuilder<double?>(
            future: Perfil().calcularMediaNotas(idPerfil ?? '0'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('CARREGANDO');
              } else {
                double mediaNotas =
                    snapshot.data != null ? snapshot.data! : 0.0;

                return Row(
                  children: [
                    Text(
                      '$mediaNotas',
                      style: const TextStyle(
                        fontSize: 17,
                        color: Color.fromARGB(207, 10, 10, 10),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'inter',
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Icon(
                      Icons.star,
                      size: 22,
                      color: Color.fromARGB(255, 243, 160, 51),
                    ),
                    const SizedBox(width: 10),
                  ],
                );
              }
            },
          ),
          Text('Categoria: $categoria', style: TextStyle(fontSize: 16)),
          Text('Especificação: $especificacao', style: TextStyle(fontSize: 16)),
        ],
      ),
      onTap: onTao,
    );
  }
}
