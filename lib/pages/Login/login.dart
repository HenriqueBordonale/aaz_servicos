import 'package:firebase_auth/firebase_auth.dart';
import 'package:aaz_servicos/pages/Login/cadastro.dart';
import 'package:aaz_servicos/pages/Login/selecao_usuario.dart';
import 'package:flutter/material.dart';

class login extends StatelessWidget {
  const login({super.key});

  @override
  Widget build(BuildContext context) {
    var txtEmail = TextEditingController();
    var txtSenha = TextEditingController();

    return Scaffold(
        body: Stack(
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color.fromARGB(216, 255, 85, 33),
              Color.fromARGB(255, 201, 53, 53),
            ]),
          ),
          child: const Padding(
            padding: EdgeInsets.only(top: 60.0, left: 20),
            child: Text(
              'Olá, seja \nbem vindo!',
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 35, left: 320),
          child: IconButton(
            iconSize: 40,
            icon: const Icon(Icons.arrow_circle_left),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const selecao_usuario(),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 200.0),
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
              color: Colors.white,
            ),
            height: double.infinity,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    controller: txtEmail,
                    autofocus: true, //-----------------
                    keyboardType:
                        TextInputType.emailAddress, //-----------------
                    decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.check,
                          color: Color.fromARGB(255, 103, 101, 101),
                        ),
                        label: Text(
                          'E-mail',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 103, 101, 101),
                          ),
                        )),
                  ),
                  TextFormField(
                    controller: txtSenha,
                    autofocus: true,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.visibility_off,
                          color: Color.fromARGB(255, 103, 101, 101),
                        ),
                        label: Text(
                          'Senha',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 103, 101, 101),
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Esqueceu a senha?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 70,
                  ),
                  Container(
                    height: 55,
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      gradient: const LinearGradient(colors: [
                        Color.fromARGB(216, 255, 85, 33),
                        Color.fromARGB(255, 201, 53, 53),
                      ]),
                    ),
                    child: TextButton(
                      child: const Text(
                        "ENTRAR",
                        style: TextStyle(
                          color: Color.fromARGB(255, 234, 234, 234),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(
                    height: 150,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Não tem uma conta?',
                        style: TextStyle(
                          color: Color.fromARGB(255, 2, 2, 2),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 690, left: 140),
          child: SizedBox(
            height: 40,
            child: TextButton(
              child: const Text(
                "Cadastre-se",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Cadastro(),
                  ),
                );
              },
            ),
          ),
        )
      ],
    ));
  }
}
