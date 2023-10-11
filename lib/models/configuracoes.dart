import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class config {
  CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection("servicos");
}
