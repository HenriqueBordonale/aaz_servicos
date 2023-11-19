import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ChatModel {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String idContr = FirebaseAuth.instance.currentUser!.uid;

  Future<void> createChat(String idPerfil) async {
    //Referencias a coleção e documento
    final PerfilDocRef =
        FirebaseFirestore.instance.collection('perfis').doc(idPerfil);
    final contrDocRef =
        FirebaseFirestore.instance.collection('user').doc(idContr);
    //SnapShot e mapeamento para obet o idOfertante
    DocumentSnapshot PerfilSnapshot = await PerfilDocRef.get();
    Map<String, dynamic> perfilData =
        PerfilSnapshot.data() as Map<String, dynamic>;
    //Mapeamento para obter o id da Imagem de perfil de cada tipo de usuário
    final storageContRef = FirebaseStorage.instance
        .ref()
        .child('user_images/profile_images/${idContr}');
    final urlStorageCont = await storageContRef.getDownloadURL();
    final storageOfertRef = FirebaseStorage.instance
        .ref()
        .child('user_images/profile_images/${perfilData['idOfertante']}');
    final urlStorageOfer = await storageOfertRef.getDownloadURL();
    try {
      //Criação da coleção chat com os ids involvidos
      DocumentReference chatDocRef =
          await FirebaseFirestore.instance.collection('chat').add({
        'idOfertante': perfilData['idOfertante'],
        'idContratante': idContr,
        'OfertanteImage': urlStorageOfer,
        'ContratanteImage': urlStorageCont,
      });
      //Referencia da coleção user com id Ofertante
      final ofertanteDocRef = FirebaseFirestore.instance
          .collection('user')
          .doc(perfilData['idOfertante']);

//Inserção no no documento o campo id do chat
      await ofertanteDocRef.update({
        'chats': FieldValue.arrayUnion([chatDocRef.id]),
      });
      await contrDocRef.update({
        'chats': FieldValue.arrayUnion([chatDocRef.id]),
      });
    } catch (e) {
      print('Erro ao criar chat: $e');
    }
  }

  Future<String?> getNameUser(String idChat, String tipoUsuario) async {
    try {
      String? nomeUsuario;
      final chatDocRef =
          FirebaseFirestore.instance.collection('chat').doc(idChat);
      DocumentSnapshot chatSnapshot = await chatDocRef.get();
      Map<String, dynamic> chatData =
          chatSnapshot.data() as Map<String, dynamic>;

      String idOfertante = chatData['idOfertante'];
      String idContratante = chatData['idContratante'];

      if (tipoUsuario == 'ofertante') {
        final userDocRef =
            FirebaseFirestore.instance.collection('user').doc(idContratante);
        DocumentSnapshot userSnapshot = await userDocRef.get();
        Map<String, dynamic> userCont =
            userSnapshot.data() as Map<String, dynamic>;
        nomeUsuario = userCont['nome'];
      } else {
        final userDocRef =
            FirebaseFirestore.instance.collection('user').doc(idOfertante);
        DocumentSnapshot userSnapshot = await userDocRef.get();
        Map<String, dynamic> userOfer =
            userSnapshot.data() as Map<String, dynamic>;
        nomeUsuario = userOfer['nome'];
      }

      return nomeUsuario;
    } catch (e) {
      print('Erro ao obter nome de usuário: $e');
      return null;
    }
  }

  Future<String?> getUserType() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      final userDocRef =
          FirebaseFirestore.instance.collection('user').doc(userId);
      DocumentSnapshot userSnapshot = await userDocRef.get();

      if (userSnapshot.exists) {
        Map<String, dynamic>? userData =
            userSnapshot.data() as Map<String, dynamic>?;

        if (userData != null) {
          String userType = userData[
              'tipo conta']; // Substitua 'tipo' pelo campo que armazena o tipo de usuário
          return userType;
        }
      }

      // Se o usuário não existir ou o campo 'tipo' não estiver presente
      return null;
    } catch (e) {
      print('Erro ao obter tipo de usuário: $e');
      return null;
    }
  }

  /*Future<void> createMensagens() async {
    try {
      // Referência para a coleção 'mensagens'
      CollectionReference mensagensCollection =
          FirebaseFirestore.instance.collection('mensagens');

      await mensagensCollection.add({
        'remetenteId': '',
        'chatId': '',
        'text': '',
        'timestamp': '',
      });

      print('Coleção de mensagens criada com sucesso!');
    } catch (e) {
      print('Erro ao criar coleção de mensagens: $e');
    }
  }*/
}
