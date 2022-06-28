import 'dart:io';

import 'package:auth_app_1/ui/components/loading_layer.dart';
import 'package:auth_app_1/ui/components/snackbar.dart';
import 'package:auth_app_1/ui/items/providers/write_item_view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class WriteItemPage extends ConsumerWidget {
  const WriteItemPage({Key? key}) : super(key: key);
  static const String route = "/writeItem";
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final scheme = theme.colorScheme;
    final provider = writeItemViewModelProvider;
    final model = ref.read(writeItemViewModelProvider);
    return LoadingLayer(
      child: Scaffold(
        appBar: AppBar(
          title: Text("${model.edit ? "Edit" : "Add"} Item"),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Consumer(
            builder: (context,ref,child) {
              ref.watch(provider);
              return MaterialButton(
                padding: const EdgeInsets.all(16),
                color: scheme.primary,
                onPressed: model.enabled
                    ? () async {
                        try {
                          await model.write();
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        } catch (e) {
                          AppSnackbar(context).error(e);
                        }
                      }
                    : null,
                child: const Text("DONE"),
              );
            }
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () async {
                  final picked =
                      await ImagePicker().pickImage(source: ImageSource.gallery);
                  if (picked != null) {
                    model.file = File(picked.path);
                  }
                },
                child: Consumer(
                  builder: (context,ref,child) {
                    ref.watch(provider.select((value) => value.file));
                    return Container(
                      height: 200,
                      width: 200,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          color: scheme.primaryContainer,
                          borderRadius: BorderRadius.circular(20),
                          image: (model.image != null || model.file != null)
                              ? DecorationImage(
                                  image: model.file != null
                                      ? FileImage(model.file!)
                                      : NetworkImage(model.image!) as ImageProvider,
                                  fit: BoxFit.cover,
                                )
                              : null),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (model.image == null && model.file == null)
                            Expanded(
                              child: Center(
                                child: Icon(
                                  Icons.photo,
                                  color: scheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                          Material(
                            color: theme.cardColor.withOpacity(0.5),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Pick Image".toUpperCase(),
                                style: style.bodySmall,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                initialValue: model.title,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: "Title",
                ),
                onChanged: (v) => model.title = v,
              ),
              const SizedBox(height: 24),
              TextFormField(
                maxLines: 10,
                minLines: 5,
                textInputAction: TextInputAction.done,
                initialValue: model.description,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: "Description",
                ),
                onChanged: (v) => model.description = v,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
