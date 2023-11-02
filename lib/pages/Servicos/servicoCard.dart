import 'package:flutter/material.dart';

class Servico {
  final String nome;
  final String especificacao;
  final String idServico;
  final String idPerfil;

  Servico({
    required this.nome,
    required this.especificacao,
    required this.idServico,
    this.idPerfil = 'inexistente', // Use 'inexistente' como valor padrão
  });
}

class ServicoCard extends StatelessWidget {
  final String nome;
  final String especificacao;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onCadastrarPerfil;
  final String? idPerfil; // Alterado para String? para aceitar null

  ServicoCard({
    required this.nome,
    required this.especificacao,
    required this.onDelete,
    required this.onEdit,
    required this.onCadastrarPerfil,
    this.idPerfil, // Atualizado para aceitar String? ou null
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      // Usamos um Stack para sobrepor o botão sobre o card
      children: [
        Container(
          width: 350,
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white, // Cor de fundo
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('Especificação: $especificacao',
                        style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
              Divider(
                color: Colors.grey, // Adicione uma linha divisória
              ),
              SizedBox(height: 5), // Adicione um espaço após o Divider
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
        ),
        Positioned(
          left: 16,
          bottom: 10,
          child: ElevatedButton(
            onPressed: idPerfil != null ? onEdit : onCadastrarPerfil,
            child: Text(idPerfil != null
                ? 'Editar Perfil'
                : 'Criar Perfil'), // Mude o texto com base em idPerfil
          ),
        ),
      ],
    );
  }
}
