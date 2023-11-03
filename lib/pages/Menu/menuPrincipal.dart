import 'package:aaz_servicos/pages/Configuracoes/config.dart';
import 'package:aaz_servicos/pages/Perfil_Profissional/perfilPro.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'dart:io';

import '../Servicos/meuServico.dart';

class menuPrincipal extends StatefulWidget {
  const menuPrincipal({super.key});

  @override
  State<menuPrincipal> createState() => _menuPrincipal();
}

class _menuPrincipal extends State<menuPrincipal> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    Screen2(),
    servicos(),
    const Config(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        height: 50.0,
        items: <Widget>[
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
        ],
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
