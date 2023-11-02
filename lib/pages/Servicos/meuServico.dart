import 'package:aaz_servicos/pages/Perfil_Profissional/perfilPro.dart';
import 'package:aaz_servicos/pages/Servicos/servicoCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:aaz_servicos/models/servicos.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class servicos extends StatefulWidget {
  const servicos({super.key});

  @override
  State<servicos> createState() => _servicos();
}

Servicos minhaInstancia = Servicos();
List<String> serv = minhaInstancia.get_Servicos;

class _servicos extends State<servicos> {
  List<Servico> servicos = [];
  String? _selectedServ;
  String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _loadServicos();
  }

  Future<void> _loadServicos() async {
    List<Servico> servicosList = await getServicos(userId);
    List<Servico> updatedServicosList = [];

    // Use um forEach para percorrer a lista de serviços e verificar o idPerfil
    await Future.forEach(servicosList, (Servico servico) async {
      // Verifique se o campo idPerfil existe no objeto Servico antes de acessá-lo
      if (servico.idPerfil == 'inexistente') {
        // Se o campo idPerfil for 'inexistente', não faça nada, pois já é o valor padrão.
        updatedServicosList.add(servico);
      } else {
        bool idPerfilBuscado =
            await Servicos().verificarIdPerfil(servico.idServico);
        // Crie um novo objeto Servico com o valor de idPerfil atualizado
        Servico updatedServico = Servico(
          nome: servico.nome,
          especificacao: servico.especificacao,
          idServico: servico.idServico,
          idPerfil: idPerfilBuscado
              ? 'true'
              : 'false', // Use 'true' ou 'false' como valores para representar booleanos
        );
        updatedServicosList.add(updatedServico);
      }
    });

    setState(() {
      servicos = updatedServicosList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(221, 249, 74, 16),
        title: const Text(
          'Serviços',
          style: TextStyle(fontSize: 25, fontFamily: 'inter'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          left: 15,
          right: 15,
        ),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.only(
                top: 30,
              ),
              child: const Text(
                'Serviços Cadastrados',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 37, 37, 37),
                  fontFamily: 'Inter',
                  fontSize: 30,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: servicos.length,
              itemBuilder: (context, index) {
                bool temIdPerfil = servicos[index].idPerfil != null;

                return ServicoCard(
                  nome: servicos[index].nome,
                  especificacao: servicos[index].especificacao,
                  onDelete: () {
                    deleteServico(servicos[index].idServico);
                  },
                  onEdit: () {
                    _showEditServicoBottomSheet(context, servicos[index]);
                  },
                  onCadastrarPerfil: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => perfilprofissional(
                          idServico: servicos[index].idServico,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(
              height: 10,
            ),
            IconButton(
              iconSize: 60,
              alignment: Alignment.bottomLeft,
              icon: Icon(Icons.add_circle),
              color: const Color.fromARGB(255, 66, 66, 66),
              onPressed: () {
                _showAddServicoBottomSheet(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddServicoBottomSheet(BuildContext context) {
    var especController = TextEditingController();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.deepOrange,
                    size: 25, // Tamanho do ícone
                  ),
                  SizedBox(width: 8), // Espaçamento entre o ícone e o texto
                  Text(
                    'Adicionar Novo Serviço',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              DropdownButtonFormField2<String>(
                isExpanded: true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                value: _selectedServ,
                hint: const Text('Selecione seu serviço'),
                iconStyleData: const IconStyleData(
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.deepOrange,
                    size: 24, // Tamanho do ícone
                  ),
                ),
                onChanged: (newValue) {
                  _selectedServ = newValue!;
                },
                items: serv.map((String service) {
                  return DropdownMenuItem<String>(
                    value: service,
                    child: Text(service),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              TextField(
                controller: especController,
                decoration: InputDecoration(
                  labelText: 'Especificação',
                  labelStyle: TextStyle(
                    color:
                        const Color.fromARGB(255, 81, 80, 80), // Cor do rótulo
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Colors
                          .deepOrange, // Cor desejada quando o campo está em foco
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepOrange,
                  padding:
                      EdgeInsets.symmetric(vertical: 16), // Espaçamento interno
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15), // Borda arredondada
                  ),
                  minimumSize: Size(100, 0), // Defina a largura mínima desejada
                  alignment:
                      Alignment.center, // Centralize o texto horizontalment
                ),
                onPressed: () async {
                  final novoNome = _selectedServ.toString();
                  final novaEspecificacao = especController.text;

                  if (novoNome.isNotEmpty && novaEspecificacao.isNotEmpty) {
                    Servicos().createServico(
                      novoNome,
                      novaEspecificacao,
                    );
                    _selectedServ = null;
                    especController.clear();

                    // Atualize a lista de serviços após criar o novo serviço
                    await _loadServicos();

                    // Feche o modal
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  'Adicionar',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(40), // Ajuste o raio conforme necessário
        ),
      ),
    );
  }

  void _showEditServicoBottomSheet(BuildContext context, Servico servico) {
    var nomeController = TextEditingController(text: servico.nome);
    var especController = TextEditingController(text: servico.especificacao);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    Icons.edit,
                    color: Colors.deepOrange,
                    size: 20, // Tamanho do ícone
                  ),
                  SizedBox(width: 8), // Espaçamento entre o ícone e o texto
                  Text(
                    'Atualizar Serviço',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              DropdownButtonFormField2<String>(
                isExpanded: true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                value: _selectedServ,
                hint: const Text('Selecione seu serviço'),
                iconStyleData: const IconStyleData(
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.deepOrange,
                    size: 24, // Tamanho do ícone
                  ),
                ),
                onChanged: (newValue) {
                  _selectedServ = newValue!;
                },
                items: serv.map((String service) {
                  return DropdownMenuItem<String>(
                    value: service,
                    child: Text(service),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              TextField(
                controller: especController,
                decoration: InputDecoration(
                  labelText: 'Especificação',
                  labelStyle: TextStyle(
                    color:
                        const Color.fromARGB(255, 81, 80, 80), // Cor do rótulo
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Colors
                          .deepOrange, // Cor desejada quando o campo está em foco
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepOrange, // Cor de fundo do botão
                  padding:
                      EdgeInsets.symmetric(vertical: 16), // Espaçamento interno
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15), // Borda arredondada
                  ),
                  minimumSize: Size(100, 0), // Defina a largura mínima desejada
                  alignment:
                      Alignment.center, // Centralize o texto horizontalment
                ),
                onPressed: () async {
                  final novoNome = nomeController.text;
                  final novaEspecificacao = especController.text;

                  if (novoNome.isNotEmpty && novaEspecificacao.isNotEmpty) {
                    // Atualize os dados do serviço no Firestore
                    await updateServico(
                        servico.idServico, novoNome, novaEspecificacao);

                    // Atualize a lista de serviços após editar o serviço
                    await _loadServicos();

                    // Feche o modal
                    Navigator.pop(context);
                  }
                },
                child: Text('Salvar'),
              ),
            ],
          ),
        );
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(40), // Ajuste o raio conforme necessário
        ),
      ),
    );
  }

  Future<void> updateServico(
      String idServico, String novoNome, String novaEspecificacao) async {
    try {
      await FirebaseFirestore.instance
          .collection('servicos')
          .doc(idServico)
          .update({
        'nome': novoNome,
        'especificacao': novaEspecificacao,
      });
    } catch (e) {
      print('Erro ao atualizar o serviço: $e');
    }
  }

  Future<List<Servico>> getServicos(String userId) async {
    List<Servico> servicosList = [];

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('servicos')
          .where('userId', isEqualTo: userId)
          .get();

      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        final idServico = document.id;
        final nome = document['nome'];
        final especificacao = document['especificacao'];

        String? idPerfil = document['idPerfil'];

        if (idPerfil != null) {
          servicosList.add(Servico(
            idServico: idServico,
            nome: nome,
            especificacao: especificacao,
            idPerfil: idPerfil,
          ));
        }
      }
    } catch (e) {
      print('Erro ao buscar os serviços: $e');
      // Você pode lançar uma exceção personalizada aqui se preferir.
    }

    return servicosList;
  }

  Future<void> deleteServico(String idServico) async {
    try {
      await FirebaseFirestore.instance
          .collection('servicos')
          .doc(idServico)
          .delete();

      // Atualize a lista de serviços após excluir o serviço
      await _loadServicos();
    } catch (e) {
      print('Erro ao excluir o serviço: $e');
    }
  }
}
