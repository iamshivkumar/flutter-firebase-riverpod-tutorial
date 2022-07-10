import 'dart:io';

import 'package:auth_app_1/core/models/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final itemRepositoryProvider = Provider((ref) => ItemRepository());

class ItemRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> writeItem(Item item, {File? file}) async {
    final ref =
        _firestore.collection("items").doc(item.id.isEmpty ? null : item.id);
    final String? imageUrl = file != null
        ? await (await _storage.ref("images").child(ref.id).putFile(file))
            .ref
            .getDownloadURL()
        : null;

    await ref.set(
      item.copyWith(image: imageUrl).toMap(),
      SetOptions(merge: true),
    );
  }

  Stream<List<Item>> get itemsStream => _firestore
      .collection('items')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map(
        (event) => event.docs
            .map(
              (e) => Item.fromFirestore(e),
            )
            .toList(),
      );

  void delete(String id) {
    _firestore.collection("items").doc(id).delete();
  }

  Future<List<DocumentSnapshot>> itemsPaginateFuture(
      {required int limit, DocumentSnapshot? lastDocument}) async {
    var docRef =
        _firestore.collection('items').orderBy('createdAt', descending: true);

    if (lastDocument != null) {
      docRef = docRef.startAfterDocument(lastDocument);
    }

    return docRef.limit(limit).get().then((value) => value.docs);
  }
}
