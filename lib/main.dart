import 'package:auth_app_1/firebase_options.dart';
import 'package:auth_app_1/ui/router.dart';
import 'package:auth_app_1/ui/splash/splash_page.dart';
import 'package:auth_app_1/utils/labels.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(seedColor: Colors.indigo);
    return MaterialApp(
      title: Labels.appName,
      theme: ThemeData(
        cardTheme: const CardTheme(clipBehavior: Clip.antiAlias),
        useMaterial3: true,
        colorScheme: colorScheme,
        primaryColor: colorScheme.primary,
        buttonTheme: const ButtonThemeData(
          shape: StadiumBorder(),
          textTheme: ButtonTextTheme.primary,
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ).apply(
          displayColor: colorScheme.onSurface.withOpacity(0.75),
          bodyColor: colorScheme.onSurface,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 20,
          ),
        ),
      ),
      initialRoute: SplashPage.route,
      onGenerateRoute: AppRouter.onNavigate,
    );
  }
}
