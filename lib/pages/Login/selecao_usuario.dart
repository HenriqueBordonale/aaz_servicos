import 'package:aaz_servicos/pages/Login/cadastro.dart';
import 'package:aaz_servicos/pages/Login/login.dart';
import 'package:flutter/material.dart';

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
          Color.fromARGB(216, 255, 85, 33),
          Color.fromARGB(255, 201, 53, 53),
        ])),
        child: ListView(
          children: <Widget>[
            SizedBox(
              width: 204,
              height: 204,
              child: Image.asset("assets/images/LogoT.png"),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              child: const Center(
                child: Text(
                  "Qual tipo de usuário deseja entrar?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Roboto-Regular',
                    color: Color.fromARGB(255, 234, 234, 234),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 60,
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
                  "Ofertante",
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
                  "Contratante",
                  style: TextStyle(
                    color: Colors.deepOrange,
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
              height: 150,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Não tem uma conta?',
                  style: TextStyle(
                    color: Color.fromARGB(255, 234, 234, 234),
                    fontSize: 22,
                  ),
                ),
                SizedBox(width: 2)
              ],
            ),
            SizedBox(
              height: 40,
              child: TextButton(
                child: const Text(
                  "Cadastre-se",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22,
                      decoration: TextDecoration.underline,
                      color: Color.fromARGB(255, 225, 225, 226),
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
          ],
        ),
      ),
    );
  }
}
