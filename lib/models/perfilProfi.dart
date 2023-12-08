import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Perfil {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String idofer = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> createPerfil(String idServico, String descricao, String nome,
      String categoria, String especificacao) async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('user_images/profile_images/${idofer}');
    final urlStorageOfer = await storageRef.getDownloadURL();

    final userDocRef =
        FirebaseFirestore.instance.collection('user').doc(idofer);
    DocumentSnapshot userSnapshot = await userDocRef.get();
    Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
    final perfilDocRef =
        await FirebaseFirestore.instance.collection('perfis').add({
      'idOfertante': idofer,
      'idServico': idServico,
      'descricao': descricao,
      'nome': nome,
      'categoria': categoria,
      'especificacao': especificacao,
      'quantidade': 0,
      'imageUrl': urlStorageOfer,
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
  }

  Future<void> updatePerfil(String idPerfil, String descricao, String nome,
      String categoria, String especificacao) async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('user_images/profile_images/${idofer}');
    final urlStorageOfer = await storageRef.getDownloadURL();

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
        'quantidade': 0,
        'imageUrl': urlStorageOfer,
        'genero': userData['genero'],
        'cidade': userData['cidade'],
        'uf': userData['uf'],
      });
    } else {
      print('Documento user não encontrado para o ID: $idofer');
    }
  }

  void consultarDocUser(
      void Function(String nome, String cidade, String uf)
          onDataReceived) async {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('user').doc(idofer);

    DocumentSnapshot doc = await docRef.get();

    if (doc.exists) {
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
  }

  Future<void> deleteImageFromStorage(String imageUrl, String idPerfil) async {
    // Exclua a imagem do Firebase Storage
    final Reference imageRef = FirebaseStorage.instance.refFromURL(imageUrl);
    await imageRef.delete();

    // Atualize o documento no Cloud Firestore para remover a referência da imagem
    final servicoRef = _firestore.collection('perfis').doc(idPerfil);
    final servicoDoc = await servicoRef.get();
    if (servicoDoc.exists) {
      final List<String> photos = List<String>.from(servicoDoc['photos'] ?? []);
      photos.remove(imageUrl); // Remova a URL da imagem da lista de fotos
      await servicoRef
          .update({'photos': photos}); // Atualize a lista no Firestore
    }
  }

  Future<double?> calcularMediaNotas(String idPerfilAtual) async {
    final QuerySnapshot feedbackSnapshot = await FirebaseFirestore.instance
        .collection('feedback')
        .where('idPerfil', isEqualTo: idPerfilAtual)
        .get();

    if (feedbackSnapshot.docs.isEmpty) {
      // Não há feedbacks para calcular a média
      return null;
    }

    double somaNotas = 0;
    int totalFeedbacks = 0;

    for (final DocumentSnapshot feedbackDoc in feedbackSnapshot.docs) {
      final Map<String, dynamic> feedbackData =
          feedbackDoc.data() as Map<String, dynamic>;

      if (feedbackData.containsKey('nota')) {
        somaNotas += (feedbackData['nota'] as num).toDouble();
        totalFeedbacks++;
      }
    }

    if (totalFeedbacks > 0) {
      // Calcula a média das notas
      double mediaNotas = somaNotas / totalFeedbacks;
      return mediaNotas;
    } else {
      // Não há notas para calcular a média
      return null;
    }
  }
}
