import 'package:auth_app_1/core/models/item.dart';
import 'package:auth_app_1/core/repositories/item_repository_provider.dart';
import 'package:auth_app_1/ui/items/providers/write_item_view_model_provider.dart';
import 'package:auth_app_1/ui/items/write_item_page.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ItemCard extends ConsumerWidget {
  const ItemCard({Key? key, required this.e}) : super(key: key);
  final Item e;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final style = theme.textTheme;
    return GestureDetector(
      onTap: () async {
        final writer = ref.read(writeItemViewModelProvider);
        writer.initial = e;
        await Navigator.pushNamed(context, WriteItemPage.route);
        writer.clear();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Dismissible(
          key: ValueKey(e.id),
          direction: DismissDirection.startToEnd,
          onDismissed: (v) {
            ref.read(itemRepositoryProvider).delete(e.id);
          },
          background: Material(
            borderRadius: BorderRadius.circular(12),
            color: theme.errorColor,
            child: AspectRatio(
              aspectRatio: 3,
              child: Row(
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: Center(
                      child: Icon(
                        Icons.delete,
                        color: scheme.onError,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          confirmDismiss: (v) async {
            return await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("Are you sure you want to delete this item?"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("NO")),
                  MaterialButton(
                    color: theme.errorColor,
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: Text("YES"),
                  ),
                ],
              ),
            );
          },
          child: Card(
            margin: EdgeInsets.zero,
            child: AspectRatio(
              aspectRatio: 3,
              child: Row(
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: Image.network(
                      e.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "${e.title}\n",
                            style: style.titleMedium,
                            maxLines: 2,
                          ),
                          Expanded(
                            child: Text(
                              "${e.description}\n",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
