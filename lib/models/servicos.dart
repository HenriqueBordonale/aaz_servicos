import 'package:aaz_servicos/pages/Servicos/servicoCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aaz_servicos/pages/Servicos/meuServico.dart';

class Servicos {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String idofer = FirebaseAuth.instance.currentUser!.uid;
  List<String> get get_Servicos {
    return [
      'Musicista',
      'Tatuador(a)',
      'Cabeleireiro(a)',
      'Pintor(a)',
      'Designer Gráfico',
      'Fotógrafo(a)',
      'Serviços domésticos',
      'Costureiro(a)',
      'Jardineiro(a)',
      'Confeiteiro(a)',
      'Manicure e Pedicure',
      'Cuidador(a)',
      'Professor(a)',
      'Programador(a)',
      'Bartender',
      'Esteticista',
      'Maquiador(a)',
      'Personal Trainer',
      'Ator/Atriz',
      'Editor multimídia',
      'Intérprete',
      'Técnico de Equipamentos',
      'Cozinheiro(a)',
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
        final idPerfil = document['idPerfil'];

        servicosList.add(Servico(
          idServico: idServico,
          nome: nome,
          especificacao: especificacao,
          idPerfil: idPerfil,
        ));
      }
    } catch (e) {
      print('Erro ao buscar os serviços: $e');
      // Você pode lançar uma exceção personalizada aqui se preferir.
    }

    return servicosList;
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
}
