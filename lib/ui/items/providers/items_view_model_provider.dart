import 'package:auth_app_1/core/models/item.dart';
import 'package:auth_app_1/core/repositories/item_repository_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final itemsViewModelProvider = ChangeNotifierProvider((ref) {
  final model = ItemsViewModel(ref.read);
  model.init();
  return model;
});

class ItemsViewModel extends ChangeNotifier {
  final Reader _reader;
  ItemsViewModel(this._reader);

  ItemRepository get _repository => _reader(itemRepositoryProvider);

  final List<DocumentSnapshot> _itemsDocs = [];

  List<Item> get items => _itemsDocs.map((e) => Item.fromFirestore(e)).toList();

  bool loading = true;
  bool busy = true;

  void init() async {
    try {
      _itemsDocs.addAll(await _repository.itemsPaginateFuture(limit: 8));
      busy = false;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void loadMore() async {
    busy = true;
    try {
      final moreItemsDocs = await _repository.itemsPaginateFuture(
        limit: 4,
        lastDocument: _itemsDocs.last,
      );
      _itemsDocs.addAll(moreItemsDocs);
      loading = moreItemsDocs.isNotEmpty;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    busy = false;
    notifyListeners();
  }
}
