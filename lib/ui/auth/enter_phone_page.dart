import 'package:auth_app_1/ui/auth/providers/auth_view_model_provider.dart';
import 'package:auth_app_1/ui/auth/validate_phone_page.dart';
import 'package:auth_app_1/ui/components/loading_layer.dart';
import 'package:auth_app_1/ui/components/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../root.dart';

class EnterPhonePage extends ConsumerWidget {
  const EnterPhonePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final style = theme.textTheme;
    final provider = authViewModelProvider;
    final model = ref.read(provider);
    return LoadingLayer(
      child: Scaffold(
        bottomNavigationBar: SizedBox(
          height: MediaQuery.of(context).padding.bottom,
        ),
        bottomSheet: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Consumer(builder: (context, ref, child) {
                ref.watch(provider.select((value) => value.phone));
                return MaterialButton(
                  child: Text("Continue"),
                  padding: const EdgeInsets.all(16),
                  color: scheme.primaryContainer,
                  disabledColor: scheme.primaryContainer.withOpacity(0.5),
                  onPressed: model.phone.length == 10
                      ? () {
                          model.sendOtp(
                            onCompleted: () {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                Root.route,
                                (route) => false,
                              );
                            },
                            onCodeSent: () {
                              Navigator.pushNamed(
                                  context, ValidatePhonePage.route);
                            },
                            onMessage: (v) {
                              AppSnackbar(context).message(v);
                            },
                            onError: (e) {
                              AppSnackbar(context).error(e);
                            },
                          );
                        }
                      : null,
                );
              }),
            ),
          ),
        ),
        appBar: AppBar(
          title: const Text("My App"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16).copyWith(bottom: 64),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Continue with Phone",
                style: style.headlineLarge,
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                initialValue: model.phone,
                maxLength: 10,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "Enter you phone number",
                  prefixText: "+91 ",
                ),
                onChanged: (v) => model.phone = v,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
