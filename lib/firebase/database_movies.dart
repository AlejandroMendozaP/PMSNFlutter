import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class DatabaseMovies {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference? collectionReference;

  DatabaseMovies(){
    collectionReference = firebaseFirestore.collection('movies');
  }

  Future<bool> insert (Map<String,dynamic> movies) async {
    try {
      collectionReference!.doc().set(movies);
      return true;
    } catch (e) {
      kDebugMode ? print(e): '';
    }
    return false;
  }

  Future<void> delete (String UId) async {
    return collectionReference!.doc(UId).delete();
  }

  Future<bool> update (Map<String,dynamic> movies, String UId) async {
    try {
      collectionReference!.doc(UId).update(movies);
      return true;
    } catch (e) {
      kDebugMode ? print(e): '';
    }
    return false;
  }

  Stream<QuerySnapshot> select (){
    return collectionReference!.snapshots();
  }
}