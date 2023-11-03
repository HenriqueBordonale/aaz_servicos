import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Perfil {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String idofer = FirebaseAuth.instance.currentUser!.uid;

  Future<String?> createPerfil(String idServico, String descricao) async {
    try {
      // Crie o perfil no Firestore
      final perfilDocRef =
          await FirebaseFirestore.instance.collection('perfis').add({
        'idServico': idServico,
        'descricao': descricao,
        // Outros campos do perfil, se houver
      });

      final idPerfil = perfilDocRef.id; // Obtenha o ID do perfil criado

      print('Perfil criado com sucesso. ID do perfil: $idPerfil');

      // Atualize o campo no documento da coleção 'servico' identificado por idServico
      final servicoDocRef =
          FirebaseFirestore.instance.collection('servicos').doc(idServico);
      await servicoDocRef.update({
        'idPerfil': idPerfil,
        // Outros campos do serviço a serem atualizados, se houver
      });

      return idPerfil;
    } catch (e) {
      print('Erro ao criar o perfil: $e');
      return null;
    }
  }

  Future<void> updatePerfil(String idPerfil, String descricao) async {
    try {
      final perfilDocRef =
          FirebaseFirestore.instance.collection('perfis').doc(idPerfil);

      // Atualize a descrição no documento do perfil
      await perfilDocRef.update({
        'descricao': descricao,
        // Outros campos a serem atualizados, se houver
      });

      print(
          'Descrição do perfil atualizada com sucesso. ID do perfil: $idPerfil');
    } catch (e) {
      print('Erro ao atualizar a descrição do perfil: $e');
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
