import 'package:aaz_servicos/pages/Login/cadastro_ofertante.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'database.dart';

class Servicos {
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Cidade selecionada

  List<String> get get_Servicos {
    return [
      'Músico',
      'Tatuador',
      'Cabeleireiro',
      'Pintor',
      'Designer Gráfico',
      'Fotógrafo',
      'Diarista',
      'Costureiro',
      'Jardineiro',
      'Confeiteiro',
      'Manicure e Pedicure',
      'Cuidador',
      'Professor Particular',
      'Programador Freelancer',
      'Bartender',
      'Esteticista',
      'Maquiador',
      'Personal Trainer',
      'Ator',
      'Editor multimidia',
      'Interprete',
      'Técnico de Equipamentos',
      'Cozinheiro',
      'Prestador de serviço'
    ];
  }

  Future<void> createServico(
      idServ, String nome, String especificacao, context) async {
    Map<String, dynamic> servicosInfoMap = {
      'idServico': idServ,
      'Nome do servico': nome,
      'Especificacao': especificacao,
    };

    DatabaseMethods().addServicosInfoToDB(servicosInfoMap);
  }

  // Função para associar um serviço ao usuário autenticado
  Future<void> updateIdServ(String idServico) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Obtém o ID do usuário atualmente autenticado
        final userId = user.uid;

        // Atualiza o documento do usuário na coleção de usuários
        await FirebaseFirestore.instance.collection('user').doc(userId).update({
          'servicoId': idServico,
          // Outros campos e valores que você deseja atualizar no documento do usuário
        });

        print('Serviço associado ao usuário com sucesso');
      } else {
        print('Usuário não autenticado');
      }
    } catch (e) {
      print('Erro ao associar o serviço ao usuário: $e');
    }
  }
}
