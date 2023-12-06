import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FeedbackM {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String idCont = FirebaseAuth.instance.currentUser!.uid;

  Future<void> createFeedback(
      String idChat, double nota, String conteudo) async {
    String servicofinalizado = 'C';
    await FirebaseFirestore.instance.collection('chat').doc(idChat).update({
      'servicoFinalizado': servicofinalizado,
    });
    final chatRef = FirebaseFirestore.instance.collection('chat').doc(idChat);
    DocumentSnapshot chatSnapshot = await chatRef.get();

    Map<String, dynamic>? chatData =
        chatSnapshot.data() as Map<String, dynamic>?;

    if (chatData != null && chatData.containsKey('idPerfil')) {
      DocumentReference feedbackRed =
          await FirebaseFirestore.instance.collection('feedback').add({
        'userId': idCont,
        'idPerfil': chatData['idPerfil'],
        'nota': nota,
        'conteudo': conteudo,
      });
    }
  }

  Future<List<Map<String, dynamic>>> getFeedbacks(String idPerfil) async {
    List<Map<String, dynamic>> feedbackList = [];

    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('feedback')
              .where('idPerfil', isEqualTo: idPerfil)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        feedbackList = querySnapshot.docs
            .map((doc) => doc.data())
            .toList(); // Mapeia os documentos para a lista
      }
    } catch (e) {
      print("Erro ao obter feedbacks: $e");
    }

    return feedbackList;
  }
}
