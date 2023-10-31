import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ConfigM {
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
      return downloadUrl; // Retorna a URL da imagem se encontrada
    } catch (e) {
      print('Nenhuma imagem encontrada no Firebase Storage.');
      return null; // Retorna null se nenhuma imagem for encontrada.
    }
  }
}
