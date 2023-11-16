import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Perfil {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String idofer = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> createPerfil(String idServico, String descricao, String nome,
      String categoria, String especificacao, String imageUrl) async {
    try {
      final userDocRef =
          FirebaseFirestore.instance.collection('user').doc(idofer);
      DocumentSnapshot userSnapshot = await userDocRef.get();
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      final perfilDocRef =
          await FirebaseFirestore.instance.collection('perfis').add({
        'idOfertante': idofer,
        'idServico': idServico,
        'descricao': descricao,
        'nome': nome,
        'categoria': categoria,
        'especificacao': especificacao,
        'avaliacao': '',
        'quantidade': '',
        'imageUrl': imageUrl,
        'genero': userData['genero'],
        'cidade': userData['cidade'],
        'uf': userData['uf'],
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

  Future<void> updatePerfil(String idPerfil, String descricao, String nome,
      String categoria, String especificacao, String imageUrl) async {
    try {
      final perfilDocRef =
          FirebaseFirestore.instance.collection('perfis').doc(idPerfil);

      // Obtenha dados do documento 'user' correspondente
      final userDocRef =
          FirebaseFirestore.instance.collection('user').doc(idofer);

      DocumentSnapshot userSnapshot = await userDocRef.get();
      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;

        await perfilDocRef.update({
          'descricao': descricao,
          'nome': nome,
          'categoria': categoria,
          'especificacao': especificacao,
          'avaliacao': '',
          'quantidade': '',
          'imageUrl': imageUrl,
          'genero': userData['genero'],
          'cidade': userData['cidade'],
          'uf': userData['uf'],
        });
      } else {
        print('Documento user não encontrado para o ID: $idofer');
      }
    } catch (e) {
      print('Erro ao atualizar perfil: $e');
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

  Future<void> deleteImageFromStorage(String imageUrl, String idServico) async {
    try {
      // Exclua a imagem do Firebase Storage
      final Reference imageRef = FirebaseStorage.instance.refFromURL(imageUrl);
      await imageRef.delete();

      // Atualize o documento no Cloud Firestore para remover a referência da imagem
      final servicoRef = _firestore.collection('servicos').doc(idServico);
      final servicoDoc = await servicoRef.get();
      if (servicoDoc.exists) {
        final List<String> photos =
            List<String>.from(servicoDoc['photos'] ?? []);
        photos.remove(imageUrl); // Remova a URL da imagem da lista de fotos
        await servicoRef
            .update({'photos': photos}); // Atualize a lista no Firestore
      }
    } catch (e) {
      print('Erro ao excluir imagem: $e');
    }
  }
}
