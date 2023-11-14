import 'package:aaz_servicos/pages/Buscador/mostrarPerfil.dart';
import 'package:aaz_servicos/pages/Chat/conversa.dart';
import 'package:aaz_servicos/pages/Configuracoes/config.dart';
import 'package:aaz_servicos/pages/Login/cadastro_ofertante.dart';
import 'package:aaz_servicos/pages/Login/esqueceu_senha.dart';
import 'package:aaz_servicos/pages/Perfil_Profissional/perfilPro.dart';
import 'package:aaz_servicos/pages/Servicos/meuServico.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:aaz_servicos/pages/Login/selecao_usuario.dart';
import 'package:aaz_servicos/pages/Login/login.dart';
import 'package:aaz_servicos/pages/Login/cadastro.dart';
import 'package:aaz_servicos/pages/Buscador/buscadorScreen.dart';
import 'package:aaz_servicos/pages/Menu/menuPrincipal.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AaZ Serviços',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey:
          scaffoldMessengerKey, // Defina a chave do ScaffoldMessenger aqui
      theme: ThemeData(
        primaryColor: Colors.deepOrange,
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          contentTextStyle: TextStyle(
            color: Color.fromARGB(219, 0, 0, 0),
            fontSize: 16.0,
          ),
          backgroundColor: Color.fromARGB(255, 229, 229, 230),
        ),
      ),
      home: const selecao_usuario(),
      routes: {
        'login': (context) => login(),
        'chat': (context) => ChatScreen(),
        'cadastro': (context) => const Cadastro(),
        'menu principal': (context) => const menuPrincipal(),
        'esqueceu senha': (context) => esqueceu_senha(),
        'cadastro_servico': (context) => const CadastroOfer(),
        'configuracao': (context) => const Config(),
        'servicos': (context) => const servicos(),
        'perfilprofissional': (context) {
          final arguments = ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>? ??
              {};
          final idServico = arguments['idServico'] as String;

          return perfilprofissional(
              idServico:
                  idServico); // Certifique-se de passar idServico como argumento nomeado
        },
        'buscador': (context) => ServicosScreen(),
        'mostarPerfil': (context) {
          final arguments = ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>? ??
              {};
          final idPerfil = arguments['idPerfil'] as String;

          return MostrarPerfil(idPerfil: idPerfil);
        },
      },
    );
  }
}
