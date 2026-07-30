import 'package:cloud_firestore/cloud_firestore.dart';

//its like schema of the collection we are creating
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //IMplementing the CRUD OPeration : create a user
  Future<void> createUser({
    required String uid,
    required String name,
    required String email,
  }) async {
    await _firestore.collection("users").doc(uid).set({
      "name": name,
      "email": email,
      "createdAt": FieldValue.serverTimestamp(),
      //because the timestamp comes from Firebase's server, 
      //not the user's phone. If a user's phone clock is wrong, 
      //your data is still consistent.
    });
  }
}
