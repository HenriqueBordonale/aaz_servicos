import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

class DatabaseMethods {
  Future addUserInfoToDB(String userId, Map<String, dynamic> userInfoMap) {
    return FirebaseFirestore.instance
        .collection("user")
        .doc(userId)
        .set(userInfoMap);
  }

  Future<DocumentSnapshot> getUserFromDB(String userId) {
    return FirebaseFirestore.instance.collection("user").doc(userId).get();
  }

  Future<void> uploadImage(File imageFile) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('Usuário não autenticado.');
      return;
    }

    final storage = FirebaseStorage.instance;
    final folderRef =
        storage.ref().child('user_images/profile_images/${user.uid}');

    // Exclua a imagem existente na pasta, se houver
    try {
      await folderRef.delete();
    } catch (e) {
      print('Nenhuma imagem para excluir.');
    }

    // Faça o upload da nova imagem
    try {
      await folderRef.putFile(imageFile);
      print('Imagem enviada com sucesso.');
    } catch (error) {
      print('Erro ao enviar a imagem: $error');
    }
  }

  Future<String?> checkIfImageExists() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('Usuário não autenticado.');
      return null; // Retorna null se o usuário não estiver autenticado.
    }

    final storageRef = FirebaseStorage.instance
        .ref()
        .child('user_images/profile_images/${user.uid}');
    try {
      final downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl; // Retorna a URL de download da imagem se existir.
    } catch (e) {
      print('Nenhuma imagem encontrada no Firebase Storage.');
      return null; // Retorna null se nenhuma imagem for encontrada.
    }
  }

  Future<String?> checKTipoUsuario() async {
    try {
      String idofer = FirebaseAuth.instance.currentUser!.uid;

      final querySnapshot = await FirebaseFirestore.instance
          .collection('user')
          .where('uid', isEqualTo: idofer)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final document = querySnapshot.docs.first;
        // Verifique se o campo 'tipo usuario' existe no documento
        if (document.data().containsKey('tipo conta')) {
          final tipousuario = document['tipo conta'] as String;
          print('Valor de tipoUsuario: $tipousuario');
          return tipousuario;
        } else {
          print('Campo "tipo usuario" não encontrado no documento.');
          return null;
        }
      } else {
        print('Nenhum documento encontrado com o UID fornecido.');
        return null;
      }
    } catch (e) {
      print('Erro ao buscar o tipo de usuário: $e');
      return null;
    }
  }

  Future<String?> getUserName() async {
    // Verifica se há um usuário autenticado
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Obtém o UID do usuário autenticado
      String uid = user.uid;

      // Consulta a coleção 'user' utilizando o UID
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('user').doc(uid).get();

      // Verifica se o documento existe e contém o campo 'name'
      if (snapshot.exists) {
        String? userName = snapshot['nome'];
        return userName;
      } else {
        // O documento não existe ou não contém o campo 'name'
        return null;
      }
    }
  }

  Future<String?> getUrlImage(String idUser) async {
    try {
      final storageUserRef = FirebaseStorage.instance
          .ref()
          .child('user_images/profile_images/${idUser}');
      final urlStorageUser = await storageUserRef.getDownloadURL();

      return urlStorageUser;
    } catch (e) {
      print('Erro ao obter URL da imagem: $e');
      return null; // Retorna null se não conseguir obter a URL da imagem
    }
  }

// Exemplo de uso:
  void main() async {
    String? userName = await getUserName();
    if (userName != null) {
      print('Nome do usuário: $userName');
    } else {
      print('Usuário não autenticado ou nome não encontrado.');
    }
  }
}
