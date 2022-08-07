import 'package:auth_app_1/ui/auth/providers/auth_view_model_provider.dart';
import 'package:auth_app_1/ui/auth/register_page.dart';
import 'package:auth_app_1/ui/components/loading_layer.dart';
import 'package:auth_app_1/ui/components/snackbar.dart';
import 'package:auth_app_1/ui/root.dart';
import 'package:auth_app_1/utils/labels.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerWidget {
  LoginPage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final styles = theme.textTheme;
    final provider = authViewModelProvider;
    final model = ref.read(authViewModelProvider);
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
                      Labels.signIn,
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
                    const SizedBox(height: 24),
                    Consumer(
                      builder: (context, ref, child) {
                        ref.watch(provider);
                        return MaterialButton(
                          color: scheme.primaryContainer,
                          padding: const EdgeInsets.all(16),
                          onPressed: model.email.isNotEmpty &&
                                  model.password.isNotEmpty
                              ? () async {
                                  if (_formKey.currentState!.validate()) {
                                    try {
                                      await model.login();
                                      // ignore: use_build_context_synchronously
                                      Navigator.pushReplacementNamed(
                                        context,
                                        Root.route,
                                      );
                                    } catch (e) {
                                      AppSnackbar(context).error(e);
                                    }
                                  }
                                }
                              : null,
                          child: Text(Labels.signIn.toUpperCase()),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: Labels.dontHaveAnAccount,
                        style: styles.bodyLarge,
                        children: [
                          TextSpan(
                              text: Labels.signUp,
                              style: styles.button!.copyWith(
                                  fontSize: styles.bodyLarge!.fontSize),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacementNamed(
                                      context, RegisterPage.route);
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
