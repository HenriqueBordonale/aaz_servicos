import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Servicos {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String idofer = FirebaseAuth.instance.currentUser!.uid;
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
      'Editor multimídia',
      'Intérprete',
      'Técnico de Equipamentos',
      'Cozinheiro',
      'Prestador de serviço',
    ];
  }

  Future<void> createServico(String nome, String especificacao) async {
    try {
      DocumentReference docRef =
          await FirebaseFirestore.instance.collection('servicos').add({
        'userId': idofer,
        'nome': nome,
        'especificacao': especificacao,
        'idPerfil': '',
      });

      String idDoDocumento = docRef.id;

      print('Serviço criado com sucesso. ID do documento: $idDoDocumento');
    } catch (e) {
      print('Erro ao criar serviço: $e');
    }
  }

  Future<void> addPerfilToServico(String idServico, String idPerfil) async {
    try {
      // Primeiro, obtenha o documento do serviço pelo idServico
      final servicoDoc = await FirebaseFirestore.instance
          .collection('servicos')
          .doc(idServico)
          .get();

      if (servicoDoc.exists) {
        // O documento do serviço existe, agora você pode atualizá-lo
        await FirebaseFirestore.instance
            .collection('servicos')
            .doc(idServico)
            .update({'idPerfil': idPerfil});
        print('Perfil vinculado ao serviço com sucesso.');
      } else {
        print(
            'Serviço não encontrado. Certifique-se de que o idServico seja válido.');
      }
    } catch (e) {
      print('Erro ao vincular perfil ao serviço: $e');
    }
  }
}
