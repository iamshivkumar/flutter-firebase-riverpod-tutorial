import 'package:auth_app_1/ui/providers/cache_provider.dart';
import 'package:auth_app_1/ui/root.dart';
import 'package:auth_app_1/utils/labels.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({Key? key}) : super(key: key);
  static const String route = "/";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    await ref.read(cacheProvider.future);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      Root.route,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final styles = theme.textTheme;
    return Scaffold(
      backgroundColor: scheme.primaryContainer,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.favorite,
              size: 80,
            ),
            const SizedBox(
              height: 24,
            ),
            Text(
              Labels.appName,
              style: styles.headlineLarge!
                  .copyWith(color: scheme.onPrimaryContainer),
            ),
          ],
        ),
      ),
    );
  }
}
