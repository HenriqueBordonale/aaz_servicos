import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:aaz_servicos/pages/Login/selecao_usuario.dart';
import 'package:aaz_servicos/pages/Login/login.dart';
import 'package:aaz_servicos/pages/Login/cadastro.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AaZ Serviços',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.deepOrange),
      home: const selecao_usuario(),
      routes: {
        'login': (context) => const login(),
        'cadastro': (context) => const Cadastro(),
      },
    );
  }
}
