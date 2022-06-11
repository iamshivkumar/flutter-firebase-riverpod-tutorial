import 'package:auth_app_1/ui/items/providers/write_item_view_model_provider.dart';
import 'package:auth_app_1/ui/items/widgets/item_card.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:auth_app_1/ui/auth/providers/auth_view_model_provider.dart';
import 'package:auth_app_1/ui/items/providers/items_provider.dart';
import 'package:auth_app_1/ui/items/write_item_page.dart';
import 'package:auth_app_1/ui/root.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(itemsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Items"),
        actions: [
          IconButton(
            onPressed: () async {
              await ref.read(authViewModelProvider).logout();
              // ignore: use_build_context_synchronously
              Navigator.pushReplacementNamed(context, Root.route);
            },
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, WriteItemPage.route);
          ref.read(writeItemViewModelProvider).clear();
        },
        child: const Icon(Icons.add),
      ),
      body: itemsAsync.when(
        data: (items) => ListView(
          padding: const EdgeInsets.all(8),
          children: items
              .map(
                (e) => ItemCard(e: e),
              )
              .toList(),
        ),
        error: (e, s) => Center(
          child: Text('$e'),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
