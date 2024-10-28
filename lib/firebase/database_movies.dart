import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMovies {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference? collectionReference;

  DatabaseMovies(){
    collectionReference = firebaseFirestore.collection('movies');
  }

  Future<void> insert (Map<String,dynamic> movies) async {
    return collectionReference!.doc().set(movies);
  }

  Future<void> delete (String UId) async {
    return collectionReference!.doc(UId).delete();
  }

  Future<void> update (Map<String,dynamic> movies, String UId) async {
    return collectionReference!.doc(UId).update(movies);
  }

  Stream<QuerySnapshot> select (){
    return collectionReference!.snapshots();
  }
}