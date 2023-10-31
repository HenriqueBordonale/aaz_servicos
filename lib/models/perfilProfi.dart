import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Perfil {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String idofer = FirebaseAuth.instance.currentUser!.uid;

  Future<void> createPerfil(String idServ, String nome, String especificacao,
      String descricao, int qtdeAvaliacoes, String notaGeral) async {
    try {
      DocumentReference docRef =
          await FirebaseFirestore.instance.collection('perfilProfi').add({
        'userId': idofer,
        'servicoId': idServ,
        'nome': nome,
        'especificacao': especificacao,
        'descricao': descricao,
        'qtdeAvaliacoes': qtdeAvaliacoes,
        'notaGeral': notaGeral,
      });

      print('Perfil criado com sucesso.');
    } catch (e) {
      print('Erro ao criar serviço: $e');
    }
  }

  void consultarDocUser(
      void Function(String nome, String cidade, String uf)
          onDataReceived) async {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('user').doc(idofer);

    DocumentSnapshot doc = await docRef.get();

    if (doc.exists) {
      // O documento existe, agora você pode acessar os campos
      String nome = doc.get('nome');
      String cidade = doc.get('cidade');
      String uf = doc.get('uf');

      onDataReceived(nome, cidade, uf);
    } else {
      // O documento não existe
    }
  }

  void consultarDocServico(
      void Function(String servico, String especificacao)
          onDataReceived) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('servicos')
          .where('userId', isEqualTo: idofer)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Se houver documentos correspondentes à consulta
        final document = querySnapshot
            .docs[0]; // Assumindo que há apenas um documento correspondente

        String servico = document.get('nome');
        String especificacao = document.get('especificacao');

        print('Dados obtidos com sucesso:');
        print('Serviço: $servico');
        print('Especificação: $especificacao');

        onDataReceived(servico, especificacao);
      } else {
        // Não foram encontrados documentos correspondentes à consulta
        print('Nenhum documento correspondente encontrado');
      }
    } catch (e) {
      print('Erro ao buscar os serviços: $e');
    }
  }
}
