import 'package:flutter/material.dart';

class Perfil {
  final String nome;
  final String especificacao;
  final String idServico;
  final String idUser;

  Perfil({
    required this.nome,
    required this.especificacao,
    required this.idServico,
    required this.idUser,
  });
}

class PerfilCard extends StatelessWidget {
  final String nome;
  final String especificacao;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onActived;

  PerfilCard({
    required this.nome,
    required this.especificacao,
    required this.onDelete,
    required this.onEdit,
    required this.onActived,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 32, 32, 31), // Cor de fundo
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nome: $nome',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('Especificação: $especificacao',
                    style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
          Divider(
            color: Color.fromARGB(
                255, 142, 142, 142), // Adicione uma linha divisória
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Color.fromARGB(255, 63, 62, 62),
                ),
                onPressed: onEdit,
              ),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Color.fromARGB(
                      255, 182, 25, 25), // Cor do ícone de exclusão
                ),
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
