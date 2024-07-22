import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notesapp/Model/LoginModel.dart';

import 'Firebase_Exception.dart';

class FireStoreService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  Future<Map<String, dynamic>?> getDocument(
      String collection, String documentId) async {
    try {
      Map<String, dynamic>? data;
      DocumentSnapshot snapshot =
          await _fireStore.collection(collection).doc(documentId).get();
      if (snapshot.exists) {
        data = snapshot.data() as Map<String, dynamic>;
      }
      return data;
    } catch (e) {
      throw FirebaseeException('Error fetching document: $e');
    }
  }

  Future<void> sendNotes(
      String uid, String notesId, Map<String, dynamic> notesData) async {
    try {
      await _fireStore
          .collection('Notes')
          .doc(uid)
          .collection(notesId)
          .doc('UserNotes')
          .set(notesData);
    } catch (e) {
      throw FirebaseeException('Error adding document: $e');
    }
  }

  Future<void> updateUserData(Map<String, dynamic> newUserData) async {
    try {
      final user = _auth.currentUser!.uid;
      DocumentReference userRef = _fireStore.collection('users').doc(user);
      DocumentSnapshot snapshot = await userRef.get();
      if (snapshot.exists) {
        Map<String, dynamic> oldUserData =
            snapshot.data() as Map<String, dynamic>;
        final mergedData = {...oldUserData, ...newUserData};
        await userRef.update(mergedData);
      }
    } catch (e) {
      throw FirebaseeException('Error updating user data: ${e.toString()}');
    }
  }

  Future<LoginModel> getUserData(String uid) async {
    try {
      // Get a reference to the users collection
      CollectionReference usersRef =
          FirebaseFirestore.instance.collection('MetaData');

      // Get the document reference using the UID
      DocumentReference docRef = usersRef.doc(uid);

      // Get the document snapshot
      DocumentSnapshot docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        Map<String, dynamic> userData =
            docSnapshot.data() as Map<String, dynamic>;
        return LoginModel.fromJson(userData);
      } else {
        throw Exception('There is no data');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<DocumentSnapshot>> getDocuments(String collection) async {
    try {
      QuerySnapshot querySnapshot =
          await _fireStore.collection(collection).get();
      return querySnapshot.docs;
    } catch (e) {
      throw FirebaseeException('Error fetching document: $e');
    }
  }

  Stream<DocumentSnapshot?> listenToDocument(
      String collection, String documentId) {
    return _fireStore.collection(collection).doc(documentId).snapshots();
  }

  Stream<QuerySnapshot> listenToCollection(String collection) {
    return _fireStore.collection(collection).snapshots();
  }

  Future<void> addDocument(
      String collection, String doc, Map<String, dynamic> data) async {
    try {
      await _fireStore.collection(collection).doc(doc).set(data);
    } catch (e) {
      throw FirebaseeException('Error adding document: $e');
    }
  }

  Future<void> updateDocument(
      String collection, String documentId, Map<String, dynamic> data) async {
    try {
      await _fireStore.collection(collection).doc(documentId).update(data);
    } catch (e) {
      throw FirebaseeException('Error updating document: $e');
    }
  }

  Future<void> updateDocumentField(String collection, String documentId,
      Map<String, dynamic> updatedFields) async {
    try {
      await _fireStore
          .collection(collection)
          .doc(documentId)
          .update(updatedFields);
    } catch (e) {
      throw FirebaseeException('Error updating document: $e');
    }
  }

  Future<void> deleteDocument(String collection, String documentId) async {
    try {
      await _fireStore.collection(collection).doc(documentId).delete();
    } catch (e) {
      throw FirebaseeException('Error deleting document: $e');
    }
  }
}
