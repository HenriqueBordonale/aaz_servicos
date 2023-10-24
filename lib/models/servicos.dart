import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Servicos {
  final FirebaseAuth auth = FirebaseAuth.instance;

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
      String idofer = FirebaseAuth.instance.currentUser!.uid;

      DocumentReference docRef =
          await FirebaseFirestore.instance.collection('servicos').add({
        'userId': idofer,
        'nome': nome,
        'especificacao': especificacao,
      });

      String idDoDocumento = docRef.id;

      print('Serviço criado com sucesso. ID do documento: $idDoDocumento');
    } catch (e) {
      print('Erro ao criar serviço: $e');
    }
  }
}
