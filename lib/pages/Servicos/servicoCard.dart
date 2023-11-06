import 'package:flutter/material.dart';

class Servico {
  final String nome;
  final String especificacao;
  final String idServico;
  final String idPerfil;

  Servico(
      {required this.nome,
      required this.especificacao,
      required this.idServico,
      required this.idPerfil});
}

class ServicoCard extends StatelessWidget {
  final String nome;
  final String especificacao;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onCadastrarPerfil;
  final String idPerfil; // Alterado para String? para aceitar null

  ServicoCard({
    required this.nome,
    required this.especificacao,
    required this.onDelete,
    required this.onEdit,
    required this.onCadastrarPerfil,
    required this.idPerfil, // Atualizado para aceitar String? ou null
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
                      color: Color.fromARGB(255, 49, 49, 49),
                    ),
                    onPressed: onEdit,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Color.fromARGB(
                          202, 204, 31, 31), // Cor do ícone de exclusão
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Confirmação de Exclusão'),
                            content: Text(
                                'Tem certeza de que deseja excluir este item?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Fecha o AlertDialog
                                },
                                child: Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Adicione aqui a lógica para exclusão do item
                                  onDelete();
                                  Navigator.of(context)
                                      .pop(); // Fecha o AlertDialog
                                },
                                child: Text('Confirmar'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          left: 20,
          bottom: 14,
          child: ElevatedButton(
            onPressed: onCadastrarPerfil,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                idPerfil == ''
                    ? const Color.fromARGB(208, 255, 153, 0)
                    : const Color.fromARGB(212, 76, 175, 79),
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      10.0), // Ajuste o valor conforme necessário
                ),
              ),
            ),
            child: Text(
              idPerfil == '' ? 'Criar Perfil' : 'Editar Perfil',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
