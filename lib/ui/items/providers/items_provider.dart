import 'package:auth_app_1/core/models/item.dart';
import 'package:auth_app_1/core/repositories/item_repository_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final itemsProvider = StreamProvider<List<Item>>(
  (ref) => ref.read(itemRepositoryProvider).itemsStream,
);
