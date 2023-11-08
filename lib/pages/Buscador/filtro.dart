import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FiltrosScreen extends StatefulWidget {
  @override
  _FiltrosScreenState createState() => _FiltrosScreenState();
}

class _FiltrosScreenState extends State<FiltrosScreen> {
  // Variáveis para armazenar os filtros selecionados
  String? tipoServicoSelecionado;
  String? especificacaoSelecionada;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecionar Filtros'),
      ),
      body: Column(
        children: [
          // UI para selecionar filtros, como dropdowns para tipo de serviço e especificação
          // Exemplo:
          // DropdownButton<String>(
          //   value: tipoServicoSelecionado,
          //   onChanged: (String? newValue) {
          //     setState(() {
          //       tipoServicoSelecionado = newValue;
          //     });
          //   },
          //   items: <String>['Tipo 1', 'Tipo 2', 'Tipo 3']
          //       .map<DropdownMenuItem<String>>((String value) {
          //     return DropdownMenuItem<String>(
          //       value: value,
          //       child: Text(value),
          //     );
          //   }).toList(),
          // ),
          // Adicione UI para outros filtros, como especificação.

          // Botão "Aplicar Filtro"
          ElevatedButton(
            onPressed: () {
              // Quando o botão "Aplicar Filtro" for pressionado, retorne os filtros selecionados
              // para a tela principal
              Navigator.pop(context, {
                'tipoServico': tipoServicoSelecionado,
                'especificacao': especificacaoSelecionada,
              });
            },
            child: Text('Aplicar Filtro'),
          ),
        ],
      ),
    );
  }
}
