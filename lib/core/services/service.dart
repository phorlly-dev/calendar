import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Service {
  final firestore = FirebaseFirestore.instance;

  /// Create (Add) a new document with auto ID
  Future<String> create<T>({
    required T model,
    required String collection,
    required Map<String, dynamic> Function(T model) toMap,
  }) async {
    final docRef = firestore.collection(collection).doc();
    final data = toMap(model);

    data['id'] = docRef.id;
    await docRef.set(data);

    return docRef.id;
  }

  /// Read all documents from a collection
  Future<List<T>> readAll<T>({
    required String collection,
    required T Function(Map<String, dynamic> data, String docId) fromMap,
  }) async {
    final snapshot = await firestore.collection(collection).get();

    return snapshot.docs.map((doc) => fromMap(doc.data(), doc.id)).toList();
  }

  /// Stream documents in real-time
  Stream<List<T>> streamAll<T>({
    required String collection,
    required T Function(Map<String, dynamic> data, String docId) fromMap,
  }) {
    return firestore.collection(collection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => fromMap(doc.data(), doc.id)).toList();
    });
  }

  /// Update an existing document by ID
  Future<void> modify({
    required String collection,
    required String docId,
    required Map<String, dynamic> toMap,
  }) async {
    await firestore.collection(collection).doc(docId).update(toMap);
  }

  /// Delete a document by ID
  Future<void> delete({
    required String collection,
    required String docId,
  }) async {
    await firestore.collection(collection).doc(docId).delete();
  }

  /// Get a single document by ID
  Future<T?> readOne<T>({
    required String collection,
    required String docId,
    required T Function(Map<String, dynamic> data, String docId) fromMap,
  }) async {
    final doc = await firestore.collection(collection).doc(docId).get();

    if (doc.exists) {
      return fromMap(doc.data()!, doc.id);
    }

    return null;
  }

  //Stream builder for reuseable widget
  StreamBuilder<List<T>> streamBuilder<T>({
    required String collection,
    required T Function(Map<String, dynamic> data, String docId) fromMap,
    required Widget Function(BuildContext context, List<T> data) builder,
  }) {
    return StreamBuilder<List<T>>(
      stream: streamAll(collection: collection, fromMap: fromMap),
      builder: (context, snapshot) {
        // log('snapshot: ${snapshot.data}');
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data found'));
        } else {
          return builder(context, snapshot.data!);
        }
      },
    );
  }
}
