import 'package:flutter/material.dart';

class lista_servicos extends StatelessWidget {
  const lista_servicos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: ListView(children: <Widget>[
        Container(
          child: const Center(
            child: Text(
              "Qual tipo de usuário deseja entrar?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto-Regular',
                color: Color.fromARGB(255, 155, 55, 55),
                fontSize: 28,
              ),
            ),
          ),
        ),
        TextFormField(
          keyboardType: TextInputType.datetime,
          decoration: const InputDecoration(
            labelText: "Data de Nascimento",
            labelStyle: TextStyle(
              color: Colors.black38,
              fontWeight: FontWeight.w400,
              fontSize: 20,
            ),
          ),
          style: const TextStyle(fontSize: 20),
          validator: ((value) {
            if (value == null || value.isEmpty) {
              return 'Preencha o campo de data de nascimento';
            }
            return null;
          }),
        ),
      ])),
    );
  }
}
