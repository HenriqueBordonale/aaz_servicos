import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aaz_servicos/pages/Login/login.dart';
import 'package:aaz_servicos/pages/Login/cadastro.dart';

class esqueceu_senha extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  esqueceu_senha({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 10, left: 25, right: 25),
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            IconButton(
              iconSize: 35,
              alignment: Alignment.bottomLeft,
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                // Quando o ícone for pressionado, navegue de volta para a tela anterior
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: Image.asset("assets/images/reset-password.png"),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Esqueceu sua senha?",
                        style: TextStyle(
                          color: Color.fromARGB(226, 236, 55, 45),
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Por favor, informe o E-mail associado a sua conta que enviaremos um link para o mesmo com as instruções para restauração de sua senha.",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  width: double.infinity,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                            color: Color.fromARGB(226, 236, 55, 45),
                            width: 2,
                          )),
                          labelText: "E-mail",
                          labelStyle: TextStyle(
                            color: Colors.black38,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(
                        height: 60,
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
                        child: Container(
                          child: TextButton(
                            child: const Text(
                              "Enviar",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            onPressed: () => _resetPassword(context),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void _resetPassword(BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text,
      );
    } catch (e) {
      print('Error: $e');
    }
  }
}
