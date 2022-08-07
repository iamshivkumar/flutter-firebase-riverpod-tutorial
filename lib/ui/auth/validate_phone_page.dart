// ignore_for_file: use_build_context_synchronously

import 'package:auth_app_1/ui/auth/providers/auth_view_model_provider.dart';
import 'package:auth_app_1/ui/components/loading_layer.dart';
import 'package:auth_app_1/ui/components/snackbar.dart';
import 'package:auth_app_1/ui/root.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ValidatePhonePage extends HookConsumerWidget {
  const ValidatePhonePage({super.key});
  static const route = "/validatePhone";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final style = theme.textTheme;
    final model = ref.read(authViewModelProvider);
    final controller = useTextEditingController();
    return LoadingLayer(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16).copyWith(bottom: 64),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Verify with Phone",
                style: style.headlineLarge,
              ),
              const SizedBox(height: 8),
              Text(
                "Verification code has been sent to +91${model.phone}",
              ),
              const SizedBox(
                height: 24,
              ),
              TextFormField(
                controller: controller,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: "Enter the verification code",
                ),
                inputFormatters: [
                  model.formatter,
                ],
                onChanged: (v) async {
                  final code = model.formatter.getUnmaskedText();
                  if (code.length == 6) {
                    try {
                      await model.validatePhone(code);
                      Navigator.pushNamedAndRemoveUntil(
                          context, Root.route, (route) => false);
                    } catch (e) {
                      controller.clear();
                      AppSnackbar(context).error(e);
                    }
                  }
                },
              ),
              const SizedBox(
                height: 16,
              ),
              StreamBuilder<int>(
                initialData: 30,
                stream: model.stream,
                builder: (context, snapshot) {
                  final count = snapshot.data!;
                  return TextButton.icon(
                    onPressed: count < 0
                        ? () {
                            model.sendOtp(
                                onCodeSent: () {},
                                onMessage: (v) {
                                  AppSnackbar(context).message(v);
                                },
                                onError: (e) => AppSnackbar(context).error(e),
                                onCompleted: () {
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, Root.route, (route) => false);
                                });
                          }
                        : null,
                    icon: const Icon(Icons.refresh),
                    label:
                        Text("Resend Code${count >= 0 ? " in ${count}s" : ""}"),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
