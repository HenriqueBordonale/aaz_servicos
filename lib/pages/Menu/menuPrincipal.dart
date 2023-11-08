import 'package:aaz_servicos/models/database.dart';
import 'package:aaz_servicos/pages/Buscador/buscadorScreen.dart';
import 'package:aaz_servicos/pages/Configuracoes/config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'dart:io';

import '../Servicos/meuServico.dart';

class menuPrincipal extends StatefulWidget {
  const menuPrincipal({Key? key}) : super(key: key);

  @override
  _menuPrincipal createState() => _menuPrincipal();
}

class _menuPrincipal extends State<menuPrincipal> {
  int _currentIndex = 0;
  Future<String?>? tipoUsuario;

  @override
  void initState() {
    super.initState();
    tipoUsuario = DatabaseMethods().checKTipoUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: tipoUsuario,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          String? tipo = snapshot.data;
          List<Icon> icons = getIconList(tipo);
          List<Widget> screens = getScreens(tipo);

          return Scaffold(
            body: screens[_currentIndex],
            bottomNavigationBar: CurvedNavigationBar(
              index: _currentIndex,
              height: 50.0,
              items: icons,
              color: Color.fromARGB(221, 249, 74, 16),
              buttonBackgroundColor: Color.fromARGB(221, 249, 74, 16),
              backgroundColor: Colors.transparent,
              animationCurve: Curves.easeInOut,
              animationDuration: Duration(milliseconds: 300),
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          );
        } else {
          return CircularProgressIndicator(); // Pode mostrar um indicador de carregamento enquanto carrega o tipo de usuário.
        }
      },
    );
  }

  // Resto do código permanece inalterado
}

List<Widget> getScreens(String? tipoUsuario) {
  if (tipoUsuario == 'ofertante') {
    return [
      Screen4(),
      servicos(),
      const Config(),
    ];
  } else {
    return [
      Screen3(),
      ServicosScreen(), // Use outra tela para contratantes (por exemplo, Screen2() ou algo adequado)
      const Config(),
    ];
  }
}

List<Icon> getIconList(String? tipoUsuario) {
  if (tipoUsuario == 'ofertante') {
    return [
      Icon(
        Icons.message,
        size: 30,
        color: Colors.white,
      ),
      Icon(
        Icons.construction,
        size: 30,
        color: Colors.white,
      ),
      Icon(
        Icons.settings,
        size: 30,
        color: Colors.white,
      ),
    ];
  } else {
    return [
      Icon(
        Icons.message,
        size: 30,
        color: Colors.white,
      ),
      Icon(
        Icons.search_sharp,
        size: 35,
        color: Colors.white,
      ),
      Icon(
        Icons.settings,
        size: 30,
        color: Colors.white,
      ),
    ];
  }
}

class Screen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Tela 2'),
    );
  }
}

class Screen3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Tela 3'),
    );
  }
}

class Screen4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Tela 4'),
    );
  }
}
