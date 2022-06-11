import 'package:auth_app_1/core/models/item.dart';
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
    final style = theme.textTheme;
    return GestureDetector(
      onTap: () async {
       final writer = ref.read(writeItemViewModelProvider);
       writer.initial = e;
       await Navigator.pushNamed(context, WriteItemPage.route);
       writer.clear();
      },
      child: Card(
        margin: const EdgeInsets.all(8),
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
                      Text(
                        "${e.description}\n",
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
