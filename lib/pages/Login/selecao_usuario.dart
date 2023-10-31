import 'package:aaz_servicos/pages/Login/cadastro.dart';
import 'package:aaz_servicos/pages/Login/login.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class selecao_usuario extends StatelessWidget {
  const selecao_usuario({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(
          left: 40,
          right: 40,
        ),
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromARGB(221, 249, 74, 16),
          Color.fromARGB(226, 236, 55, 45),
        ])),
        child: ListView(
          children: <Widget>[
            SizedBox(
              width: 214,
              height: 214,
              child: Image.asset("assets/images/LogoT.png"),
            ),
            const SizedBox(
              height: 30,
            ),
            const Center(
              child: Text(
                "Faça o login ou cadastre-se para continuar!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter-Black',
                  color: Color.fromARGB(255, 234, 234, 234),
                  fontSize: 30,
                ),
              ),
            ),
            const SizedBox(
              height: 160,
            ),
            Container(
              height: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                border: Border.all(color: Colors.white),
              ),
              child: TextButton(
                child: const Text(
                  "LOGIN",
                  style: TextStyle(
                    color: Color.fromARGB(255, 234, 234, 234),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => login(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              height: 60,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 234, 234, 234),
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: TextButton(
                child: const Text(
                  "CADASTRE-SE",
                  style: TextStyle(
                    color: Color.fromARGB(226, 236, 55, 45),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
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
          ],
        ),
      ),
    );
  }
}
