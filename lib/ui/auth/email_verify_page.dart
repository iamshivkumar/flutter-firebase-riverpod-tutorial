import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:auth_app_1/ui/auth/providers/auth_view_model_provider.dart';
import 'package:auth_app_1/ui/components/snackbar.dart';
import 'package:auth_app_1/ui/root.dart';
import 'package:auth_app_1/utils/labels.dart';

class EmailVerifyPage extends ConsumerStatefulWidget {
  const EmailVerifyPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EmailVerifyPageState();
}

class _EmailVerifyPageState extends ConsumerState<EmailVerifyPage> {
  final provider = authViewModelProvider;

  void onDone(){
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, Root.route);
  }

  @override
  void initState() {
    ref.read(provider).streamCheck(onDone: onDone);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final styles = theme.textTheme;
    final model = ref.read(provider);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await model.logout();
              onDone();
            },
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            Text(
              Labels.verifyYouEmail,
              style: styles.headlineLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              Labels.verificationEmailLink(model.user!.email!),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await model.reload();
                  if (model.user!.emailVerified) {
                    // ignore: use_build_context_synchronously
                    onDone();
                  } else {
                    // ignore: use_build_context_synchronously
                    AppSnackbar(context).error(Labels.emailNotVerifiedYet);
                  }
                },
                child: const Text(Labels.done),
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () async {
                  try {
                  await  model.sendEmail();
                  // ignore: use_build_context_synchronously
                  AppSnackbar(context).message(Labels.verificationEmailResent);
                  } catch (e) {
                    if (kDebugMode) {
                      print(e);
                    }
                  }
                },
                child: const Text(Labels.resend),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
  }

