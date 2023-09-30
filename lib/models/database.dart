import 'package:cloud_firestore/cloud_firestore.dart';

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

  Future addUsersInfoToDB(Map<String, dynamic> usersInfoMap) {
    return FirebaseFirestore.instance.collection("userofer").add(usersInfoMap);
  }

  Future addServicosInfoToDB(Map<String, dynamic> servicosInfoMap) {
    return FirebaseFirestore.instance
        .collection("servicos")
        .add(servicosInfoMap);
  }

  Future updateServicosinfoToDB(
      Map<String, dynamic> servicosInfoMap, String idServico) {
    return FirebaseFirestore.instance
        .collection("servicos")
        .doc(idServico)
        .set(servicosInfoMap);
  }
}
