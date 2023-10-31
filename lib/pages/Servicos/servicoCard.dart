import 'package:flutter/material.dart';

class Servico {
  final String nome;
  final String especificacao;
  final String idServico; // Adicione o campo idServico

  Servico({
    required this.nome,
    required this.especificacao,
    required this.idServico,
  });
}

class ServicoCard extends StatelessWidget {
  final String nome;
  final String especificacao;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback
      onCadastrarPerfil; // Callback para o botão "Cadastrar Perfil"

  ServicoCard({
    required this.nome,
    required this.especificacao,
    required this.onDelete,
    required this.onEdit,
    required this.onCadastrarPerfil,
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
            onPressed: onCadastrarPerfil,
            style: ElevatedButton.styleFrom(
              primary: Colors.deepOrange, // Cor DeepOrange
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    30), // Ajuste o valor conforme desejado
              ),
            ),
            child: Text(
              'Cadastrar Perfil',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
