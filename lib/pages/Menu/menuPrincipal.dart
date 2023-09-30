import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class menuPrincipal extends StatefulWidget {
  const menuPrincipal({super.key});

  @override
  State<menuPrincipal> createState() => _menuPrincipal();
}

class _menuPrincipal extends State<menuPrincipal> {
  int escolhaTela = 0;
  final List<Widget> _screens = [
    Tela1(),
    Tela2(),
    Tela3(),
    Tela4(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _screens[escolhaTela], // Coloque os screens aqui
          Divider(
            color: Color.fromARGB(255, 41, 40, 40), // Define a cor da linha
            thickness: 2, // Define a espessura da linha
            indent: 20, // Define o recuo à esquerda
            endIndent: 20, // Define o recuo à direita
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 5),
        child: GNav(
          rippleColor: const Color.fromARGB(
              255, 66, 66, 66), // tab button ripple color when pressed
          hoverColor:
              const Color.fromARGB(255, 97, 97, 97), // tab button hover color
          haptic: true, // haptic feedback
          tabBorderRadius: 50,
          tabActiveBorder: Border.all(
              color: Color.fromARGB(255, 41, 40, 40),
              width: 2), // tab button border
          curve: Curves.easeOutExpo, // tab animation curves
          duration: Duration(milliseconds: 900), // tab animation duration
          gap: 8, // the tab button gap between icon and text
          color: Color.fromARGB(255, 41, 40, 40), // unselected icon color
          activeColor: const Color.fromARGB(255, 41, 40, 40),
          iconSize: 24, // tab button icon size
          tabBackgroundColor: Colors.transparent,
          tabs: [
            GButton(
              icon: Icons.space_dashboard,
              text: 'Perfis',
            ),
            GButton(
              icon: Icons.message,
              text: 'Chats',
            ),
            GButton(
              icon: Icons.home_repair_service,
              text: 'Serviços',
            ),
            GButton(
              icon: Icons.settings,
              text: 'Config',
            ),
          ],
          selectedIndex: escolhaTela,
          onTabChange: (index) {
            setState(() {
              escolhaTela = index;
            });
          },
        ),
      ),
    );
  }
}

class Tela1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Tela 1'),
    );
  }
}

class Tela2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Tela 2'),
    );
  }
}

class Tela3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Tela 3'),
    );
  }
}

class Tela4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Tela 4'),
    );
  }
}
