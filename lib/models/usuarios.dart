import 'package:firebase_auth/firebase_auth.dart';
import 'database.dart';

class Usuarios {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<User> getcurrentUser() async {
    return await auth.currentUser!;
  }

  Future<void> createOfer(
      String idOfer, String cpf, String cidade, String uf, context) async {
    Map<String, dynamic> usersInfoMap = {
      'idOfer': idOfer,
      'cpf': cpf,
      'cidade': cidade,
      'uf': uf,
    };

    DatabaseMethods().addUsersInfoToDB(usersInfoMap);
  }
}
