import 'package:aaz_servicos/pages/Login/cadastro_ofertante.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:aaz_servicos/models/auth.dart';
import 'package:aaz_servicos/pages/Login/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

enum SingingCharacter { contratante, ofertante }

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _Cadastro();
}

class _Cadastro extends State<Cadastro> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  SingingCharacter? _character = SingingCharacter.contratante;

  Map<SingingCharacter, String> characterMap = {
    SingingCharacter.contratante: 'contratante',
    SingingCharacter.ofertante: 'ofertante',
  };

  static final RegExp nameRegExp = RegExp('[a-zA-Z]');
  static final RegExp emailRegExp = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  final maskData = MaskTextInputFormatter(mask: "##/##/####");

  // List of items in our dropdown menu
  final List<String> genderItems = [
    'Masculino',
    'Feminino',
    'Outro',
    'Não definido',
  ];

  String? selectedValue;
  String? tipoconta;
  var generoController = TextEditingController();
  var emailController = TextEditingController();
  var senhaController = TextEditingController();
  var nomeController = TextEditingController();
  var dataController = TextEditingController();
  String buttonText = 'CADASTRAR';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(key: _formKey, children: [
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
          padding: EdgeInsets.only(top: 60.0, left: 22),
          child: Text(
            'Crie sua \nconta!',
            style: TextStyle(
                fontSize: 35, color: Colors.white, fontWeight: FontWeight.bold),
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
                builder: (context) => login(),
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
              children: [
                const Text(
                  'Qual seu tipo de usuário?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 19,
                      color: Color.fromARGB(255, 77, 76, 76)),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<SingingCharacter>(
                        title: const Text(
                          'Contratante',
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18,
                              color: Color.fromARGB(255, 46, 46, 46)),
                        ),
                        value: SingingCharacter.contratante,
                        dense: true,
                        activeColor: const Color.fromARGB(226, 236, 55, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        contentPadding: const EdgeInsets.all(0.0),
                        groupValue: _character,
                        onChanged: (SingingCharacter? value) {
                          setState(() {
                            buttonText = 'CADASTRAR';
                            _character = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 5.0),
                    Expanded(
                      child: RadioListTile<SingingCharacter>(
                        title: const Text(
                          'Ofertante',
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18,
                              color: Color.fromARGB(255, 46, 46, 46)),
                        ),
                        value: SingingCharacter.ofertante,
                        dense: true,
                        activeColor: const Color.fromARGB(226, 236, 55, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        contentPadding: const EdgeInsets.all(0.0),
                        groupValue: _character,
                        onChanged: (SingingCharacter? value) {
                          setState(() {
                            buttonText = 'CONTINUAR';
                            _character = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: nomeController,
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                      color: Color.fromARGB(221, 249, 74, 16),
                      width: 2,
                    )),
                    labelText: "Nome",
                    labelStyle: TextStyle(
                      color: Colors.black38,
                      fontSize: 19,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 19,
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Digite seu Nome'
                      : (nameRegExp.hasMatch(value)
                          ? null
                          : 'Digite um nome válido!'),
                ),
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
                      fontSize: 19,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 19,
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Preencha o campo de email!'
                      : (emailRegExp.hasMatch(value)
                          ? null
                          : 'Digite um email válido!'),
                ),
                TextFormField(
                  controller: senhaController,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                      color: Color.fromARGB(226, 236, 55, 45),
                      width: 2,
                    )),
                    labelText: "Senha",
                    labelStyle: TextStyle(
                      color: Colors.black38,
                      fontSize: 19,
                    ),
                  ),
                  style: const TextStyle(fontSize: 19),
                  validator: ((value) {
                    if (value == null || value.isEmpty) {
                      return 'Preencha o campo de senha!';
                    } else if (value.length < 8) {
                      return 'Digite uma senha válida, maior que 8 caracteres!';
                    }
                    return null;
                  }),
                ),
                TextFormField(
                  controller: dataController,
                  keyboardType: TextInputType.datetime,
                  inputFormatters: [maskData],
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                      color: Color.fromARGB(226, 236, 55, 45),
                      width: 2,
                    )),
                    labelText: "Data de Nascimento",
                    labelStyle: TextStyle(
                      color: Colors.black38,
                      fontSize: 19,
                    ),
                  ),
                  style: const TextStyle(fontSize: 19),
                  validator: ((value) {
                    if (value == null || value.isEmpty) {
                      return 'Preencha o campo de data de nascimento';
                    }
                    return null;
                  }),
                ),
                const SizedBox(
                  height: 20,
                ),
                DropdownButtonFormField2<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    // Add more decoration..
                  ),
                  hint: const Text(
                    'Selecione seu gênero',
                    style: TextStyle(
                      fontSize: 19,
                      color: Colors.grey,
                    ),
                  ),
                  items: genderItems
                      .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 68, 68, 68),
                                fontSize: 19,
                              ),
                            ),
                          ))
                      .toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Selecione seu gênero';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    generoController.text = value.toString();
                  },
                  onSaved: (value) {
                    selectedValue = value.toString();
                  },
                  buttonStyleData: const ButtonStyleData(
                    padding: EdgeInsets.only(right: 8),
                  ),
                  iconStyleData: const IconStyleData(
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Color.fromARGB(226, 236, 55, 45),
                    ),
                    iconSize: 24,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  height: 55,
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(colors: [
                      Color.fromARGB(221, 249, 74, 16),
                      Color.fromARGB(226, 236, 55, 45),
                    ]),
                  ),
                  child: SizedBox.expand(
                    child: TextButton(
                        child: Text(
                          buttonText,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                        onPressed: () async {
                          String? characterString = characterMap[_character];
                          tipoconta = characterString;
                          try {
                            await Authent()
                                .createUserwithEmailAndPassword(
                                    nomeController.text,
                                    emailController.text,
                                    senhaController.text,
                                    dataController.text,
                                    generoController.text,
                                    tipoconta.toString(),
                                    context)
                                .then(
                              (value) {
                                if (_character ==
                                    SingingCharacter.contratante) {
                                  Navigator.pop(context);
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const CadastroOfer(),
                                    ),
                                  );
                                }
                              },
                            );
                          } catch (e) {
                            print('Error: $e');
                          }
                          //criarConta(txtNome.text ,txtEmail.text, txtSenha.text, txtTelefone.text, txtDataNascimento.text, txtCpf.text, txtCodigoNutricionista.text ?? "", context);
                        }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ]));
  }
}
