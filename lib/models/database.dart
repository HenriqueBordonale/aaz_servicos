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

  Future addSrvicosinfoToDB(Map<String, dynamic> petsInfoMap) {
    return FirebaseFirestore.instance.collection("pets").add(petsInfoMap);
  }

  Future updatSrvicosinfoToDB(Map<String, dynamic> petsInfoMap, String idPet) {
    return FirebaseFirestore.instance
        .collection("pets")
        .doc(idPet)
        .set(petsInfoMap);
  }
}
