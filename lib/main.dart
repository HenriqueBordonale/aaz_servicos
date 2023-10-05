import 'package:aaz_servicos/pages/Configuracoes/config.dart';
import 'package:aaz_servicos/pages/Login/cadastro_ofertante.dart';
import 'package:aaz_servicos/pages/Login/esqueceu_senha.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:aaz_servicos/pages/Login/selecao_usuario.dart';
import 'package:aaz_servicos/pages/Login/login.dart';
import 'package:aaz_servicos/pages/Login/cadastro.dart';
import 'firebase_options.dart';
import 'package:aaz_servicos/pages/Menu/menuPrincipal.dart';

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
        'login': (context) => login(),
        'cadastro': (context) => const Cadastro(),
        'menu principal': (context) => const menuPrincipal(),
        'esqueceu senha': (context) => esqueceu_senha(),
        'cadastro_servico': (context) => const CadastroOfer(),
        'configuracao': (context) => const Config(),
      },
    );
  }
}
