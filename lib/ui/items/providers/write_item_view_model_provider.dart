import 'dart:io';

import 'package:auth_app_1/core/models/item.dart';
import 'package:auth_app_1/core/repositories/item_repository_provider.dart';
import 'package:auth_app_1/ui/providers/loading_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final writeItemViewModelProvider =
    ChangeNotifierProvider((ref) => WriteItemViewModel(ref.read));

class WriteItemViewModel extends ChangeNotifier {
  final Reader _reader;

  WriteItemViewModel(this._reader);

  Item? _initial;
  Item get initial =>
      _initial ??
      Item.empty().copyWith(
        createdAt: DateTime.now(),
      );
  set initial(Item initial) {
    _initial = initial;
  }

  String? get image => initial.image.isNotEmpty ? initial.image : null;

  bool get edit => initial.id.isNotEmpty;

  String? _title;
  String get title => _title ?? initial.title;
  set title(String title) {
    _title = title;
    notifyListeners();
  }

  String? _description;
  String get description => _description ?? initial.description;
  set description(String description) {
    _description = description;
    notifyListeners();
  }

  File? _file;
  File? get file => _file;
  set file(File? file) {
    _file = file;
    notifyListeners();
  }

  bool get enabled => title.isNotEmpty&&description.isNotEmpty&&(image!=null||file!=null);

  Loading get _loading => _reader(loadingProvider);

  ItemRepository get _repository => _reader(itemRepositoryProvider);

  Future<void> write() async {
    final updated = initial.copyWith(
      title: title,
      description: description,
    );
    _loading.start();
    try {
      await _repository.writeItem(updated, file: file);
      _loading.stop();
    } catch (e) {
      _loading.end();
      return Future.error("Something error!");
    }
  }

  void clear() {
    _initial = null;
    _title = null;
    _description = null;
    _file = null;
  }
}
