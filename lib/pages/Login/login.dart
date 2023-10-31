import 'package:aaz_servicos/pages/Login/esqueceu_senha.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aaz_servicos/pages/Login/cadastro.dart';
import 'package:aaz_servicos/pages/Login/selecao_usuario.dart';
import 'package:flutter/material.dart';
import 'package:aaz_servicos/models/auth.dart';

class login extends StatelessWidget {
  login({super.key});

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var senhaController = TextEditingController();
    return Scaffold(
        body: Stack(
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color.fromARGB(221, 249, 74, 16),
              Color.fromARGB(226, 236, 55, 45),
            ]),
          ),
          child: const Padding(
            padding: EdgeInsets.only(top: 60.0, left: 20),
            child: Text(
              'Olá, seja \nbem vindo!',
              style: TextStyle(
                  fontSize: 35,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 50, left: 330),
          child: IconButton(
            iconSize: 40,
            icon: const Icon(Icons.arrow_back),
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
                    controller: emailController,
                    autofocus: true, //-----------------
                    keyboardType:
                        TextInputType.emailAddress, //-----------------
                    decoration: const InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                          color: Color.fromARGB(226, 236, 55, 45),
                          width: 2,
                        )),
                        label: Text(
                          'E-mail',
                          style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 103, 101, 101),
                          ),
                        )),
                  ),
                  TextFormField(
                    controller: senhaController,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: const InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                          color: Color.fromARGB(226, 236, 55, 45),
                          width: 2,
                        )),
                        label: Text(
                          'Senha',
                          style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 103, 101, 101),
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        child: const Text(
                          'Esqueceu a senha?',
                          style: TextStyle(
                              fontFamily: 'Inter-Thin',
                              fontSize: 16,
                              color: Color.fromARGB(255, 97, 95, 95)),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => esqueceu_senha(),
                            ),
                          );
                        }),
                  ),
                  const SizedBox(
                    height: 70,
                  ),
                  Container(
                    height: 55,
                    width: 300,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      gradient: LinearGradient(colors: [
                        Color.fromARGB(221, 249, 74, 16),
                        Color.fromARGB(226, 236, 55, 45),
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
                      onPressed: () => _loginUser(
                          emailController.text, senhaController.text, context),
                    ),
                  ),
                  const SizedBox(
                    height: 110,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Não tem uma conta?',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: Color.fromARGB(255, 65, 64, 64),
                          fontSize: 18,
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
          padding: const EdgeInsets.only(top: 680, left: 140),
          child: SizedBox(
            height: 40,
            child: TextButton(
              child: const Text(
                "Cadastre-se",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(226, 236, 55, 45),
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

  Future<void> _loginUser(email, senha, context) async {
    //Navigator.pushReplacementNamed(context, 'menuPrincipal');
    try {
      await Authent().loginwithEmailAndPassword(email, senha).then((value) {});
      Navigator.pushReplacementNamed(context, 'menu principal');
    } on FirebaseException catch (e) {
      var msg = '';
      if (e.code == 'user-not-found') {
        msg = 'ERRO: Usuario não encontrado';
      } else if (e.code == 'wrong-password') {
        msg = 'ERRO: Senha incorreta';
      } else if (e.code == 'invalid-email') {
        msg = 'ERRO: Email inválido';
      } else {
        msg = 'ERRO: ${e.message}';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          duration: Duration(
            seconds: 2,
          ),
        ),
      );
    }
  }
}
