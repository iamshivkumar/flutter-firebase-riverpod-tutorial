import 'package:auth_app_1/ui/components/loading_layer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/labels.dart';
import '../components/snackbar.dart';
import '../root.dart';
import 'providers/auth_view_model_provider.dart';

class RegisterPage extends ConsumerWidget {
  RegisterPage({Key? key}) : super(key: key);

  static const String route = "/register";

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final styles = theme.textTheme;
    final provider = authViewModelProvider;
    final model = ref.read(provider);
    final height = MediaQuery.of(context).size.height;
    return LoadingLayer(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.favorite,
                      size: 80,
                      color: scheme.primary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      Labels.appName.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: styles.titleLarge,
                    ),
                    SizedBox(height: height / 12),
                    Text(
                      Labels.signUp,
                      style: styles.headlineLarge,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      initialValue: model.email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email_outlined),
                        labelText: Labels.email,
                      ),
                      onChanged: (v) => model.email = v,
                      validator: (v) => model.emailValidate(v!),
                    ),
                    const SizedBox(height: 16),
                    Consumer(
                      builder: (context, ref, child) {
                        ref.watch(
                            provider.select((value) => value.obscurePassword));
                        return TextFormField(
                          obscureText: model.obscurePassword,
                          initialValue: model.password,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                            labelText: Labels.password,
                            suffixIcon: IconButton(
                              onPressed: () {
                                model.obscurePassword = !model.obscurePassword;
                              },
                              icon: Icon(model.obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined),
                            ),
                          ),
                          onChanged: (v) => model.password = v,
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Consumer(
                      builder: (context, ref, child) {
                        ref.watch(provider
                            .select((value) => value.obscureConfirmPassword));
                        return TextFormField(
                          obscureText: model.obscureConfirmPassword,
                          initialValue: model.confirmPassord,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                            labelText: Labels.confirmPassword,
                            suffixIcon: IconButton(
                              onPressed: () {
                                model.obscureConfirmPassword =
                                    !model.obscureConfirmPassword;
                              },
                              icon: Icon(model.obscureConfirmPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined),
                            ),
                          ),
                          onChanged: (v) => model.confirmPassord = v,
                          validator: (v) =>
                              v != model.password ? "Mismatch Password!" : null,
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    Consumer(
                      builder: (context, ref, child) {
                        ref.watch(provider);
                        return MaterialButton(
                          color: scheme.primaryContainer,
                          padding: const EdgeInsets.all(16),
                          onPressed: model.email.isNotEmpty &&
                                  model.password.isNotEmpty &&
                                  model.confirmPassord.isNotEmpty
                              ? () async {
                                  if (_formKey.currentState!.validate()) {
                                    try {
                                      await model.register();
                                      // ignore: use_build_context_synchronously
                                      Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        Root.route,
                                        (route) => false,
                                      );
                                    } catch (e) {
                                      AppSnackbar(context).error(e);
                                    }
                                  }
                                }
                              : null,
                          child: Text(Labels.signUp.toUpperCase()),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: Labels.alreadyHaveAnAccount,
                        style: styles.bodyLarge,
                        children: [
                          TextSpan(
                              text: Labels.signIn,
                              style: styles.button!.copyWith(
                                  fontSize: styles.bodyLarge!.fontSize),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacementNamed(
                                      context, Root.route);
                                }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
