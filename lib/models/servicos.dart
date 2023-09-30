import 'package:firebase_auth/firebase_auth.dart';
import 'database.dart';

class Servicos {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> createServico(
      String nome, String tipo, String raca, context) async {
    Map<String, dynamic> servicosInfoMap = {
      'idofert': auth.currentUser?.uid,
      'Nome do servico': nome,
      'Especificacao': tipo,
    };

    DatabaseMethods().addServicosInfoToDB(servicosInfoMap);
  }
}
